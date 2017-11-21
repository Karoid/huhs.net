Rails.application.routes.draw do
  wiki_root '/wiki'
  root 'home#index'
  devise_for :members
  post '/comment/c/:id' => 'board#write_comment'
  post '/comment/d/:id' => 'board#delete_comment'
  get '/board/:category/:board' => 'board#showBoard'
  get '/board/:category/:board/:id' => 'board#showArticle', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  get '/board/:category/:board/create' => 'home#create_post', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  post '/board/:category/:board/write' => 'board#pagelogic_write'
  post '/board/:category/:board/:post_id/create' => 'home#create_post', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/ }
  post '/board/:category/:board/:post_id/write' => 'board#pagelogic_write', :constraints => { :post_id => /[0-9]+(\%7C[0-9]+)*/ }
  #home routes
  get 'create' => 'home#create_post'
  post 'create' => 'home#create_post'
  get 'profile' => 'home#your_profile'
  post 'profile_statistic' => 'home#profile_statistic'
  post 'edit_profile_image' => 'home#edit_profile_image'
  get 'image_crop/:url' => 'home#image_crop'
  #file management
  post 'upload_image' => 'home#upload_image'
  post 'upload_file' => 'home#upload_file'
  #board routes
  get 'board/:senior_number' => 'board#sameage', :constraints => { :senior_number =>  /[0-9]+(\%7C[0-9]+)*/}
  get 'board/:senior_number'+'/:id' => 'board#sameage', :constraints => { :id => /[0-9]+(\%7C[0-9]+)*/, :senior_number =>  /[0-9]+(\%7C[0-9]+)*/}
  post 'board/:senior_number'+'/write' => 'board#sameage'+'_write', :constraints => { :senior_number =>  /[0-9]+(\%7C[0-9]+)*/}
  #admin routes
  get 'admin' => 'admin#index'
  get 'admin/stat/member' => 'admin#member_statistic'
  #get 'admin/stat/member' => 'admin#show_article'
  #get 'admin/stat/member' => 'admin#show_member'
  post 'admin/stat/:name' => 'admin#getStatistic'
  post 'admin/stat_member' => 'admin#getStatisticOfMember'
  get 'admin/category' => 'admin#show_category'
  get 'admin/article' => 'admin#show_article'
  get 'admin/member' => 'admin#show_member'
  post 'admin/delete_data' => 'admin#delete_data'
  post 'admin/active_data' => 'admin#active_inactive_data', :bool => true, tuple: "active"
  post 'admin/inactive_data' => 'admin#active_inactive_data', :bool => false, tuple: "active"
  post 'admin/active_staff' => 'admin#active_inactive_data', :bool => true, tuple: "staff"
  post 'admin/edit_data' => 'admin#edit_data'

  #방탈출을 위해 만들었던 페이지
  # get 'index1' => 'home#index1'
  
  # 카카오톡 챗봇을 위한 라우트
  get 'keyboard' => 'kakao_chat#keyboard'
  post 'message' => 'kakao_chat#get_message'
  post 'friend' => 'kakao_chat#friend_add'
  delete 'friend' => 'kakao_chat#friend_out'
  delete 'chat_room/:user_key' => 'kakao_chat#chat_room_out'
  get 'accept_api' => 'kakao_chat#accept_api'

  # 동방 모니터링을 위한 라우트
  get 'room_count' => 'home#room_count'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
