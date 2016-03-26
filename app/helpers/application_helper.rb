module ApplicationHelper

  # Set active class of sidebar
  def active_class(*link_path)
    link_path.each { |path| return "active" if request.fullpath.include?(path) }
    nil
  end

  def root_active_class
    return "active" if request.fullpath == root_path
    nil
  end

  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "BackHere!"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

   # Returns the full breadcrumb on a per-page basis.
  def full_breadcrumb(levels = [])
    concat(content_tag(:li) do
      concat(content_tag(:a, href: root_path) do
        concat content_tag(:i, " BackHere", class: "fa fa-dashboard")
      end)
    end)
    levels = levels.split(',')
    levels.each do |level|
      if levels[-1] == level
        concat(content_tag(:li, class: "active") do
          concat level
        end)
      else
        concat(content_tag(:li) do
          concat level
        end)
      end
    end
    nil
  end

  def profile_image
    concat_profile_image "img-circle"
    nil
  end

  def profile_image_small
    concat_profile_image "user-image"
    nil
  end

  def concat_profile_image img_class
    if current_user.avatar.present?
      concat(image_tag(current_user.avatar.url(:profile), class: img_class, alt:"User Image"))
    else
      concat(image_tag("default_user.png", class: img_class, alt:"User Image"))
    end
  end

  def bootstrap_class_for flash_type
    { success: "alert-success", error: "alert-danger", alert: "alert-warning", notice: "alert-info" }[flash_type.to_sym] || "alert-info"
  end

  def bootstrap_icon_for flash_type
    { success: "thumbs-o-up", error: "hand-stop-o", alert: "thumbs-o-down", notice: "hand-peace-o" }[flash_type.to_sym] || "wrench"
  end

  def flash_messages(opts = {})
    flash.each do |msg_type, message|
      concat(content_tag(:div, message, class: "alert #{bootstrap_class_for(msg_type)} alert-dismissible", role: 'alert') do
        concat(content_tag(:button, class: 'close', data: { dismiss: 'alert' }) do
          concat content_tag(:span, 'Close', class: 'sr-only')
          concat content_tag(:i, '', class: "fa fa-power-off", 'aria-hidden' => true)
        end)
        add_icon(msg_type) unless opts[:sign_in] == true
        concat content_tag(:span, " #{message}")
      end)
    end
    nil
  end

  def status_flag(status)
    options = case status
      when :pending
        { class: "default", name: "Pendente" }
      when :paused
        { class: "info", name: "Pausada" }
      when :queued
        { class: "info", name: "Na fila" }
      when :processing
        { class: "primary", name: "Processando" }
      when :successfully_finished
        { class: "success", name: "Finalizada com sucesso" }
      when :finished_with_error
        { class: "danger", name: "Finalizada com erro(s)" }
      when :finished_with_failure
        { class: "warning", name: "Finalizada com falha(s)" }
    end
    concat(content_tag(:span, options[:name], class: "label label-#{options[:class]}"))
    nil
  end

  def add_icon msg_type
    concat content_tag(:i, '', class: "fa fa-#{bootstrap_icon_for(msg_type)}")
  end

  def boolean_text(boolean)
    boolean ? " Sim" : " Não"
  end

  def boolean_color(boolean)
    boolean ? "green" : "red"
  end

  def boolean_icon(boolean)
    concat content_tag(:i, '', class: "fa fa-#{boolean ? "check" : "ban"} fa-lg", style: "color: #{boolean_color(boolean)}")
    nil
  end
end
