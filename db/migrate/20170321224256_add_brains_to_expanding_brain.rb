class AddBrainsToExpandingBrain < ActiveRecord::Migration[5.0]
  def change
    add_reference :expanding_brains, :brain, foreign_key: true
  end
end
