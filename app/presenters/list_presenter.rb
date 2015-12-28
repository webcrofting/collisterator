class ListPresenter
  attr_reader :item, :list_type

  def initialize(item)
    @item = item
    @list_type = item.list_type
  end

  def items
    list_items.map do |i|
      { token: i.token, template: fill_template(i) }
    end
  end

  private

  def fill_template(item)
    item_data = data_for(item)
    list_type.template.gsub(/({{)\w+(}})/).each do |t|
      key = t[2..-3] # removes leading & trailing brackets
      item_data[key]
    end
  end

  def data_for(item)
    item.data.nil? ? list_type_fields : JSON.parse(item.data)
  end

  def list_type_fields
    Hash[
      list_type
        .list_type_fields
        .map { |f| [f.name, f.default_data] }
    ]
  end

  def list_items
    [item, item.children].flatten
  end
end
