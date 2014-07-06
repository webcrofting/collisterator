class ProfilePage < Page

	def loaded?
		page.has_content?("Welcome") && page.has_content?("Your Lists:")
	end

end
