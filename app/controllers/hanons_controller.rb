class HanonsController < ApplicationController
  before_action :reject_if_unauthorized!, only: [:start, :stop, :finish]

  def index
    hanon = Hanon.in_progress
    in_progress = hanon ? { hanon: hanon.info, timer: hanon.timer.info } : nil

    json = {
      patterns: Hanon.all_patterns,
      inProgress: in_progress,
    }

    render json: json
  end

  def start
    last = Hanon.last
    if last && !last.timer.finished?
      begin
        last.start
        render json: { hanon: last.info, timer: last.timer.info, todayLife: Life.today.info}
      rescue => exception
        render json: { errors: [exception.message] }, status: :bad_request
      end

      return
    end

    begin
      hanon = Hanon.create_and_start!(params[:num], params[:pattern])
      render json: { hanon: hanon.info, timer: hanon.timer.info, todayLife: Life.today.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def stop
    hanon = Hanon.last

    begin
      hanon.stop
      render json: { hanon: hanon.info, timer: hanon.timer.info, todayLife: Life.today.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def finish
    hanon = Hanon.last

    begin
      hanon.finish
      render json: { hanon: hanon.info, timer: hanon.timer.info, todayLife: Life.today.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end
end
