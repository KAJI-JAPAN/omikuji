class FortunesController < ApplicationController
  def draw
    omikuji_result = OmikujiService.new.draw_omikuji
    render json: omikuji_result
  end
end