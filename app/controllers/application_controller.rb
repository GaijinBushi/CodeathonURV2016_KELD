class ApplicationController < ActionController::Base
  layout Proc.new { |controller| controller.devise_controller? ? 'application' : 'game' }
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  helper_method :active_exams
  helper_method :locale
  before_filter :set_gettext_locale


  def after_sign_in_path_for(resource)
    root_path
  end

  def active_exams
    current_user.exams.where("end_date >= \"#{DateTime.now.to_formatted_s(:db)}\"")
  end

  protected


  def permission_denied
    render file:'public/401.html', status: :unauthorized, layout: false
  end

  def bad_request
    render file:'public/400.html', status: :bad_request, layout: false
  end


  def locale
    params[:locale] || session[:locale] || I18n.default_locale
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :password_confirmation, :password, :email) }
  end

  def set_gettext_locale
    requested_locale = params[:locale] || session[:locale] || cookies[:locale] ||  request.env['HTTP_ACCEPT_LANGUAGE'] || I18n.default_locale
    locale = FastGettext.set_locale(requested_locale)
    session[:locale] = locale
    I18n.locale = locale # some weird overwriting in action-controller makes this necessary ... see I18nProxy
  end

end
