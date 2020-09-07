class GameController < ApplicationController

  skip_before_action :verify_authenticity_token
  def create
    current_player_id, other_player_id = params[:player_ids].shuffle

    current_player = Player.get(current_player_id)
    other_player = Player.get(other_player_id)

    if current_player.blank? || other_player.blank?
      render json: { message: 'Two players are needed to play the game' }, status: 400
    else
      board = Board.create_board

      if board.nil?
        render json: { message: 'Error creating board. Please try after some time' }, status: 500
      else
        game = Game.new(current_player_id: current_player_id,
                        other_player_id: other_player_id,
                        board_id: board.id)
        if game.valid? && game.save
          current_player.update_attributes!(symbol: 'X')
          other_player.update_attributes!(symbol: 'O')
          response = {
            current_player: current_player,
            board: board,
            game_id: game[:id]
          }
          render json: response, status: 200
        else
          render json: { message: 'Internal server error' }, status: 500
        end
      end
    end
  end

  def play
    game_id = params[:game_id]
    player_id = params[:player_id]
    position = params[:position]

    game = Game.where(id: game_id).take

    if game.blank?
      render json: { message: 'Game id is invalid' }, status: 400
    elsif game[:current_player_id] != player_id
      render json: { message: 'Invalid player id' }, status: 400
    else
      render_response(game, position)
    end
  end

  def render_response(game, position)
    board = Board.get(game[:board_id])
    current_player = Player.get(game[:current_player_id])
    status = board.set_cell(position, current_player[:symbol])

    if status
      if board.winner?
        render json: { winner: current_player[:name] }, status: 200
      elsif board.draw?
        render json: { draw: true }, status: 200
      else
        game.switch_players
        render json: { current_player: Player.get(game[:current_player_id]),
                       board: board,
                       next: true }, status: 200
      end
    else
      render json: { message: 'Please enter a valid position between 1-9 which is not taken.'}, status: 400
    end
  end

end
