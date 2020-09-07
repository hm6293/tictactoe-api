class Game < ApplicationRecord

  def switch_players
    update_attributes!(current_player_id: self[:other_player_id], other_player_id: self[:current_player_id])
  end
end
