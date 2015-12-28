require 'rails_helper'

describe Item do
	let!(:item) { create(:item) }

  it { is_expected.to belong_to :list_type }
  it { is_expected.to belong_to :parent }
  it { is_expected.to belong_to :user }
  it { is_expected.to have_many :children }
  it { is_expected.to validate_presence_of(:list_type) }

  describe "token is generated on create" do
    it { expect(create(:item).token).to_not be_nil }
  end
end
