class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, :alert => exception.message
  end

  #devise
  def after_sign_in_path_for(resource)
    Statistic.create(name:"sign_in",member_id: current_member.id)
    super
  end

  alias_method :current_user, :current_member # current_user를 current_member로 이용
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:senior_number])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:tel])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:major])
  end
end
