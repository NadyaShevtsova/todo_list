require 'rails_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:commentable) }
  it { should have_many(:attachments).dependent(:destroy) }


  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:comment) }

  it { should validate_length_of(:comment).is_at_most(65536) }
end
