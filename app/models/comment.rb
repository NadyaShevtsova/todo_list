class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  has_many :attachments, dependent: :destroy
  attr_accessor :attachment_ids

  with_options presence: true do |c|
    c.validates :comment, length: { maximum: 65536 }
    c.validates :user
  end

  default_scope -> { order('created_at ASC') }
  after_create :update_attachments

  private
  def update_attachments
    unless self.attachment_ids.blank?
      self.attachment_ids.each do |id|
        Attachment.find(id.to_i).update_column :comment_id, self.id
      end
    end
  end

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable
end
