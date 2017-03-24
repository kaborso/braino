class CreateBrains < ActiveRecord::Migration[5.0]
  def change
    create_table :brains do |t|
      t.string :text
      t.integer :pointsize
      t.integer :xpos
      t.integer :ypos
      t.references :expanding_brain, foreign_key: true

      t.timestamps
    end
  end
end
