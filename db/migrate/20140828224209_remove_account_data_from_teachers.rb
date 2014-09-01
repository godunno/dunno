class RemoveAccountDataFromTeachers < ActiveRecord::Migration
  def change
    remove_column :teachers, :name,   :string
    remove_column :teachers, :avatar, :string
    remove_column :teachers, :phone_number, :string

    # Devise
    remove_column :teachers, :email,                  :string, default: "", null: false
    remove_column :teachers, :encrypted_password,     :string, default: "", null: false
    remove_column :teachers, :reset_password_token,   :string
    remove_column :teachers, :reset_password_sent_at, :datetime
    remove_column :teachers, :remember_created_at,    :datetime
    remove_column :teachers, :sign_in_count,          :integer, default: 0,  null: false
    remove_column :teachers, :current_sign_in_at,     :datetime
    remove_column :teachers, :last_sign_in_at,        :datetime
    remove_column :teachers, :current_sign_in_ip,     :string
    remove_column :teachers, :last_sign_in_ip,        :string
    remove_column :teachers, :authentication_token,   :string
  end
end
