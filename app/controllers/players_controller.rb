class PlayersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def create
    name = player_params[:name]
    if name.blank?
      render json: { message: 'Name or Symbol can\'t be blank' }, status: 400
    else
      player = Player.new(name: name)
      if player.valid? && player.save
        render json: player, status: 200
      else
        render json: player.errors, status: 400
      end
    end
  end

  def player_params
    # whitelist params
    params.permit(:name, :symbol)
  end
end
