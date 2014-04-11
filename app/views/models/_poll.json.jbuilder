json.(poll, :uuid, :content, :status, :released_at)

json.options poll.options do |option|
  json.partial! 'models/option', option: option
end
