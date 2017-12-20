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
    if session[:current_campaign_id]
      # @campaign = session[:current_campaign_id]
      @campaign = Campaign.find(session[:current_campaign_id])
      Rails.logger.debug("========")
      Rails.logger.debug("Campaign Home")
      Rails.logger.debug(@campaign.title)
      Rails.logger.debug("========")
      # Rails.logger.debug(@campaign)
      # session.delete(:current_campaign)
    else
      Rails.logger.debug("====ELSE====")
      @campaign = Campaign.current
      Rails.logger.debug("====ELSE====")
    end
    # @campaign = Campaign.current
  end

  def constituency
    @constituencies = Constituency.all.order(updated_at: :desc)
  end

  def constituency_campaign
    Rails.logger.debug("=========================================")
    Rails.logger.debug("Constituency Camp Try")
    Rails.logger.debug(params.inspect)
    Rails.logger.debug(params[:id])
    @constituency = Constituency.find(params[:id])
    Rails.logger.debug(@constituency.title)
    @campaign = @constituency.current_campaign
    Rails.logger.debug(@campaign.title)
    Rails.logger.debug("=========================================")

    session[:current_campaign_id] = @campaign.id
    # Rails.logger.debug(session[:current_campaign].title)
    # session.delete(:current_campaign)
    # Rails.logger.debug(session[:current_campaign].title)
    redirect_to campaigns_path
  end
end
