class AddPhoneNumberToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :phone_number, :string
  end
end
