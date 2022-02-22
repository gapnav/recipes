Rails.application.routes.draw do
  root to: 'application#render_layout'

  constraints lambda {|request| request.format.json?} do
    resources :recipes, only: :index
  end
end
