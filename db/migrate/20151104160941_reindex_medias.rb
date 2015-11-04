class ReindexMedias < ActiveRecord::Migration
  def up
    Media.import
  end
end
