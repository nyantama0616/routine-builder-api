class HanonsController < ApplicationController
  include TimerableController

  def index
    hanon = Hanon.in_progress
    in_progress = hanon ? { hanon: hanon.info, timer: hanon.timer.info } : nil

    json = {
      patterns: Hanon.all_patterns,
      inProgress: in_progress,
    }

    render json: json
  end

  private

  def start_params
    params.permit(:num, :pattern).to_h.symbolize_keys
  end
end
