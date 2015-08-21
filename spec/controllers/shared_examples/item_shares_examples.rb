shared_examples_for "an authorized ItemShares creator" do
  before(:each) { sign_in owner }

  it "assigns a new @item_share" do
    post :create, item_share: params
    expect(assigns(:item_share)).to be_a ItemShare
  end

  it "updates the @item_share attributes" do
    post :create, item_share: params
    expect(assigns(:item_share).owner_id).to eq(owner.id)
    expect(assigns(:item_share).item_id).to eq(item.id)
  end

  it "creates the @item_share" do
    expect {
      post :create, item_share: params
    }.to change(ItemShare, :count).by(1)
  end

  it "redirects to the profile" do
    post :create, item_share: params
    expect(response).to redirect_to profile_path(owner)
    expect(flash[:notice]).to eq("Item successfully shared.")
  end
end

shared_examples_for "an invalid ItemShares creation" do
  #TODO: this should handle failure more gracefully
  it "throws an error" do
    expect(
      post :create, item_share: params
    ).to redirect_to(new_item_share_url)
  end
end
