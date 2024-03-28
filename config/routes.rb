Rails.application.routes.draw do
  get '/dev/ping', to: 'dev/pings#index'

  get '/home', to: 'homes#index'
  
  #sleeps
  get "/sleeps/latest", to: "sleeps#latest"
  post "/sleeps/start", to: "sleeps#start"
  post "/sleeps/finish", to: "sleeps#finish"

  #いもむしトレーニング
  get "/caterpillars", to: "caterpillars#index"
  post "/caterpillars/start", to: "caterpillars#start"
  post "/caterpillars/stop", to: "caterpillars#stop"
  post "/caterpillars/finish", to: "caterpillars#finish"

  #水
  get "/waters", to: "waters#index"
  post "/waters/drink", to: "waters#drink"

  #Hiit
  get "/hiits", to: "hiits#index"
  post "/hiits", to: "hiits#create"
  patch "/hiits/setting", to: "hiits#setting"
end
