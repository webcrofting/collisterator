require 'rails_helper'

feature "Creating ListTypes", js: true do

	let!(:ltp) { ListTypePage.new }
	
	before(:each) do
		ltp.open
	end

	scenario "an admin can create a ListType" do
		admin = create(:user, :role => "admin") 
		ltp.login(admin)
		click_link 'New List Type'	
		fill_in 'List Type Name', :with => "Voter List"
		click_button "Add Field For List"
		sleep 1
		save_and_open_screenshot
	end

	scenario "a payer can create a ListType"
	
	scenario "a player cannot create a ListType"
end

