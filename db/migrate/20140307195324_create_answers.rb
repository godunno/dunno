class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.belongs_to :student, index: true
      t.belongs_to :option, index: true

      t.timestamps
    end
  end
end
