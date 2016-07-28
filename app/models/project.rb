class Project < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy

  with_options presence: true do |p|
    p.validates :name, length: { maximum: 255 }
    p.validates :user
  end

end
