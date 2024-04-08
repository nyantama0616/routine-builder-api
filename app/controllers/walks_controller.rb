class WalksController < ApplicationController
  include TimerableController

  private

  def start_params
    params.require(:walk).permit(:from, :to).to_h.symbolize_keys
  end
end
