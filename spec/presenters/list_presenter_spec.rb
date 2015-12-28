require 'rails_helper'

describe ListPresenter do
  let!(:list_type) do
    create(:list_type, template: "<foo>{{name}}</foo>").tap do |lt|
      create(:list_type_field, list_type: lt, name: "name", default_data: "Bogus", field_type: "text")
    end
  end

  describe "#items" do
    let(:json)       { { name: 'bar' }.to_json                             }
    let!(:item)      { create(:item, list_type: list_type, data: json)     }
    let(:presenter)  { ListPresenter.new(item)                             }

    context "when the root item has 1 child" do
      let!(:item) do
        create(:item, list_type: list_type).tap do |i|
          create(:item, list_type: list_type, parent: i)
        end
      end

      let(:presenter) { ListPresenter.new(item) }

      it { expect(presenter.items.size).to eq(2) }
    end

    it "uses the list type template to render the items" do
      expect(presenter.items[0][:template]).to eq("<foo>bar</foo>")
    end

    context "when the item data is nil" do
      before { item.data = nil }

      it "uses the default data from the list type" do
        expect(presenter.items[0][:template]).to eq("<foo>Bogus</foo>")
      end
    end
  end
end
