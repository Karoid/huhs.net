class NotificationToken < ActiveRecord::Base
  belongs_to :member

  def send_message(url,message, body='')
    @notification_data = self
    Webpush.payload_send(endpoint: @notification_data.endpoint,
                         message: {
                           message: message,
                           url: url,
                           body: body
                         }.to_json.to_s,
                         p256dh: @notification_data.p256dh_key,
                         auth: @notification_data.auth_key,
                         ttl: 24 * 60 * 60,
                         vapid: {
                           subject: 'mailto:huhsnet@gmail.com',
                           public_key: ENV["vapid_public"],
                           private_key: ENV["vapid_private"]
                         }
    )
  end
end
