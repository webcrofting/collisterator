require 'rails_helper'

describe ListTypesController do
	
	describe "GET#index" do
		it "gets all the root items"
		
		it "renders the template :index" do
			get :index
			expect(response).to render_template :index
		end
	end

	describe "GET#show" do

	end

	describe "GET#edit" do
		let(:list_type) { create(:list_type) }

		context "as an admin" do
			before { sign_in create(:user, role: 'admin') }

			it "renders the edit template" do
				get :edit, id: list_type.id
				expect(response).to render_template :edit
			end

		end

		context "as a player"

		context "as a payer"

		context "unauthoried" do
			it "redirects to the home page" do
				get :edit, id: list_type.id
				expect(response).to redirect_to root_url
			end
		end
		
	end

	describe "POST#create" do
		context "with valid params" #these should be shared examples. test against each role
		context "with invalid params"
	end

	describe "PUT#update" do
		context "with valid params"
		context "with invalid params"
	end

	describe "DELETE#destroy" do

	end
end
