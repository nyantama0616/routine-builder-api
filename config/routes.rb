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

  #Hanon
  get "/hanons", to: "hanons#index"
  post "/hanons/start", to: "hanons#start"
  post "/hanons/stop", to: "hanons#stop"
  post "/hanons/finish", to: "hanons#finish"

  #水
  get "/waters", to: "waters#index"
  post "/waters/drink", to: "waters#drink"

  #Hiit
  get "/hiits", to: "hiits#index"
  post "/hiits/start", to: "hiits#start"
  post "/hiits/finish", to: "hiits#finish"
  patch "/hiits/setting", to: "hiits#setting"

  #tooths
  get "/tooths", to: "tooths#index"
  post "/tooths/start", to: "tooths#start"
  post "/tooths/stop", to: "tooths#stop"
  post "/tooths/finish", to: "tooths#finish"

  #foods
  get "/foods", to: "foods#index"
  post "/foods", to: "foods#create"
  patch "/foods/:id", to: "foods#update"

  #food_menus
  get "/food_menus", to: "food_menus#index"
  get "/food_menus/:id", to: "food_menus#show"
  post "/food_menus", to: "food_menus#create"
  patch "/food_menus/:id", to: "food_menus#update"
  delete "/food_menus/:id", to: "food_menus#destroy"

  #lifes
  get "/lifes/today", to: "lifes#today"

  #walks
  post "/walks/start", to: "walks#start"
  post "/walks/stop", to: "walks#stop"
  post "/walks/finish", to: "walks#finish"
end
