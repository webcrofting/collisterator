class HomePage < Page

	def open
		visit '/'
	end
	
	def has_successful_login?
		page.has_content? "Signed in successfully."
	end
end
