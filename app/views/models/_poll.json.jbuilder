json.(poll, :uuid, :content, :status)

json.options poll.options do |option|
  json.partial! 'models/option', option: option
end
