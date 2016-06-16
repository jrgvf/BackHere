class DelayerTask
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Multitenancy::Document

  tenant(:account)

  field :platform_ids,      type: Array
  field :type,              type: Symbol
  field :interval,          type: String
  field :time_from,         type: Integer
  field :time_to,           type: Integer
  field :days,              type: Array
  field :last_task,         type: DateTime

  validates_presence_of :platform_ids, :type, :interval, :time_from, :time_to, :days

  DAYS_VALUES = {
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  def self.intervals
    [["5 minutos", :minutes_5], ["15 minutos", :minutes_15], ["30 minutos", :minutes_30]].concat(
      (1..12).map { |n| ["#{n} hora#{'s' if n > 1 }", "hours_#{n}".to_sym]}
    )
  end

  def self.days
    [
      ["Segunda-feira", :monday], ["Terça-feira", :tuesday], ["Quarta-feira", :wednesday],
      ["Quinta-feira", :thursday], ["Sexta-feira", :friday], ["Sábado", :saturday], ["Domingo", :sunday]
    ]
  end

  def self.hours_from
    (0..23).map { |n| ["#{n < 10 ? '0' + n.to_s : n}:00", n]}
  end

  def self.hours_to
    (1..24).map { |n| ["#{(n-1) < 10 ? '0' + (n-1).to_s : (n-1)}:59", n]}
  end

  def platforms
    Platform.where(account: account).in(id: platform_ids)
  end

  def platforms_name
    platforms.map(&:name).join(" | ")
  end

  def task_name
    TaskFactory.find_by_type(type).task_name
  end

  def interval_name
    DelayerTask.intervals.map { |x| x[0] if x[1].to_s == interval }.compact.first || interval.to_s
  end

  def time_range
    "#{time_from}:00 - #{time_to-1}:59"
  end

  def days_range
    DelayerTask.days.map {|x| x[0] if days.include?(x[1].to_s) }.compact.join(" | ")
  end

  def self.run_all
    Account.actives.each { |account| try_create_tasks(account) }
  end

  def self.try_create_tasks(account)
    Mongoid::Multitenancy.with_tenant(account) do
      DelayerTask.where(account: account).each do |delayer_task|

        last_time = delayer_task.cron_line.previous_time(Time.now)
        next unless delayer_task.should_create_task?(last_time)

        delayer_task.platforms.each do |platform|
          task = TaskFactory.build(delayer_task.type, delayer_task.task_params(platform))
          TaskTrigger.try_execute(task) if task && task.save
        end

        delayer_task.update_attributes!(last_task: last_time)
      end
    end
  end

  def task_params(platform)
    {
      platform_id: platform.id.to_s,
      platform_name: platform.name
    }
  end

  def should_create_task?(last_time)
    Time.now > last_time && (last_task.nil? || last_task < last_time)
  end

  def cron_line
    Rufus::Scheduler::CronLine.new(extract_cron)
  end

  def extract_cron
    return @cron unless @cron.nil?

    cron = Hash.new
    cron[interval.split('_').first.to_sym] = interval.split('_').last
    cron[:minutes] = cron[:minutes] ? "*/#{cron[:minutes]}" : "0"
    cron[:range] = "#{time_from}-#{time_to}"
    cron[:range] << "/#{cron[:hours]}" if cron[:hours]
    cron[:days] = days.map{ |day| DAYS_VALUES[day.to_sym] }.join(',')

    @cron = "#{cron[:minutes]} #{cron[:range]} * * #{cron[:days]}"
  end

end