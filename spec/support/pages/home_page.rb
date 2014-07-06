class HomePage < Page

	def open
		visit '/'
	end

	def loaded?
		page.has_content? "Featured List Types"
	end
	
	def has_successful_login?
		page.has_content? "Signed in successfully."
	end

	def profile(user)
		click_link "#{user.email}"	
		ProfilePage.new
	end
end
