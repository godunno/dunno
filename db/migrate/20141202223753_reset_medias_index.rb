class ResetMediasIndex < ActiveRecord::Migration
  def change
    Media.__elasticsearch__.create_index! force: true
    Media.import
  end
end
