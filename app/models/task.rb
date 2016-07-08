class Task < ActiveRecord::Base
  belongs_to :project

  with_options presence: true do |t|
    t.validates :name, length: { maximum: 255 }
    t.validates :deadline, timeliness: { type: :date }
    t.validates :project
  end

  validates :prioritize, inclusion: {in: [true, false]}
end
