require 'rails_helper'

describe User do
  it { should have_many(:identities).dependent(:destroy) }
  it { should have_many(:projects).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
end
