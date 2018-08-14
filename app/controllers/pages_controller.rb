class PagesController < ApplicationController
  def home
    if session[:verification_pending]
      # @user = session[:user_to_verify]
      if session[:user_to_verify]
        Rails.logger.debug("Verify Found")
        @user = session[:user_to_verify]
        if session[:voter_url]
          @token = session[:voter_url]
          # flash.now[:notice] = _('<strong>Verification pending</strong>, please click the following to login as user: ' + @user + "   " + "<a class='btn btn-primary btn-sml' href='" + @token + "'> Confirm login</a>")
          # flash.now[:notice] = _('<strong>Verification pending</strong>, please see your inbox for further instructions.' ) #+ @user)
        end
        # flash.now[:notice] = _('<strong>Verification pending</strong>, please see your inbox for further instructions.' + @user)
      end
      # Rails.logger.debug("Verify After Point")
      Rails.logger.debug("Flash Point")
      # flash.now[:notice] = _('<strong>Verification pending</strong>, please see your inbox for further instructions.')
      flash.now[:notice] = _('Flash Here')
    end
    if session[:current_campaign_id]
      # @campaign = session[:current_campaign_id]
      @campaign = Campaign.find(session[:current_campaign_id])
      Rails.logger.debug("========")
      Rails.logger.debug("Campaign Home")
      Rails.logger.debug(@campaign.title)
      Rails.logger.debug(ENV['ANALYTICS_ID'])
      Rails.logger.debug("========")
      # flash.now[:notice] = _('Flash Here')
      # Rails.logger.debug(@campaign)
      # session.delete(:current_campaign)
    else
      Rails.logger.debug("====ELSE====")
      @campaign = Campaign.current
      Rails.logger.debug("====ELSE====")
    end
    if @campaign.pending?
      flash.now[:notice] = _('We are at the consultation stage. Send us your suggestions for constituency projects')
    end
    if @campaign.open?
      flash.now[:notice] = _('We are at the selection stage. View the proposed projects and vote for your preferences')
    end
    if @campaign.closed?
      flash.now[:notice] = _('We are at the monitoring stage: Check here for regular updates on how your CDF projects are progressing')
    end
    # @campaign = Campaign.current
  end

  def constituency
    unless session[:issue].nil?
      session.delete(:issue)
      flash.now[:notice] = _('There are currently no active campaigns for the selected constituency')
    end
    @constituencies = Constituency.all.order(updated_at: :desc)
  end

  def constituency_campaign
    Rails.logger.debug("=========================================+")
    Rails.logger.debug("Constituency Camp Try")
    Rails.logger.debug(params.inspect)
    Rails.logger.debug(params[:id])
    Rails.logger.debug(params.to_s)
    @constituency = Constituency.find(params[:id])
    # Rails.logger.debug(@constituency.title)
    @campaign = @constituency.current_campaign
    # Rails.logger.debug(@campaign.title)
    Rails.logger.debug("=========================================+")

    # session[:current_campaign_id] = @campaign.id
    # Rails.logger.debug(session[:current_campaign].title)
    # session.delete(:current_campaign)
    # Rails.logger.debug(session[:current_campaign].title)
    if @campaign.nil?
      # session[:current_campaign_id] = @campaign.id
      # Rails.logger.debug(session[:current_campaign_id])
      # Rails.logger.debug("Like a Light")
      # redirect_to campaigns_path
      session[:issue] = true
      redirect_to root_path
    else
      session[:current_campaign_id] = @campaign.id
      Rails.logger.debug(session[:current_campaign_id])
      Rails.logger.debug("Like a Light")
      redirect_to campaigns_path
    end
    # Rails.logger.debug("After Unless pulled +++++")
    # Rails.logger.debug("After Unless pulled +++++")
    # redirect_to root_path
  end
end
