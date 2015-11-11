module EventsHelper
  def readable_status(status)
    case status
    when 'canceled' then 'Aula cancelada'
    when 'published' then 'Aula publicada'
    when 'draft' then 'Aula vazia'
    else raise "Unknown status: #{status}"
    end
  end
end
