class User < ActiveRecord::Base
  TEMP_EMAIL_PREFIX = 'change@me'

  has_many :identities, dependent: :destroy
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_oauth(auth, current_user = nil)
    identity = Identity.find_for_oauth(auth)
    user = current_user || User.where(({ email: [auth.info.email, self.temp_email(auth.uid, auth.provider)]})).first

    if identity.user.blank?

      if user.nil?
        user = User.new(
          email:  auth.info.email || self.temp_email(auth.uid, auth.provider),
          password: Devise.friendly_token[0,20]
        )
        user.save!
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    identity.user
  end


  def self.temp_email( uid, provider )
    "#{TEMP_EMAIL_PREFIX}-#{uid}-#{provider}.com"
  end

end
