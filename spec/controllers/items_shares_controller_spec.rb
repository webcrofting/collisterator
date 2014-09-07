require 'rails_helper'
describe ItemSharesController do
  let!(:email) { 'albion@example.com' }
  let!(:item) { create(:item) }

  describe "#create" do
    
    let(:params) { { owner_id: owner.id, item_id: item.id, shared_user_email: email } } 
    
    context "with valid params"  do
      
      context "as an admin" do
        let(:owner) { create(:user, role: 'admin') }
        it_behaves_like "an authorized ItemShares creator"
      end

      context "as a payer" do
        let(:owner) { create(:user, role: 'payer') }
        it_behaves_like "an authorized ItemShares creator"
      end

      context "as a player" do
        let(:owner) { create(:user, role: 'player') }
        it_behaves_like "an authorized ItemShares creator"
      end

      #TODO: this should have different behavior. unauthorized users do not have profiles
      context "unauthorized" do
        let(:owner) { create(:user, role: nil) }
        it_behaves_like "an authorized ItemShares creator"
      end
    end

    context "with invalid params" do
      let(:params) { { owner_id: owner.id, item_id: nil, shared_user_email: email } }

      context "as an admin" do
        let(:owner) { create(:user, role: 'admin') }
        it_behaves_like "an invalid ItemShares creation"
      end

      context "as a payer" do
        let(:owner) { create(:user, role: 'payer') }
        it_behaves_like "an invalid ItemShares creation"
      end

      context "as a player" do
        let(:owner) { create(:user, role: 'player') }
        it_behaves_like "an invalid ItemShares creation"
      end

      context "unauthorized" do
        let(:owner) { create(:user, role: nil) }
        it_behaves_like "an invalid ItemShares creation"
      end
    end
	end
end
