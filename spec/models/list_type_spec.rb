require 'rails_helper'

describe ListType do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:list_type_fields) }
end
