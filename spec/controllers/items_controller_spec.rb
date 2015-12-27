require 'rails_helper'

describe ItemsController do

  describe "GET#new" do
    let(:list_type) { create(:list_type) }
    before { get :new, list_type_id: list_type.id }

    it { is_expected.to redirect_to item_path(assigns(:item))}

    it { expect(assigns(:item).list_type).to eq(list_type) }
  end

	describe "GET#show" do
		let!(:item) { create(:item) }
		it "finds an item by id" do
			get :show, id: item.id
			expect(assigns(:item)).to eq(item)
		end

		it "finds an item by token" do
			get :show, id: item.token
			expect(assigns(:item)).to eq(item)
		end

		it "renders show.html.haml" do
			get :show, id: item.token
			expect(response).to render_template :show
		end

		it "renders json" do
			get :show, id: item.id, format: :json
			expect(response.content_type).to eq('application/json')
			expect(response).to be_successful
		end

		it "renders the expected json" do
			get :show, id: item.id, format: :json
			json = JSON.parse(response.body)
			expect(json).to eq( { "token" => item.token, "list_type_id" => item.list_type_id, "data" => item.data }  )
			expect(response.body).to eq(item.to_json)
		end
	end

	describe "POST#create" do
		context "when there is a parent_token" do
			let!(:lt) { create(:list_type, default_data: "{}") }
			let!(:parent) { create(:item, list_type_id: lt.id) }
			let!(:item) { attributes_for(:item, parent_id: parent.token) }

			it "sets the parent_id of the new item"	do
				post :create, item: item
				expect(assigns(:item).parent_id).to eq(parent.id)
			end

			it "sets the new list type to the parents list type" do
				post :create, item: item
				expect(assigns(:item).list_type_id).to eq(lt.id)
			end

			it "sets the data to the list type's default data" do
				post :create, item: item
				expect(assigns(:item).data).to eq(JSON.parse(lt.default_data)) # ?? shouldnt have to re-parse here
			end

			it "adds the item to the current_user's items" do
				user = create(:user)
				sign_in user

				post :create, item: item
				expect(user.items).to include(assigns(:item))
			end

			it "redirects_to @item" do
				post :create, item: item
				expect(response).to redirect_to (assigns(:item))
			end

			it "renders json for @item" do
				post :create, item: item, format: :json
				expect(response.header['Content-Type']).to include('application/json')
			end

			it "has a status of :created when expected response is json" do
				user = create(:user)
				sign_in user

				post :create, item: item, format: :json
				expect(response).to have_http_status(:created)
			end
		end
	end

	describe "PUT#update" do
		let!(:item) { create(:item) }
		let!(:params) { attributes_for(:item, name: 'Boo' ) }

		it "finds the item by id" do
			put :update, id: item.id, item: params
			expect(assigns(:item)).to eq(item)
		end

		it "finds the item by token" do
			put :update, id: item.token, item: params
			expect(assigns(:item)).to eq(item)
		end

		it "redirects to @item"	do
			put :update, id: item.token, item: params
			expect(response).to redirect_to(item)
		end

		it "responds with :no_content for json" do
			put :update, id: item.token, item: params, format: :json
			expect(response).to have_http_status(:no_content)
		end
	end

	describe "DELETE#destroy" do
		let!(:item) { create(:item) }

		it "finds the item by id" do
			delete :destroy, id: item.id
			expect(assigns(:item)).to eq(item)
		end

		it "finds the item by token" do
			delete :destroy, id: item.token
			expect(assigns(:item)).to eq(item)
		end

		it "destroys the item" do
			expect {
				delete :destroy, id: item.id
			}.to change(Item, :count).by(-1)
		end

		it "responds with ok" do
			delete :destroy, id: item.id
			expect(response).to be_ok
		end

		it "orphans all of the item's children" do
			children = [create(:item, parent_id: item.id), create(:item, parent_id: item.id)]
			delete :destroy, id: item.id
			children.each do |child|
				child.reload
				expect(child.parent_id).to eq(nil)
			end
		end
	end
end
