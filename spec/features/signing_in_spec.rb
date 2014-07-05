require 'rails_helper'

feature "Signing In" do

	let!(:home) { HomePage.new } 

	before(:each) do
		home.open
	end

	scenario "as an admin" do
		admin = create(:user, :role => "admin")
		home.login(admin)
		expect(home).to have_successful_login
	end

	scenario "as a payer" do
		payer = create(:user, :role => "payer")
		home.login(payer)
		expect(home).to have_successful_login
	end

	scenario "as a player" do
		player = create(:user, :role => "player")
		home.login(player)
		expect(home).to have_successful_login
	end
end
