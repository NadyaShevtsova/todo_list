require 'rails_helper'

describe Task do
  it { should belong_to(:project) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:project) }
  it { should validate_presence_of(:deadline) }

  it { should validate_length_of(:name).is_at_most(255) }
  it { should validate_timeliness_of :deadline }
  it { should allow_value( Date.today ).for(:deadline) }
  it { should allow_value(true, false).for(:mark_as_done) }
  it { should_not allow_value(nil).for(:mark_as_done) }
  it { should validate_numericality_of(:prioritize).allow_nil }
end
