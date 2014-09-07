class ListTypeCreator
	
	def initialize(params)
		@params = params
    some_kind_of = valid_params? ? 'valid' : 'invalid'
	end

	def save
		@list_type = ListType.new
		if valid_params?
			ListType.transaction do
				@list_type.update_attributes(@params[:list_type])
				add_list_type_settings if @list_type.valid?
			end
		end
		@list_type.persisted?
	end

	def list_type
		(@list_type && @list_type.valid?) ? @list_type : ListType.new # in case list_type is called before save
	end

private

	def valid_params?
		@params && @params[:list_type_type] && @params[:list_type]
	end

	def add_list_type_settings
		case @params[:list_type_type]
		when 'plain list'
			add_plain_list_settings
		when 'tree'
			add_tree_list_settings
		else
		end
	end

	def add_plain_list_settings
		@list_type.can_have_children = false
		@list_type.can_be_root = false
		@list_type.save!
		@parent_list_type = ListType.new
		@parent_list_type.name = @list_type.name
		@parent_list_type.fields = '[{"name":"title", "type":"text", "default":"Title"}]'
		@parent_list_type.template = "<td  data-name='title' data-type='text' class='editable'>{{data.title}}</td>"
		@parent_list_type.default_data = "{\"title\":\"#{@list_type.name}\"}"
		@parent_list_type.can_have_children = true
		@parent_list_type.can_be_root = true
		@parent_list_type.children_list_type_id = @list_type.id
		@parent_list_type.save!
	end

	def add_tree_list_settings
		@list_type.can_have_children = true
		@list_type.can_be_root = true
		@list_type.children_list_type_id = @list_type.id
		@list_type.save!
	end
end
