class Suggestion::CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]


  def create
    set_suggestion
    set_parent
    if RegisterSuggestionComment.call(text, current_voter, @suggestion, @parent)
      flash[:success] = _('Your comment was successfully posted.')
    else
      flash[:error] = _('There was a problem registering your comment.')
    end
    redirect_to admin_suggestions_path
  end

  def destroy
    @comment.destroy
    redirect_to :back, success: _('Comment was successfully deleted.')
  end

  private

  def set_suggestion
    #Rails.logger.debug("FearonTheOne")
    Rails.logger.debug(suggestion_id)
    @suggestion = Suggestion.find(suggestion_id)
  end

  def set_comment
    # Rails.logger.debug("==== Test Data Point====")
    # Rails.logger.debug(params[:id])
    # Rails.logger.debug(params[:suggestion_id])
    @comment = Comment.find(params[:suggestion_id]) #comment ID being sent as :suggestion_id, :id holds actual suggestion ID
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
