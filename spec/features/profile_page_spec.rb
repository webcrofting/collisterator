require 'rails_helper'

feature "Profiles" do

	let!(:home) { HomePage.new }

	before(:each) do
		home.open
	end
	
	scenario "visible to admin" do
		admin = create(:user, role: "admin")
		home.login(admin)
		profile = home.profile(admin)
		expect(profile).to be_loaded
	end

	scenario "visible to payers" do
		payer = create(:user, role: "payer")
		home.login(payer)
		profile = home.profile(payer)
		expect(profile).to be_loaded
	end

	scenario "visible to players" do
		player = create(:user, role: "player")
		home.login(player)
		profile = home.profile(player)
		expect(profile).to be_loaded
	end
	
end
