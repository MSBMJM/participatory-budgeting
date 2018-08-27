class Monitoring::ProposalsController < ApplicationController
  def index
    classifiers_filter = params[:class].split(',').map(&:to_i) if params[:class]
    budget_min_filter = params[:budget_min]
    budget_max_filter = params[:budget_max]
    Rails.logger.debug("========")
    Rails.logger.debug("Proposals Home")
    Rails.logger.debug(params.inspect)
    Rails.logger.debug(params[:id])
    Rails.logger.debug("+++")

    if params[:id]
      @campaign = Campaign.find(params[:id])
      Rails.logger.debug(@campaign.title)
      Rails.logger.debug(@campaign.id)

      @proposals = @campaign.voted_proposals.includes(:classifiers)

      @budget_max = @proposals.max_by(&:budget)&.budget&.ceil || 0

      @proposals = @proposals.with_class(*classifiers_filter) unless classifiers_filter.blank?
      @proposals = @proposals.budget_min(budget_min_filter)   unless budget_min_filter.blank?
      @proposals = @proposals.budget_max(budget_max_filter)   unless budget_max_filter.blank?

      bad_proposals ||= []
      count = 1
      #checks for porper filtering of proposals
      @proposals.each do |prop|
        # Rails.logger.debug("+++======+++")
        # Rails.logger.debug(prop.campaign_id)
        if classifiers_filter.present?

          @bool2 = (prop&.classifier_ids & classifiers_filter) == prop&.classifier_ids ? "TRUE" : "FALSE" #prop&.classifier_ids #(prop.classifier_ids - classifiers_filter).empty?
          #check if proposals classifiers ids selected by query are a subset of the classifiers submitted by user
          if !((prop&.classifier_ids & classifiers_filter) == prop&.classifier_ids)
            # @proposals.delete(prop)
            bad_proposals.push(prop)
            # Rails.logger.debug("Does Not belong!")
          end
        end
        count += 1
      end
      # printf "bad size: "
      # Rails.logger.debug(bad_proposals.size)

      # cleaned_proposals = @proposals - bad_proposals
      @proposals = @proposals - bad_proposals

    end
    # @proposals = Campaign.current.voted_proposals.includes(:classifiers)
    # @budget_max = @proposals.max_by(&:budget)&.budget&.ceil || 0
    #
    # @proposals = @proposals.with_class(*classifiers_filter) unless classifiers_filter.blank?
    # @proposals = @proposals.budget_min(budget_min_filter)   unless budget_min_filter.blank?
    # @proposals = @proposals.budget_max(budget_max_filter)   unless budget_max_filter.blank?

    classifiers = @proposals.flat_map(&:classifiers).uniq
    @districts = classifiers.select{ |_| _.is_a?(District) }
    @areas = classifiers.select { |_| _.is_a?(Area) }
    @tags = classifiers.select { |_| _.is_a?(Tag) }
    render json: { proposals_ids: @proposals.map(&:id) } and return if xhr_request?
  end

  def show
    @proposal = Proposal.find(params[:id])
  end

  def summarize
    @proposals = Campaign.current.voted_proposals.order(budget: :desc)
  end
end