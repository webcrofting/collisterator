class ItemCreator

	def initialize(params, user)
		@params = params
		@user = user
		@item = create_item	
	end

	def result
		@item
	end

private
	
	def create_item
		item = Item.new
		
		item = validate_list_type(add_parent_settings_to(item))
			
		update_users_lists(item)

		item
	end

	def validate_list_type(item)
		
		if item.list_type_id 
			lt = ListType.find(item.list_type_id)
		else
			params_lt = @params[:item][:list_type_id]
			lt = ListType.find(params_lt) if params_lt
		end

		item.data = JSON.parse(lt.default_data) if lt
		item
	end

	def add_parent_settings_to(item)
		parent = Item.find_by_token(@params[:item][:parent_id])
		
		if parent
			item.parent_id = parent.id
			parent_list_type = ListType.find(parent.list_type_id)
			if parent_list_type.children_list_type_id.blank?
				item.list_type_id = parent_list_type.id
			else
				item.list_type_id = parent_list_type.children_list_type_id
			end
		end

		item	
	end

	def update_users_lists(item)
		if @user
			@user.items << item
		end
	end
end
