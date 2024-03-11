class SleepsController < ApplicationController
  def latest
    sleep = Sleep.last
    render json: { sleep: sleep&.info }
  end

  def start
    sleep = Sleep.last || Sleep.create
    
    begin
      sleep.start
    rescue => e
      render json: { errors: [e.message] }, status: :bad_request
      return
    end

    #TODO: ユーザの状態を返す
    render json: { sleep: sleep.info }
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

    render json: { sleep: sleep.info }
  end
end
