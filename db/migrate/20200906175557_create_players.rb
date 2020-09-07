class CreatePlayers < ActiveRecord::Migration[6.0]
  def change
    create_table :players do |t|
      t.string :name, null: false, unique: true
      t.string :symbol

      t.timestamps
    end
  end
end
