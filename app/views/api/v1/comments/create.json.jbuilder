json.comment do
  json.partial! 'api/v1/comments/comment', comment: @comment

  json.attachments @comment.attachments, partial: 'api/v1/attachments/attachment', as: :attachment
end
