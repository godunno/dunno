class AddIndexToAuthenticationTokenFromStudents < ActiveRecord::Migration
  def change
    add_index :students, :authentication_token, unique: true
  end
end
