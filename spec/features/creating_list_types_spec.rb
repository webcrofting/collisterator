require 'rails_helper'

feature "Creating ListTypes", js: true do

	let!(:ltp) { ListTypePage.new }
	
	before(:each) do
		ltp.open
	end

	scenario "an admin can create a ListType" do
		admin = create(:user, :role => "admin") 
		ltp.login(admin)
		ltp.make_new_list_type
		ltp.name_list_type('Voter List')
		
		field = { :name => "candidate", :data => "Joe Politician" }
		ltp.add_field(field)

		ltp.save_list_type
		expect(ltp).to have_saved_list_type
		expect(ltp).to have_saved_fields([field])	
	end

	scenario "a payer can create a ListType" do
		payer = create(:user, :role => "payer")
		ltp.login(payer)

		ltp.make_new_list_type
		ltp.name_list_type('Baby Animals')
		
		field = { :name => "name", :data => "capybara" }
		field1 = { :name => "url", :data => "http://gianthampster.com" }
		ltp.add_field(field)
		ltp.add_field(field1)

		ltp.save_list_type
		expect(ltp).to have_saved_list_type
		expect(ltp).to have_saved_fields([field, field1])
	end
	
	scenario "a player cannot create a ListType" do
		player = create(:user, :role => "player")
		ltp.login(player)
		ltp.make_new_list_type
		expect(page).to have_content("You are not authorized to access this page.")
	end
end

