# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

lt = ListType.create(name: 'Normal',
                can_be_root: true,
                featured: true,
                template: "<td>{{name}}</td>"
               )
ListTypeField.create(name: 'name', field_type: 'text', default_data: 'Name here', list_type: lt)
