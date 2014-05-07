class CreateArtifacts < ActiveRecord::Migration
  def change
    create_table :artifacts do |t|
      t.belongs_to :teacher, index: true
      t.integer    :heir_id
      t.string     :heir_type

      t.timestamps
    end

    add_index :artifacts, [:heir_id, :heir_type], unique: true
  end
end
