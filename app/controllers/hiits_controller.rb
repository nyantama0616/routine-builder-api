class HiitsController < ApplicationController
  def create
    begin
      hiit = Hiit.create_train!(hiit_params[:round_count])
      render json: { hiit: hiit.info }, status: :created
    rescue => exception
      render json: { errors: [exception.message] }, status: :bad_request
    end
  end

  private

  def hiit_params
    hash = params.require(:hiit).permit(:roundCount)
    hash[:round_count] = hash.delete(:roundCount)
    hash
  end
end
