require 'rails_helper'

describe ListTypeField do
  it { is_expected.to belong_to :list_type }
  it { is_expected.to validate_presence_of :list_type }
end
