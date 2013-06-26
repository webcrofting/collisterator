class ListType < ActiveRecord::Base
  belongs_to :user
  def as_json(options = nil) 
    list_type_sample_hash(self)
  end
  
  def list_type_sample_hash(list_type)
    sample_hash = {:id => list_type.id}
    sample_array = build_sample_array(list_type)
    samples = []
    sample_array.each do |sample|
     hash = {:list_type => sample.id, :data => sample.default_data, :template => sample.template} 
     samples << hash
    end
    sample_hash[:sample_set]=samples
  end

  def build_sample_array(list_type)
    sample_array = []
    sample_array << list_type

    parent_id = list_type.id
    child_id = list_type.id
    have_next_generation = true
    4.times do
      parent = ListType.where(:children_list_type_id => '#{child_id}').first
      unless parent.blank? || parent==list_type
          sample_array.unshift parent
          child_id = parent.id
      end

      child = ListType.find(parent_id)
      unless child.blank? || child==list_type
        sample_array << child
        paret_id = child.id
      end

      if (parent.blank? && child.blank?) || (sample_array.length==5)
        break
      end
        
    end
    return sample_array
  end

end
