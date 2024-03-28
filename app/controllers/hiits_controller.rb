class HiitsController < ApplicationController
  before_action :reject_if_unauthorized!, only: [:create, :setting]

  def index
    render json: { hiitSetting: Hiit.setting_info }
  end
  
  def create  
    begin
      hiit = Hiit.create_train!(hiit_params)
      
      render json: { hiit: hiit.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def setting
    begin
      Hiit.update_setting!(setting_params)
      
      render json: { hiitSetting: Hiit.setting_info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  private

  def hiit_params
    hash = params.require(:hiit).permit(:roundCount, :workTime, :breakTime)
    hash[:round_count] = hash.delete(:roundCount).to_i
    hash[:work_time] = hash.delete(:workTime).to_i
    hash[:break_time] = hash.delete(:breakTime).to_i
    
    hash.compact
  end

  def setting_params
    hash = params.require(:hiitSetting).permit(:roundCount, :workTime, :breakTime)
    hash[:round_count] = hash.delete(:roundCount).to_i
    hash[:work_time] = hash.delete(:workTime).to_i
    hash[:break_time] = hash.delete(:breakTime).to_i

    hash.compact
  end
end
