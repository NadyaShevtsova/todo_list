class Task < ActiveRecord::Base
  belongs_to :project

  acts_as_commentable

  with_options presence: true do |t|
    t.validates :name, length: { maximum: 255 }
    t.validates :deadline, timeliness: { type: :date }
    t.validates :project
  end

  validates :mark_as_done, inclusion: {in: [true, false]}
  validates_numericality_of :prioritize, allow_nil: true
end
