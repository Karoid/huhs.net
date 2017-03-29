module CheckAttendence
  module Ability

    def check_allowed?
      if authenticate_member!
        current_member.role > 0
      end
    end

    def admin_allowed?
      if authenticate_member!
        current_member.admin
      end
    end

  end
end

CheckAttendence.setup do |config|
  #if you use devise, this will work correctly
  #write down your user model name!
  config.user_model_name = "member"

  #write down main colum name to use it as "username"!
  config.user_model_main_column = "username"

  #home url
  #config.home_url = "/"

  #if you don't want to use default route as /game/rsp, change as false
  #you can bind route like [get 'my/route' => 'rock_scissors_paper/home#index'] in routes.rb
  #config.automatic_routes_mount = false

  #if you want to use /app/veiws/layouts/application.html.erb, then set this value as true
  config.use_layout = true

  #if you want to use admin page other layout, then set this value like below
  config.admin_layout = "admin_application"

  #default model used by CheckAttendence
  config.default_model = Attendence

  #if you need to notice playing this game, I recommend put notice written url
  #config.notice_route = "/attendence/notice"

  #first point when user start's this game first
  #config.initial_point = 5000
end
