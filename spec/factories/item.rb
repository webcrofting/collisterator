FactoryGirl.define do 
	factory :item, class:Item do				
		name 					'TestItem'
		list_type_id 	{ create(:list_type).id }
	end
end
