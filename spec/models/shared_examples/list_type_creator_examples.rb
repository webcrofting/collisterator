# ListTypeCreator#new
shared_examples_for "sending valid list type params" do
	it "instantiates a new instance of ListTypeCreator" do
		expect(ListTypeCreator.new(params)).to be_a ListTypeCreator
	end
	
	it "assigns the params to @params" do
		lt = ListTypeCreator.new(params)
		expect(lt.instance_variable_get('@params')).to eq(params)
	end
end

# ListTypeCreator#save
shared_examples_for "a valid list type save" do
	it "returns true" do
		expect(list_type_creator.save).to be true
	end
	
	it "saves the list type" do
		list_type_creator.save
		lt = list_type_creator.instance_variable_get('@list_type')
		expect(lt).to be_persisted
	end

end

shared_examples_for "an invalid list type save" do
	it "responds with false" do
		expect(list_type_creator.save).to be false	
	end

	it "does not save the list type" do
		list_type_creator.save
		expect(list_type_creator.list_type).to_not be_persisted
	end
end

