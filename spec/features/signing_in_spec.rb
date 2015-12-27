require 'rails_helper'

feature "Signing In" do

	let!(:home) { HomePage.new }

	before(:each) do
		home.open
	end

	scenario "as an owner" do
		admin = create(:user, :role => Role::OWNER)
		home.login(admin)
		expect(home).to have_successful_login
	end

	scenario "as an invitee" do
		payer = create(:user, :role => Role::INVITEE)
		home.login(payer)
		expect(home).to have_successful_login
	end
end
