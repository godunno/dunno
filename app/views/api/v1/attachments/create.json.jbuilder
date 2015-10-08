json.attachment do
  json.partial! 'api/v1/attachments/attachment', attachment: @attachment
end
