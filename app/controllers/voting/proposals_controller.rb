class Voting::ProposalsController < ApplicationController
  def index
    if session[:verification_pending]
      # flash.now[:notice] = _('<strong>Verification pending</strong>, please see your inbox for further instructions.')
    end
    # @campaign_budget = Campaign.current.budget
    # used to capture campaign in multi-constituency workflow
    #@campaign = Campaign.find(session[:current_campaign_id])
    @campaign = Campaign.current
    Rails.logger.debug("=========== campaign title")
    # Rails.logger.debug(@proposals)
    Rails.logger.debug(@campaign.title)

    unless current_voter.nil?
      if current_voter.votes_submitted?(@campaign)
        redirect_to summarize_voting_proposals_path
        return
      end
    end

    @campaign_budget = @campaign.budget

    classifiers_filter = params[:class].split(',').map(&:to_i) if params[:class]
    budget_min_filter = params[:budget_min]
    budget_max_filter = params[:budget_max]
    # @proposals = Campaign.current.proposals.includes(:classifiers)

    @proposals = @campaign.proposals.includes(:classifiers)

    @budget_max = @proposals.max_by(&:budget)&.budget&.ceil || 0

    Rails.logger.debug("===========")
    # Rails.logger.debug(@proposals)
    Rails.logger.debug(classifiers_filter)
    Rails.logger.debug("===========")
    # printf "TEST"
    @proposals = @proposals.with_class(*classifiers_filter) unless classifiers_filter.blank?
    @proposals = @proposals.budget_min(budget_min_filter)   unless budget_min_filter.blank?
    @proposals = @proposals.budget_max(budget_max_filter)   unless budget_max_filter.blank?
    @proposals = @proposals.shuffle
    # @proposals

    @caught_classifiers = Proposal.where(id: classifiers_filter)

    Rails.logger.debug(@caught_classifiers.size)

    classifiers = @proposals.flat_map(&:classifiers).uniq
    Rails.logger.debug("=====Returned Classifiers======")
    Rails.logger.debug(classifiers)
    Rails.logger.debug("===============================")

    # base = joins(:classifiers).where(classifiers: { id: classifiers_filter })
    # with_districts = base.where(classifiers: { type: 'District' })

    # Rails.logger.debug("===== District Catch =====")
    # Rails.logger.debug(with_districts)
    # Rails.logger.debug("===========")

    # Rails.logger.debug(classifiers.size)
    Rails.logger.debug("<Proposal Size>")
    Rails.logger.debug(@proposals.size)
    bad_proposals ||= []
    count = 1
    #checks for porper filtering of proposals
    @proposals.each do |prop|
      # printf "count: "
      # Rails.logger.debug(count)
      # Rails.logger.debug("<===========>")
      # Rails.logger.debug(prop.title)
      # Rails.logger.debug(prop.tags.classifier_id)
      if classifiers_filter.present?
        # Rails.logger.debug(classifiers_filter)
        # Rails.logger.debug(prop.classifier_ids)
        # @bool = classifiers_filter == prop.classifier_ids ? "TRUE" : "FALSE"
        # Rails.logger.debug(@bool)
        @bool2 = (prop&.classifier_ids & classifiers_filter) == prop&.classifier_ids ? "TRUE" : "FALSE" #prop&.classifier_ids #(prop.classifier_ids - classifiers_filter).empty?
        #check if proposals classifiers ids selected by query are a subset of the classifiers submitted by user
        if !((prop&.classifier_ids & classifiers_filter) == prop&.classifier_ids)
          # @proposals.delete(prop)
          bad_proposals.push(prop)
          # Rails.logger.debug("Does Not belong!")
        end
        # Rails.logger.debug(@bool2)

        # Rails.logger.debug(prop&.classifiers)
        # Rails.logger.debug("<===========>")
      end
      count += 1
    end
    # printf "bad size: "
    # Rails.logger.debug(bad_proposals.size)

    # cleaned_proposals = @proposals - bad_proposals
    @proposals = @proposals - bad_proposals

    # printf "Cleaned size: "
    # Rails.logger.debug(@proposals.size)

    @districts = classifiers.select{ |_| _.is_a?(District) }
    @areas = classifiers.select { |_| _.is_a?(Area) }
    @tags = classifiers.select { |_| _.is_a?(Tag) }
    render json: { proposals_ids: @proposals.map(&:id) } and return if xhr_request?
  end

  def show
    @proposal = Proposal.find(params[:id])
  end

  def update
    @proposal = Proposal.find(params[:id])
    unless current_voter.votes_submitted?(@proposal.campaign)
      result = if @proposal.voted_by?(current_voter)
        UnvoteProposal.call(current_voter, @proposal)
      else
        VoteProposal.call(current_voter, @proposal)
      end
    end


    if result
      head :no_content
    else
      head :unprocessable_entity, error: _('There was an error while trying to register your vote.')
    end
  end

  def summarize
    # Rails.logger.debug("Does Not belong!")
    # Rails.logger.debug(@campaign)
    # Rails.logger.debug(params[:id])
    @campaign = Campaign.find(session[:current_campaign_id])
    # Rails.logger.debug(@campaign.title)
    if current_voter
      # Rails.logger.debug(current_voter.votes_submitted?(@campaign))
      @proposals = current_voter.proposals.order(budget: :desc)
      unless current_voter.votes_submitted?(@campaign)
        current_voter.voted_campaigns << @campaign.id.to_s + ','
        current_voter.save
      end
      flash.now[:notice] = _('Your vote has been recorded')
    else
      referer = request.referer || new_voter_path(referer: request.path)
      redirect_to referer, alert: _('You need to <strong>sign in</strong> in order to view your vote.')
    end
  end
end
