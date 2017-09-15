class PagesController < ApplicationController
  def home
    if session[:verification_pending]
      # @user = session[:user_to_verify]
      if session[:user_to_verify]
        Rails.logger.debug("Verify Found")
        @user = session[:user_to_verify]
        if session[:voter_url]
          @token = session[:voter_url]
          flash.now[:notice] = _('<strong>Verification pending</strong>, please click the following to login as user: ' + @user + "   " + "<a class='btn btn-primary btn-sml' href='" + @token + "'> Confirm login</a>")
        end
        # flash.now[:notice] = _('<strong>Verification pending</strong>, please see your inbox for further instructions.' + @user)
      end
      # Rails.logger.debug("Verify After Point")
      # flash.now[:notice] = _('<strong>Verification pending</strong>, please see your inbox for further instructions.')
    end
    @campaign = Campaign.current
  end
end
