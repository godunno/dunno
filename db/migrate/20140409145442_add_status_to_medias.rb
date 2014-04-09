class AddStatusToMedias < ActiveRecord::Migration
  def change
    add_column :medias, :status, :string, default: "available"
  end
end
