require 'rails_helper'

feature "HomePage" do
	let(:home) { HomePage.new }	
	
	scenario "loads successfully" do
		home.open
		expect(home).to be_loaded
	end
end
