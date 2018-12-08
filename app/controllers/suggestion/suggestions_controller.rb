class Suggestion::SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]
  before_action :set_classifiers, only: [:new, :edit, :innovation, :community]

  def index
    # @proposals = Proposal.all.order(updated_at: :desc)
    # @suggestions = Suggestion.all.order(updated_at: :desc)
    # @suggestions = Suggestion.where(approved:true)
    @suggestions = Suggestion.where(review_status:'approved').order(updated_at: :desc)
    Rails.logger.debug("@suggestions.size")
    # Rails.logger.debug(@suggestions.size)
    # handle potential singular suggestion being returned
    @suggestions = Array(@suggestions)
    Rails.logger.debug(@suggestions.size)
  end

  def show
  end

  def new
    # @proposal = Proposal.new
    @suggestion = Suggestion.new
  end

  def edit
    redirect_to root_path, error: _('<strong>Admin role is necessary</strong> in order to access the admin area.') unless admin_role?
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    if @suggestion.save
      redirect_to suggestion_suggestions_path, success: _('Suggestion was successfully submitted for review. Approved suggestions will be displayed after 1-2 days')
    else
      flash.now[:error] = @suggestion.errors.full_messages.to_sentence
      render :new
    end
  end

  def update

    if @suggestion.update(suggestion_admin_params)
      redirect_to admin_suggestions_path, success: _('Only Review Status changes will be successfully updated.')
    else
      flash.now[:error] = @suggestion.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @suggestion.destroy
    redirect_to admin_suggestions_path, success: _('Suggestion was successfully deleted.')
  end

  def community
    @suggestion = Suggestion.new
    @areas = Area.where(name: 'Community Development')
  end

    def innovation
      @suggestion = Suggestion.new
      @tags = Tag.where(name: ['Youth Employment', 'Peace Building and Crime Reduction'])
      @areas = Area.where(name: 'Youth Innovation')
    end

  private

  def set_suggestion
    @suggestion = Suggestion.find(params[:id])
  end

  def set_classifiers
    @districts = District.all
    @areas = Area.all
    @tags  = Tag.all
  end

  def suggestion_params
    p = params.require(:suggestion).permit(:title, :description, :solution, :contact, :budget, :image, :proposing_member, :review_status, :campaign_id, :district_id, :area_id, tag_ids: [])
    p[:budget] = "0"
    p[:budget] = p[:budget]&.gsub(',', '_')&.to_d if p[:budget] #no need for budget in suggestion probably
    p[:image] = nil if params[:delete_image]
    #p[:description] << $/ << $/ << p[:solution]
    p
  end

  def suggestion_admin_params
    p = params.require(:suggestion).permit(:review_status)
    p
  end
end
