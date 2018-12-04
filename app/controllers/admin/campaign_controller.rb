class Admin::CampaignController < AdminController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]
  before_action :set_constituencies, only: [:new, :edit]


  def index
    @current_voter ||= Voter.find_by(id: session[:voter])
    if @current_voter.access_ids == "all"
      @campaigns = Campaign.all.order(updated_at: :desc)
    else
      @admin_constit = Constituency.find_by(id: @current_voter.access_ids)
      # curr_campaign = @admin_constit.current_campaign
      printf "GRAB Campaigns "
      # Rails.logger.debug(curr_campaign.title)
      @campaigns = @admin_constit.campaigns
    end
    # @campaigns = Campaign.all.order(updated_at: :desc)
  end

  def show
  end

  def new
    @campaign = Campaign.new
  end

  def edit
  end

  def create
    @campaign = Campaign.new(campaign_params)
    if @campaign.save
      redirect_to admin_campaign_index_path, success: _('Campaign was successfully created.')
    else
      flash.now[:error] = @campaign.errors.full_messages.to_sentence
      render :new
    end
  end

  def update

    if @campaign.update(campaign_params)
      redirect_to admin_campaign_index_path, success: _('Campaign was successfully updated.')
    else
      flash.now[:error] = @campaign.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @campaign.destroy
    redirect_to admin_proposals_url, success: _('Campaign was successfully deleted.')
  end

  def set_campaign
    @campaign = Campaign.find(params[:id])
  end

  def set_constituencies
    @constitencies = Constituency.all
  end

  def campaign_params
    p = params.require(:campaign).permit(:title, :description, :active, :constituency_id, :budget, :start_date, :end_date)
    p[:budget] = p[:budget]&.gsub(',', '_')&.to_d if p[:budget]
    # p[:image] = nil if params[:delete_image]
    p
  end
end