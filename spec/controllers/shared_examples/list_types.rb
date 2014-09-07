# ListTypesController
# GET#index (free for all)

shared_examples_for "any user who can get to the home page" do
	it "gets all the root items" do 
		get :index
		expect(assigns(:list_types).length).to eq(3)
	end

	it "renders the template :index" do
		get :index
		expect(response).to render_template :index
	end

	it "renders json" do
		get :index, format: :json
		expect(response.content_type).to eq('application/json')
	end
end

# ListTypesController
# GET#show (free for all)

shared_examples_for "an authorized list_type viewer" do
	it "assigns the @list_type" do
		get :show, id: list_type.id
		expect(assigns(:list_type)).to eq(list_type)
	end

	it "renders the show template" do
		get :show, id: list_type.id
		expect(response).to render_template :show
	end

	it "has an ok response" do
		get :show, id: list_type.id
		expect(response).to be_ok
	end

	it "renders json ok" do
		get :show, id: list_type.id, format: :json
		expect(response).to be_ok
	end

	it "renders json" do
		get :show, id: list_type.id, format: :json
		expect(response.content_type).to eq('application/json')
	end
end


# ListTypesController
# GET#edit (unauthorized)
shared_examples_for "an unauthorized editor" do
	it "assigns the @list_type" do
		get :edit, id: list_type.id
		expect(assigns(:list_type)).to eq(list_type)
	end
	
	it "does not render the edit template" do
		get :edit, id: list_type.id
		expect(response).to_not render_template :edit
	end

	it "has an unsuccessful response" do
		get :edit, id: list_type.id
		expect(response).to redirect_to root_path
	end

	it "flashes an error to the user" do
		get :edit, id: list_type.id
		expect(flash[:error]).to eq('You are not authorized to access this page.')
	end
end

# ListTypesController
# GET#edit (authorized)
shared_examples_for "an authorized editor" do
	it "assigns the @list_type" do
		get :edit, id: list_type.id
		expect(assigns(:list_type)).to eq(list_type)
	end

	it "renders the edit template" do
		get :edit, id: list_type.id
		expect(response).to render_template :edit
	end
end

# ListTypesController
# POST#create
shared_examples_for "an authorized creator who sends good params" do
  it "assigns a new ListType with the given params" do
		post :create, params
		expect(assigns(:list_type)).to be_a ListType
		expect(assigns(:list_type).name).to eq('Movies')
	end

	it "redirects to the new @list_type" do
		post :create, params
		list_type = assigns(:list_type)
		expect(response).to redirect_to(list_type)
		expect(flash[:notice]).to eq('List type was successfully created.')
	end

	it "responds to json" do
    params[:format] = :json
		post :create, params
		expect(response.content_type).to eq('application/json')
	end

	it "responds with created" do
    params[:format] = :json
		post :create, params
		expect(response.status).to eq(201)
	end
end

shared_examples_for "an unauthorized creator" do
	it "redirects to the home page" do
		post :create, params
		expect(response).to redirect_to root_path
	end

	it "does not save the list_type" do
		expect {
			post :create, params
		}.to_not change(ListType, :count)
	end
end

shared_examples_for "an authorized creator who sends bad params" do
  it "assigns the @list_type" do
    post :create, list_type: params
    expect(assigns(:list_type)).to be_a ListType
  end

  it "should not save" do
    expect {
      post :create, list_type: params
    }.to_not change(ListType, :count)
  end
  
  it "should render action :new" do
    post :create, list_type: params
    expect(response).to render_template("new")
  end

  it "should respond with unprocessable entity" do
    post :create, list_type: params, format: :json
    expect(response.status).to eq(422)
  end
end

shared_examples_for "an authorized update with valid params" do
  it "located the requested @list_type" do
    put :update, id: list_type.id, list_type: params  
    expect(assigns(:list_type)).to eq(list_type) 
  end 

  it "updated the @list_type" do
    put :update, id: list_type.id, list_type: params 
    expect(assigns(:list_type).name).to eq('Bogus') 
  end

  it "redirects to the @list_type" do
    put :update, id: list_type.id, list_type: params 
    expect(response).to redirect_to(list_type)
    expect(flash[:notice]).to eq('List type was successfully updated.')
  end

  it "responds with :no_content for json" do
    put :update, id: list_type.id, list_type: params, format: :json
    expect(response.status).to eq(204) # :no_content
  end
end

shared_examples_for "an authorized update with invalid params" do
  it "assigns the requested @list_type" do
    put :update, id: list_type.id, list_type: attributes_for(:list_type, name: nil)
    expect(assigns(:list_type)).to eq(list_type)
  end

  it "renders the edit view" do
    put :update, id: list_type.id, list_type: attributes_for(:list_type, name: nil)
    expect(response).to render_template("edit")
  end

  it "responds with :unprocessable_entity for json requests" do
    put :update, id: list_type.id, list_type: attributes_for(:list_type, name: nil), format: :json
    expect(response.status).to eq(422)
  end
end

shared_examples_for "an unauthorized update" do
  before(:each) { put :update, id: list_type.id, list_type: params }
  it "finds the requested @list_type" do
    expect(assigns(:list_type)).to eq(list_type) 
  end 

  it "does not update the @list_type" do
    expect(assigns(:list_type).name).to_not eq('Bogus') 
  end

  it "redirects to the home page" do
    expect(response).to redirect_to root_path
    expect(flash[:error]).to eq("You are not authorized to access this page.")
  end
end
