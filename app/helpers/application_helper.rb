module ApplicationHelper

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
    concat(image_tag(current_user.avatar.url(:profile), class: "img-circle", alt:"User Image"))
    nil
  end

  def profile_image_small
    concat(image_tag(current_user.avatar.url(:profile), class: "user-image", alt:"User Image"))
    nil
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
        concat "#{message}"
      end)
    end
    nil
  end

  def add_icon msg_type
    concat content_tag(:i, '', class: "fa fa-#{bootstrap_icon_for(msg_type)}")
    concat " - "
  end
end
