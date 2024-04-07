module TimerableController
  extend ActiveSupport::Concern

  included do
    before_action :reject_if_unauthorized!, only: [:start, :stop, :finish]
  end

  def start
    last = model_class.last
    if last && !last.timer.finished?
      begin
        last.start
        render json: { model_name => last.info, timer: last.timer.info, status: Life.today.status}
      rescue => exception
        render json: { errors: [exception.message] }, status: :bad_request
      end

      return
    end

    begin
      model = model_class.create_and_start!(**start_params)
      render json: { model_name => model.info, timer: model.timer.info, status: Life.today.status }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def stop
    model = model_class.last

    begin
      model.stop
      render json: { model_name => model.info, timer: model.timer.info, status: Life.today.status }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  def finish
    model = model_class.last

    begin
      model.finish
      render json: { model_name => model.info, timer: model.timer.info, status: Life.today.status }
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  protected

  def start_params
    {}
  end

  private
  
  def model_class
    self.class.to_s.gsub(/Controller$/, '').singularize.constantize
  end

  def model_name
    model_class.to_s.downcase.to_sym
  end
end
