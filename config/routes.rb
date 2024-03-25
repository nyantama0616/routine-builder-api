Rails.application.routes.draw do
  get '/dev/ping', to: 'dev/pings#index'
  
  #sleeps
  get "/sleeps/latest", to: "sleeps#latest"
  post "/sleeps/start", to: "sleeps#start"
  post "/sleeps/finish", to: "sleeps#finish"

  resources :hiits, only: %i[create]

  #いもむしトレーニング
  post "/caterpillars/start", to: "caterpillars#start"
  post "/caterpillars/stop", to: "caterpillars#stop"
  post "/caterpillars/finish", to: "caterpillars#finish"
end
