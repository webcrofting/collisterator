require 'rails_helper'
require 'models/shared_examples/list_type_creator_examples'

describe ListTypeCreator do
	
	describe "#new" do
		context "when params is {}" do
			let!(:params) { {} }
			it_behaves_like "sending valid list type params"
		end

		context "when params is nil" do
			let!(:params) { nil }
			it_behaves_like "sending valid list type params"
		end

		context "when params are invalid" do
			let!(:params) { {bannanas: true} } 
			it_behaves_like "sending valid list type params"
		end

		context "when sending valid params" do
			let!(:params) { {list_type_type: 'plain list', list_type: { name: 'Movies' }} } 
			it_behaves_like "sending valid list type params"
		end
	end

	describe "#save" do
		let(:list_type_creator) { ListTypeCreator.new(params) }	
		
		context "with valid params" do
			context "when list_type_type is 'plain list'" do
				let!(:params) {{ list_type_type: 'plain list', list_type: { name: 'Movies' }}}

				it "sets the list type settings" do
					list_type_creator.save
					lt = list_type_creator.list_type
					expect(lt.can_be_root).to be false
					expect(lt.can_have_children).to be false
				end

				it "creates a parent_list_type" do
					list_type_creator.save
					pt = list_type_creator.instance_variable_get('@parent_list_type')
					expect(pt).to_not be nil
				end

				it "sets the parent_list_type's name to the list_type's name" do
					list_type_creator.save
					pt = list_type_creator.instance_variable_get('@parent_list_type')
					expect(pt.name).to eq(list_type_creator.list_type.name)
				end

				it "sets the parent_list_type's properties" do
					list_type_creator.save
					pt = list_type_creator.instance_variable_get('@parent_list_type')
					expect(pt.can_be_root).to be true
					expect(pt.children_list_type_id).to eq(list_type_creator.list_type.id)
				end

				it_behaves_like "a valid list type save"
			end

			context "when list_type_type is 'tree'" do
				let!(:params) {{ list_type_type: 'tree', list_type: { name: 'Movies' }}}
				
				it "does not create a parent list type" do
					list_type_creator.save
					pt = list_type_creator.instance_variable_get('@parent_list_type')
					expect(pt).to be nil
				end

				it "sets the list_types settings" do
					list_type_creator.save
					lt = list_type_creator.list_type
					expect(lt.can_be_root).to be true
					expect(lt.can_have_children).to be true
					expect(lt.children_list_type_id).to eq(lt.id) #WHY?
				end
					
				it_behaves_like "a valid list type save"
			end
		end

		context "with invalid params" do
			context "when params is nil" do
				let!(:params) { nil }
				it_behaves_like "an invalid list type save"
			end

			context "when params are empty" do
				let!(:params) { {} }
				it_behaves_like "an invalid list type save"
			end

			context "when params have bad values" do
				let!(:params) { {bannanas: true} }
				it_behaves_like "an invalid list type save"
			end

			context "when params are incomplete" do
				let!(:params) { { list_type: {} } }
				it_behaves_like "an invalid list type save"
			end

			context "when only the list_type_type is given" do
				let!(:params) { { list_type_type: 'plain list' } }
				it_behaves_like "an invalid list type save"
			end
		end
	end

	describe "#list_type" do
		context "when list_type_type is 'plain list'" do

		end

		context "when list_type_type is 'tree'" do

		end

		context "when there is no list_type_type" do

		end

		context "when list_type_type is something else" do

		end
	end
end
