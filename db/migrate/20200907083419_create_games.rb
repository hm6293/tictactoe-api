class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :current_player_id
      t.integer :other_player_id
      t.integer :board_id

      t.timestamps
    end
  end
end
