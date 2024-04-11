class Dev::SendsController < ApplicationController
  def create
    message = create_params[:message]
    
    log_file = Rails.root.join('log', 'sends', "#{Rails.env}.txt")
    File.open(log_file, 'a') do |file|
      file.puts(message)
    end

    head :ok
  end

  private

  def create_params
    params.permit(:message)
  end
end
