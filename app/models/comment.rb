class Comment < ApplicationRecord
  belongs_to :voter
  belongs_to :parent, class_name: 'Comment', foreign_key: 'comment_id', optional: true
  belongs_to :proposal, optional: true
  has_many :responses, class_name: 'Comment'
  belongs_to :suggestion, optional: true

  validates :text, presence: true

  def root_parent
    return self if parent.nil?
    parent.root_parent
  end
end
