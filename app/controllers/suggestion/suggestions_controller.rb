class Suggestion::SuggestionsController < ApplicationController
  before_action :set_suggestion, only: [:show, :edit, :update, :destroy]
  before_action :set_classifiers, only: [:new, :edit]

  def index
    # @proposals = Proposal.all.order(updated_at: :desc)
    # @suggestions = Suggestion.all.order(updated_at: :desc)
    @suggestions = Suggestion.all.find_by(approved:true)
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
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)
    if @suggestion.save
      redirect_to suggestion_suggestions_path, success: _('Suggestion was successfully submitted for review.')
    else
      flash.now[:error] = @suggestion.errors.full_messages.to_sentence
      render :new
    end
  end

  def update

    if @suggestion.update(suggestion_params)
      redirect_to suggestion_suggestions_path, success: _('Suggestion was successfully updated.')
    else
      flash.now[:error] = @suggestion.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @suggestion.destroy
    redirect_to suggestion_suggestions_path, success: _('Suggestion was successfully destroyed.')
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
    p = params.require(:suggestion).permit(:title, :description, :budget, :image, :proposing_member, :approved, :campaign_id, :district_id, :area_id, tag_ids: [])
    p[:budget] = "0"
    p[:budget] = p[:budget]&.gsub(',', '_')&.to_d if p[:budget] #no need for budget in suggestion probably
    p[:image] = nil if params[:delete_image]
    p
  end
end
