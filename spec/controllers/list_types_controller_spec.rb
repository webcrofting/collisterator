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
			let!(:params) { attributes_for(:list_type, name: 'Movies') }
			
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
				it_behaves_like "an unauthorized creator who sends good params"
			end

			context "unauthorized" do
				before { sign_in create(:user, role: nil) }
				it_behaves_like "an unauthorized creator who sends good params"
			end
		end

		context "with invalid params" do
			let!(:invalid) { nil }

			context "as an admin" do
				before { sign_in create(:user, role: 'admin') }

				it "assigns the @list_type" do
					post :create, list_type: invalid
					expect(assigns(:list_type)).to be_a ListType
				end

				# TODO : Failing SPEC
				# Should list types save if params are invalid??	
				# what consistutes valid params
				it "should not save" do
					expect {
						post :create, list_type: invalid
					}.to_not change(ListType, :count)
				end
			end
		end
	end

	describe "PUT#update" do
		context "with valid params"
		context "with invalid params"
	end

	describe "DELETE#destroy" do

	end
end
