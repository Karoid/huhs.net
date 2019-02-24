class NotificationController < ApplicationController
  # https://github.com/shedaltd/rails-webpush-demo/blob/master/webpush/Gemfile
  # https://github.com/shedaltd/rails-webpush-demo/blob/master/webpush/config/routes.rb
  # https://github.com/shedaltd/rails-webpush-demo/blob/master/webpush/app/views/content/index.html.erb
  # https://github.com/shedaltd/rails-webpush-demo/blob/master/webpush/app/controllers/content_controller.rb

  def index
  end

  def register
    notif_data = NotificationToken.create(endpoint: params[:subscription][:endpoint],
                              p256dh_key: params[:subscription][:keys][:p256dh],
                              auth_key: params[:subscription][:keys][:auth],
                              member_id: current_member&.id)
    notif_data.send_message(get_message())
    render body: nil
  end

  def unregister
    notif_data = NotificationToken.where(endpoint: params[:subscription][:endpoint],
                                          p256dh_key: params[:subscription][:keys][:p256dh],
                                          auth_key: params[:subscription][:keys][:auth],
                                          member_id: current_member&.id).destroy_all
    render body: nil
  end

  def get_message()
    "성공적으로 푸쉬 알림이 등록되었습니다"
  end
end
