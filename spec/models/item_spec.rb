require 'rails_helper'
describe "Item" do
	let!(:item) { create(:item) }

  it "is valid" do
		expect(item).to be_valid	
	end			
	
	it "generates a random token" do
		expect(item.token).to_not be_nil
	end
end
