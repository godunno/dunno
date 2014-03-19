class AddAuthenticationTokenToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :authentication_token, :string
    add_index :teachers, :authentication_token, unique: true
  end
end
