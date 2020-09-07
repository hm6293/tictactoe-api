class Player < ApplicationRecord

  def self.get(player_id)
    Player.find_by(id: player_id)
  end
end
