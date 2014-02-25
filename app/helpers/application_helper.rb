module ApplicationHelper
  def list(items)
    content_tag(:ul) do
      items.map { |item| concat(content_tag(:li, item)) }
    end
  end
end
