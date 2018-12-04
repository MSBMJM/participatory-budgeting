class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_voter
  helper_method :admin_role?

  add_flash_types :success, :error

  before_action :set_locale, :set_cache_headers

  def current_voter
    @current_voter ||= Voter.find_by(id: session[:voter])
  end

  def admin_role?
    roles = Admin::Role.all.pluck(:email)
    roles.any?{ |role| current_voter&.email&.include?(role) }
  end

  def sign_in(voter)
    session[:voter] = voter.id
  end

  def sign_out
    session.delete(:voter)
  end

  def current_redirect!
    params[:redirect] || (session[:verification_pending] ? session[:redirect] : session.delete(:redirect)) || root_path
  end

  def update_current_redirect_with(redirect)
    if redirect
      session[:redirect] = redirect
    else
      session.delete(:redirect)
    end
  end

  def xhr_request?
    request.headers['HTTP_X_REQUESTED_WITH'] == 'XMLHttpRequest'
  end

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || ENV['DEFAULT_LOCALE'] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  private

  # force page to reload on back, to ensure all state changes are shown; specifically after submitting a vote
  def set_cache_headers
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
