CricketAnalysis::Application.routes.draw do
  
  resources :reports


  resources :attachments

  resources :externals do
	collection {post :upload}
  end
  
  #match 'upload', :to=> 'externals#upload'

  resources :clientconfigs
  match 'settings', :to=> 'clientconfigs#settings'

  resources :configurations

  resources :clients
  match 'generatePass' , :to=>'clients#generatePass'
  match 'change_password' , :to=>'clients#change_password'
  match 'changedpassword' , :to=>'clients#changedpassword'
  match 'updateAccount' , :to=>'clients#updateAccount'
  match 'updatedAccount', :to=> 'clients#updatedAccount'

  match 'signin', :to=> 'clients#signin'
  match 'new_session', :to=> 'clients#new_session'
  match 'home', :to=> 'clients#home'
  match 'signout', :to=> 'clients#signout'
  match 'username', :to=> 'clients#forgotu'  
  match 'show_username', :to=> 'clients#showu' 
  match 'password', :to=> 'clients#forgotp'   
  match 'send_temp_password', :to=> 'clients#send_temp_password' 

  get 'analysis' , :to=> 'analysis#index'
  match 'generate' , :to=> 'analysis#generate'
  match 'matchwins' , :to=> 'analysis#matchwins'
  
  
  resources :scorecards
  match 'scorecard_first_inning' , :to=>'scorecards#match_scorecard_one'
  match 'scorecard_second_inning' , :to=>'scorecards#match_scorecard_two'
  #match 'scorecard' , :to=>'scorecards#scorecard'

  
  resources :countries

  resources :managers

  resources :players
  match 'temp_login' , :to=>'players#temp_login'
  match 'allow_temp_connection' , :to=>'players#allow_temp_connection'
  match 'playerids' , :to=>'players#playerids'
  
  match 'all_players' , :to => 'players#all_players'

  resources :matches
  match 'match_status' , :to=> 'matches#match_status'
  match 'match_details' , :to=> 'matches#match_details'
  match 'pitchconditions' , :to=> 'matches#pitchconditions'
  match 'test' , :to=> 'matches#test'

  resources :tournaments

  resources :coaches

  resources :venues

  resources :teams
  
  match 'team', :to => 'teams#team'
  match '/modify_team', :to=>'teams#modify_team'


  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
    root :to => 'clients#signin'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
