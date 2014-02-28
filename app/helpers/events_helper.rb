module EventsHelper
  def status_label(status)
    case status
    when 'available' then 'label-success'
    when 'opened' then 'label-warning'
    when 'closed' then 'label-danger'
    end
  end
end
