require 'rails_helper'

describe Item do
	let!(:item) { create(:item) }

  it { is_expected.to belong_to :list_type }

  describe "create" do
    it { expect(create(:item).token).to_not be_nil }
  end
end
