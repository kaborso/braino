class CreateExpandingBrains < ActiveRecord::Migration[5.0]
  def change
    create_table :expanding_brains do |t|
      t.string :Name
      t.integer :Type
      t.string :Status
      t.string :URL

      t.timestamps
    end
  end
end
