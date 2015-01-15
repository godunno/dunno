module ApplicationHelper
  def list(items)
    content_tag(:ul) do
      items.map { |item| concat(content_tag(:li, item)) }
    end
  end

  def date_picker(f, field)
    f.input field, as: :string, input_html: { class: 'datepicker col-lg-2', value: f.object.send(field).try(:strftime, '%d/%m/%Y') }
  end

  def time_picker(f, field)
    f.input field, input_html: { class: 'timepicker', data: { 'show-meridian' => false, 'default-time' => 'value' } }
  end

  def datetime_picker(f, field)
    f.input field, as: :string, input_html: { class: 'datetimepicker', value: f.object.send(field).try(:strftime, '%d/%m/%Y %H:%M') }
  end

  def profile_name(profile)
    case profile
    when "teacher" then "professor"
    when "student" then "aluno"
    else fail "Invalid profile: #{profile}"
    end
  end
end
