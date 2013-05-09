module UsersHelper
	def get_users_items(user) 
		return user.items
	end

	def get_shared_items(user)
		return user.shared_items
	end

	def get_list_type(user)
		return user.list_types
	end
end
