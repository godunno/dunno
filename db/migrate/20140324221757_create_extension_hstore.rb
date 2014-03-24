class CreateExtensionHstore < ActiveRecord::Migration
  def up
    execute "create extension hstore"
  end

  def down
  end
end
