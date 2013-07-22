class ListType < ActiveRecord::Base
  belongs_to :user
  def as_json(options = nil) 
    list_type_sample_hash(self)
  end
  
  def list_type_sample_hash(list_type)
    sample_array = build_sample_array(list_type)
    samples = []
    sample_array.each do |sample|
     hash = {:list_type => sample.id, :data => JSON.parse(sample.default_data), :template => sample.template} 
     samples << hash
    end
    { :id => list_type.id, :data => list_type.default_data, :template => list_type.template, 
      :sample_array => samples}
  end

  def build_sample_array(list_type)
    sample_array = []
    sample_array << list_type

    parent_id = child_id = list_type.id
		#logger.debug"Parent id? : #{parent_id}, Child id? : #{child_id}"
    4.times do
      parent = ListType.find_by_children_list_type_id(child_id)
      unless parent.blank? || parent==list_type
          sample_array.unshift parent
          child_id = parent.id
      end

      temp = ListType.find(parent_id)
			unless temp.children_list_type_id.blank?
				child = ListType.find(temp.children_list_type_id)
			end
      unless child.blank? || child==list_type
        sample_array << child
        parent_id = child.id
      end	

      if (parent.blank? && child.blank?) || (sample_array.length==5)
        break
      end
        
    end
    return sample_array
  end

end
