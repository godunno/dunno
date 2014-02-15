class AddAuthenticationTokenToStudents < ActiveRecord::Migration
  def change
    change_table :students do |t|
      t.string :authentication_token
    end
  end
end
