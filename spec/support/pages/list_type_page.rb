class ListTypePage < Page

	def initialize
		@fields = 0
	end
	
	def open
		visit '/'
	end

	def make_new_list_type
		click_link 'New List Type'	
	end

	def name_list_type(name)
		fill_in 'List Type Name', :with => name
	end

	def add_field(field)
		click_button "Add Field For List"
		field_name = page.find("#field-name#{@fields}")
		field_name.set(field[:name])
		field_data = page.find("#field-data#{@fields}")
		field_data.set(field[:data])
		increment_fields
	end

	def save_list_type
		click_button "Save"	
	end

	def has_saved_list_type?
		page.has_content?("List type was successfully created")
	end

	def has_saved_fields?(fields)

		fields.each do |field|
			unless page.has_content?(field[:name]) && 
			  page.has_content?(field[:data]) 
					return false
			end
		end
		true
	end

private
	def increment_fields
		@fields += 1		
	end	
end
