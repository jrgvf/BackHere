module TaskHelper

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
  
end
