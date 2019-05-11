class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    if current_member
      begin
        redirect_back(fallback_location: root_path, :alert => exception.message)
      rescue
        redirect_to "/"
      end
    else
      authenticate_member!
    end
  end

  #devise
  def after_sign_in_path_for(resource)
    begin
      Statistic.create(name:"sign_in",member_id: current_member.id)
      flash[:notice] = '휴즈넷 출석 완료!'
    rescue;end
    super
  end

  alias_method :current_user, :current_member # current_user를 current_member로 이용
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username,:senior_number,:tel,:major_id] )
    devise_parameter_sanitizer.permit(:account_update, keys: [:username,:senior_number,:tel,:major_id, :image_url] )
  end
end
