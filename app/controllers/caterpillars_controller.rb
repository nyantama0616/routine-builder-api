class CaterpillarsController < ApplicationController
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
      render json: { caterpillar: caterpillar.info, timer: caterpillar.timer.info }
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
      render json: { caterpillar: caterpillar.info, timer: caterpillar.timer.info }
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
      render json: { caterpillar: caterpillar.info, timer: caterpillar.timer.info }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end
end
