class SleepsController < ApplicationController
  def latest
    sleep = Sleep.last
    render json: { sleep: sleep&.info }
  end

  def start
    sleep = Sleep.last

    if sleep == nil || sleep.finished?
      sleep = Sleep.create! life: Life.today
    end
    
    nap = params[:isNap].to_s == "true"
    
    begin
      sleep.start nap: nap
    rescue => e
      render json: { errors: [e.message] }, status: :bad_request
      return
    end

    #TODO: ユーザの状態を返す
    render json: { sleep: sleep.info, todayLife: Life.today.info }
  end
  
  def finish
    sleep = Sleep.last

    unless sleep
      render json: { errors: ['not started'] }, status: :bad_request
      return
    end
    
    begin
      sleep.finish
    rescue => e
      render json: { errors: [e.message] }, status: :bad_request
      return
    end

    render json: { sleep: sleep.info, todayLife: Life.today.info }
  end
end
