require 'rails_helper'

describe Project do
  it { should belong_to(:user) }
  it { should have_many(:tasks).dependent(:destroy) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user) }
  it { should validate_length_of(:name).is_at_most(255) }
end
