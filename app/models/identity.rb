class Identity < ActiveRecord::Base
  belongs_to :user
  with_options presence: true do |i|
    i.validates :uid, uniqueness: { scope: :provider }
    i.validates :provider
  end


  def self.find_for_oauth auth
    find_or_create_by( uid: auth.uid, provider: auth.provider )
  end
end
