class ToothsController < ApplicationController
  include TimerableController
  
  def index
    tooth = Tooth.in_progress
    in_progress = tooth ? { tooth: tooth.info, timer: tooth.timer.info } : nil

    json = {
      inProgress: in_progress,
    }

    render json: json
  end
end
