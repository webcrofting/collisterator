require 'rails_helper'
describe "List Type" do
  it "produces a valid factory" do
    expect(build(:list_type)).to be_valid	
  end

  it "is not valid without a name" do
    expect(build(:list_type, name: nil)).to_not be_valid
  end
end
