class Page
	include Capybara::DSL

	def login(user)
		click_link "Login or Register"
		fill_in 'email', :with => user.email 
		fill_in 'password', :with => user.password
		click_button 'Sign in'
	end
end
