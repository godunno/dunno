class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.belongs_to :profile, null: false, index: true
      t.belongs_to :course, null: false, index: true
      t.string :role, null: false

      t.timestamps
    end
  end
end
