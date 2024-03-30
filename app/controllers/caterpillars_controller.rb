class CaterpillarsController < ApplicationController
  include TimerableController

  def index
    caterpillar = Caterpillar.in_progress
    inProgress = caterpillar ? { caterpillar: caterpillar.info, timer: caterpillar.timer.info } : nil

    json = {
      patterns: Caterpillar.all_patterns,
      inProgress: inProgress,
    }

    render json: json
  end

  private
  
  def start_params
    params.permit(:pattern).to_h.symbolize_keys
  end
end
