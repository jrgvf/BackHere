module Backhere
  module Api
    module StatusActions

      def find_or_create_status(remote_status)
        status =  Status.find_or_initialize_by(code: remote_status[:code])

        new_label = remote_status[:label] unless remote_status[:label].blank?
        status.label = new_label unless new_label.nil?
        status.label ||= remote_status[:code]

        status_type = StatusType.find_by(code: remote_status[:status_type]) unless remote_status[:status_type].blank?
        status.status_type = status_type unless status_type.nil?
        
        status.save!
      end

    end
  end
end