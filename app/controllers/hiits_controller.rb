class HiitsController < ApplicationController
  def create  
    begin
      hiit = Hiit.create_train!(hiit_params)
      
      render json: { hiit: hiit.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  private

  def hiit_params
    hash = params.require(:hiit).permit(:roundCount, :workTime, :breakTime)
    hash[:round_count] = hash.delete(:roundCount).to_i
    hash[:work_time] = hash.delete(:workTime)
    hash[:break_time] = hash.delete(:breakTime)
    
    hash.compact
  end
end
