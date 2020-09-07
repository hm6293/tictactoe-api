class CreateBoards < ActiveRecord::Migration[6.0]
  def change
    create_table :boards do |t|
      t.text :grid, default: [].to_yaml

      t.timestamps
    end
  end
end
