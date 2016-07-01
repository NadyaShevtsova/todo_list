class Identity < ActiveRecord::Base
  belongs_to :user
  validates :uid, uniqueness: { scope: :provider }, presence: true
  validates :provider, presence: true

  def self.find_for_oauth auth
    find_or_create_by( uid: auth.uid, provider: auth.provider )
  end
end
