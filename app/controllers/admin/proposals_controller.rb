class Admin::ProposalsController < AdminController
  # skip_before_action :set_proposal, only: [:suggestion], raise: false
  before_action :set_proposal, only: [:show, :edit, :update, :destroy]
  before_action :set_classifiers, only: [:new, :edit]

  def index
    @current_voter ||= Voter.find_by(id: session[:voter])
    if @current_voter.access_ids == "all"
      @proposals = Proposal.all.order(updated_at: :desc)
    else
      @admin_constit = Constituency.find_by(id: @current_voter.access_ids)
      curr_campaign = @admin_constit.current_campaign
      printf "GRAB Proposals "
      # Rails.logger.debug(curr_campaign.title)
      # Rails.logger.debug(curr_campaign.id)
      # Rails.logger.debug(curr_campaign.__id__)
      # @proposals = curr_campaign
      # @proposals = Proposal.find_all_by_campaign_id(curr_campaign.id)
      # @proposals = Proposal.find(:all, :conditions => { "campaign_id" => curr_campaign.id })
      @proposals = Proposal.where(campaign_id: curr_campaign.id )
      Rails.logger.debug(@proposals.size)
    end
    Rails.logger.debug("===Proposal Admin===")
    printf "Voter "
    Rails.logger.debug(@current_voter.email)
    Rails.logger.debug(@current_voter.access_ids)
    Rails.logger.debug("===Proposal Admin===")

    # @proposals = Proposal.all.order(updated_at: :desc)
  end

  def show
  end

  def new
    @proposal = Proposal.new
  end

  def edit
  end

  def create
    @proposal = Proposal.new(proposal_params)
    if @proposal.save
      redirect_to admin_proposals_path, success: _('Proposal was successfully created.')
    else
      flash.now[:error] = @proposal.errors.full_messages.to_sentence
      render :new
    end
  end

  def update

    if @proposal.update(proposal_params)
      redirect_to admin_proposals_path, success: _('Proposal was successfully updated.')
    else
      flash.now[:error] = @proposal.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @proposal.destroy
    redirect_to admin_proposals_url, success: _('Proposal was successfully deleted.')
  end

  def suggestion
    @suggestions = Suggestion.all.order(updated_at: :desc)
  end

  # def campaign
  #   @campaigns = Campaign.all.order(updated_at: :desc)
  # end

  private

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def set_classifiers
    @districts = District.all
    @areas = Area.all
    @tags  = Tag.all
  end

  def proposal_params
    p = params.require(:proposal).permit(:title, :description, :budget, :image, :completed, :campaign_id, :district_id, :area_id, tag_ids: [])
    p[:budget] = p[:budget]&.gsub(',', '_')&.to_d if p[:budget]
    p[:image] = nil if params[:delete_image]
    p
  end
end
