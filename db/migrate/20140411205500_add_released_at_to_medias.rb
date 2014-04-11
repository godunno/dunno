class AddReleasedAtToMedias < ActiveRecord::Migration
  def change
    add_column :medias, :released_at, :datetime
  end
end
