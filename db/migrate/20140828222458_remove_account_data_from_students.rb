class RemoveAccountDataFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :name,   :string
    remove_column :students, :avatar, :string
    remove_column :students, :phone_number, :string

    # Devise
    remove_column :students, :email,                  :string, default: "", null: false
    remove_column :students, :encrypted_password,     :string, default: "", null: false
    remove_column :students, :reset_password_token,   :string
    remove_column :students, :reset_password_sent_at, :datetime
    remove_column :students, :remember_created_at,    :datetime
    remove_column :students, :sign_in_count,          :integer, default: 0,  null: false
    remove_column :students, :current_sign_in_at,     :datetime
    remove_column :students, :last_sign_in_at,        :datetime
    remove_column :students, :current_sign_in_ip,     :string
    remove_column :students, :last_sign_in_ip,        :string
    remove_column :students, :authentication_token,   :string
  end
end
