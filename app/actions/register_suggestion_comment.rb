class RegisterSuggestionComment
  def self.call(text, voter, suggestion, parent)
    new(text, voter, suggestion, parent).call
  end

  def call
    @comment.persisted?
  end

  private

  def initialize(text, voter, suggestion, parent)
    @comment = Comment.create(text: text, voter: voter, suggestion: suggestion, parent: parent)
  end
end