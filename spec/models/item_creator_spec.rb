require 'rails_helper'

describe ItemCreator do
	let!(:params) { { item: { } } }
	let!(:user) { create(:user) }
		
	describe "#new" do

		it "creates a new instance of ItemCreator" do
			expect(ItemCreator.new(params, user)).to be_an_instance_of(ItemCreator)
		end

		it "assigns :user" do
			item_creator = ItemCreator.new(params, user)
			expect(item_creator.instance_variable_get('@user')).to eq(user)
		end

		it "assigns :item" do
			item_creator = ItemCreator.new(params, user)
			expect(item_creator.instance_variable_get('@item')).to be_an_instance_of Item
		end

		it "assigns :params" do
			item_creator = ItemCreator.new(params, user)
			expect(item_creator.instance_variable_get('@params')).to eq(params)
		end
	end

	describe "#result" do
		
		context "for an item with a parent list_type" do
			let!(:parent) { create(:item, list_type_id: create(:list_type).id ) }
			let!(:params_with_parent) { { item: { parent_id: parent.token } } } 

			it "assigns the parent_id" do
		  	item = ItemCreator.new(params_with_parent, user).result
				expect(item.parent_id).to eq(parent.id)
			end

			it "assigns the parent's list_type id" do
				item = ItemCreator.new(params_with_parent, user).result
				expect(item.list_type_id).to eq(parent.list_type_id)
			end

			it "sets the data to the parent list type's default data" do
				item = ItemCreator.new(params_with_parent, user).result
				expect(item.data).to eq(JSON.parse(ListType.find(parent.list_type_id).default_data)) #???
			end
		end
	end

end
