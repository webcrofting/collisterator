require 'rails_helper'

describe ListTypesController do
	
	describe "GET#index" do
		let!(:non_root_list_types) { create_pair(:list_type) }
		let!(:root_list_types) { create_list(:list_type, 3, can_be_root: true) }

		context "as an admin" do
			before { sign_in create(:user, role: 'admin') }
			it_behaves_like "any user who can get to the home page"
		end

		context "as a payer" do
			before { sign_in create(:user, role: 'payer') }
			it_behaves_like "any user who can get to the home page"
		end

		context "as a player" do
			before { sign_in create(:user, role: 'player') }
			it_behaves_like "any user who can get to the home page"
		end

		context "as a new user or guest" do
			before { sign_in create(:user, role: nil) }
			it_behaves_like "any user who can get to the home page"
		end
	end

	describe "GET#show" do
		let(:list_type) { create(:list_type) }
		context "as an admin" do
			before { sign_in create(:user, role: 'admin') }
			it_behaves_like "an authorized list_type viewer"
		end

		context "as a payer" do
			before { sign_in create(:user, role: 'payer') }
			it_behaves_like "an authorized list_type viewer"
		end
	
		context "as a player" do
			before { sign_in create(:user, role: 'player') }
			it_behaves_like "an authorized list_type viewer"
		end	

		context "as a new user or guest" do
			before { sign_in create(:user, role: nil) }
			it_behaves_like "an authorized list_type viewer"
		end
	end

	describe "GET#edit" do
		let(:list_type) { create(:list_type) }

		context "as an admin" do
			before { sign_in create(:user, role: 'admin') }
			it_behaves_like "an authorized editor"
		end

		context "as a player" do
			before { sign_in create(:user, role: 'player') }
			it_behaves_like "an unauthorized editor"
		end

		context "as a payer" do
			before { sign_in create(:user, role: 'payer') }
			it_behaves_like "an authorized editor"
		end

		context "unauthorized" do
			before { sign_in create(:user, role: nil) }
			it_behaves_like "an unauthorized editor"
		end
	end

	describe "POST#create" do
		
		context "with valid params" do	
			let(:params) { { :list_type_type => 'plain list', :list_type => attributes_for(:list_type, name: 'Movies') } }
			
			context "as an admin" do
				before { sign_in create(:user, role: 'admin') }
				it_behaves_like "an authorized creator who sends good params"
			end

			context "as a payer" do
				before { sign_in create(:user, role: 'payer') }
				it_behaves_like "an authorized creator who sends good params"
			end

			context "as a player" do
				before { sign_in create(:user, role: 'player') }
				it_behaves_like "an unauthorized creator"
			end

			context "unauthorized" do
				before { sign_in create(:user, role: nil) }
				it_behaves_like "an unauthorized creator"
			end
		end

		context "with invalid params" do
			let!(:params) { nil }

			context "as an admin" do
				before { sign_in create(:user, role: 'admin') }
        it_behaves_like "an authorized creator who sends bad params"
			end

      context "as a payer" do
				before { sign_in create(:user, role: 'payer') }
        it_behaves_like "an authorized creator who sends bad params"
      end

      context "as a player" do
				before { sign_in create(:user, role: 'player') }
				it_behaves_like "an unauthorized creator"
      end

      context "unauthorized" do
				before { sign_in create(:user, role: nil) }
				it_behaves_like "an unauthorized creator"
      end
		end
	end

	describe "PUT#update" do
    let!(:list_type) { create(:list_type) }

		context "with valid params" do
      
    end
		context "with invalid params"
	end

	describe "DELETE#destroy" do

	end
end
