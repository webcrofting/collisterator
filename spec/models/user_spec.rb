require 'spec_helper'

describe User do
  it { is_expected.to belong_to :role }
end


