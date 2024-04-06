class HiitsController < ApplicationController
  before_action :reject_if_unauthorized!, only: [:start, :finish, :setting]

  def index
    render json: { hiitSetting: Hiit.setting_info }
  end
  
  def start  
    begin
      hiit = Hiit.create_and_start!(**start_params)
      
      render json: { hiit: hiit.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def finish
    hiit = Hiit.last

    begin
      hiit.finish finish_params[:round_count]
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

  def start_params
    hash = params.permit(:workTime, :breakTime).to_h.symbolize_keys
    hash[:work_time] = hash.delete(:workTime).to_i
    hash[:break_time] = hash.delete(:breakTime).to_i
    
    hash.compact
  end

  def finish_params    
    hash = params.permit(:roundCount).to_h.symbolize_keys
    hash[:round_count] = hash.delete(:roundCount).to_i

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
