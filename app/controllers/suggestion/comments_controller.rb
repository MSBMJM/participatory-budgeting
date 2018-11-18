class Suggestion::CommentsController < ApplicationController
  def create
    set_suggestion
    set_parent
    if RegisterSuggestionComment.call(text, current_voter, @suggestion, @parent)
      flash[:success] = _('Your comment was successfully registered.')
    else
      flash[:error] = _('There was a problem registering your comment.')
    end
    redirect_to admin_suggestions_path
  end

  private

  def set_suggestion
    #Rails.logger.debug("FearonTheOne")
    #Rails.logger.debug(suggestion_id)
    @suggestion = Suggestion.find(suggestion_id)
  end

  def set_parent
    @parent = Comment.find_by(id: parent_id)
  end

  def suggestion_id
    #Rails.logger.debug("FearonTheOne")
    #Rails.logger.debug(suggestion_id)
    params[:suggestion_id]
  end

  def parent_id
    comment_params[:comment_id]
  end

  def text
    comment_params[:text]
  end

  def comment_params
    Rails.logger.debug("FearonTheOne")
    #Rails.logger.debug(suggestion_id)
    params.require(:comment).permit(:text, :comment_id)
  end
end
