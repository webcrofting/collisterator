require 'rails_helper'
describe "List Type" do
	let!(:list_type) { create(:list_type) }
  it "produces a valid factory" do
		expect(list_type).to be_valid	
	end			
end
