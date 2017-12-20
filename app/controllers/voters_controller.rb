class VotersController < ApplicationController
  def new
    update_current_redirect_with(params[:redirect]) if params[:redirect]
    @voter = Voter.new
  end

  def create
    ActionController::Parameters.permit_all_parameters = true

    params = ActionController::Parameters.new
    params.permitted? # => true

    # Rails.logger.debug("FearonTheOne")
    Rails.logger.debug(params.permitted?)
    Rails.logger.debug(params[:voter])
    email = voter_params[:email]
    secret = voter_secret_params[:secret_data].to_h
    printf "logging Like a Logger\n"

    # logger.info 'test'
    if RegisterVoter.call(email,secret)
      session[:verification_pending] = true
      session[:user_to_verify] = email
      # @user = session[:user_to_verify]
      @voter = Voter.find_or_create_by(email: email)
      session[:voter_url] = verify_voters_url(token: @voter.verification_token)

      # Rails.logger.debug("========FearonTheOne=========")
      Rails.logger.debug(session[:voter])

      roles = Admin::Role.all.pluck(:email)
      # Rails.logger.debug(roles.any?{ |role| email&.include?(role) })

      if roles.any?{ |role| email&.include?(role) }
        redirect_to current_redirect!, notice: _("We've sent you a <strong>verification token</strong>, please see your inbox for further instructions." )
      else
        redirect_to current_redirect!, notice: _('<strong>Verification pending</strong>, please click the following to login as user: ' + email + '   ' + "<a class='btn btn-primary btn-sml' href='" + session[:voter_url] + "'> Confirm login</a>")
      end

      # redirect_to current_redirect!, notice: _('<strong>Verification pending</strong>, please click the following to login as user: ' + email + '   ' + "<a class='btn btn-primary btn-sml' href='" + session[:voter_url] + "'> Confirm login</a>") #_("We've sent you a <strong>verification token</strong>, please see your inbox for further instructions." )
    else
      redirect_to new_voter_path, error: _('Something went wrong with the registration process. Please, <strong>try again</strong>.')
    end
  end

  def update
    @voter = Voter.find(params[:id])
    @voter.name = params[:voter][:name] if params[:voter] && !params[:voter][:name].blank?
    verify!
  end

  def verify
    @voter = Voter.find_by(verification_token: params[:token])
    if !@voter
      redirect_to new_voter_path, error: _('Something went wrong with the verification process. Please, <strong>try again</strong>.')
    elsif !@voter.verified? || !@voter.name
      render :verify
    else
      verify!
    end
  end

  def signout
    sign_out
    redirect_to root_path, success: _('<strong>Successfully signed out</strong>, sign in again to review your votes.')
  end

  private

  def verify!
    @voter.verify!
    session.delete(:verification_pending)
    sign_in(@voter)
    if admin_role?
      redirect_to admin_proposals_path, success: _('Login Successful, Welcome Back Admin.')
    else
      redirect_to current_redirect!, success: _('<strong>Successfully verified</strong>, you can now take part in the participatory budgeting process.')
    end
  end

  def voter_params
    params.require(:voter).permit(:email)
  end


  def voter_secret_params
    return ActionController::Parameters.new({}) unless (params[:voter] && params[:voter][:secret_data])
    params.require(:voter).permit(:email, secret_data: params[:voter][:secret_data].try(:keys))
  end
end
