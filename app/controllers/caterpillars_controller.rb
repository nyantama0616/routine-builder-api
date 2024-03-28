class CaterpillarsController < ApplicationController
  before_action :reject_if_unauthorized!, only: [:start, :stop, :finish]

  def index
    caterpillar = Caterpillar.in_progress
    inProgress = caterpillar ? { caterpillar: caterpillar.info, timer: caterpillar.timer.info } : nil

    json = {
      patterns: Caterpillar.all_patterns,
      inProgress: inProgress,
    }

    render json: json
  end

  def start
    last = Caterpillar.last
    if last && !last.timer.finished?
      begin
        last.start
        render json: { caterpillar: last.info, timer: last.timer.info }
      rescue => exception
        render json: { errors: [exception.message] }, status: :bad_request
      end

      return
    end

    begin
      caterpillar = Caterpillar.create_and_start!(params[:pattern])
      render json: { caterpillar: caterpillar.info, timer: caterpillar.timer.info, todayLife: Life.today.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def stop
    caterpillar = Caterpillar.last
    
    if !caterpillar
      render json: { errors: ["Caterpillar has not started."] }, status: :bad_request
      return
    end

    begin
      caterpillar.stop
      render json: { caterpillar: caterpillar.info, timer: caterpillar.timer.info, todayLife: Life.today.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def finish
    caterpillar = Caterpillar.last
    
    if !caterpillar
      render json: { errors: ["Caterpillar has not started."] }, status: :bad_request
      return
    end

    begin
      caterpillar.finish
      render json: { caterpillar: caterpillar.info, timer: caterpillar.timer.info, todayLife: Life.today.info}
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end
end
