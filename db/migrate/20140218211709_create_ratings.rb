class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.float  :value, default: 0.0
      t.integer :rateable_id
      t.string  :rateable_type
      t.belongs_to :student, index: true

      t.timestamps
    end

    add_index :ratings, [:rateable_id, :rateable_type, :student_id], unique: true
  end
end
