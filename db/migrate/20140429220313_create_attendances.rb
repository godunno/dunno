class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.belongs_to :student, index: true
      t.belongs_to :event, index: true
      t.boolean    :validated, default: false

      t.timestamps
    end
  end
end
