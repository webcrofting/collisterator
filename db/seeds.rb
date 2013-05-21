# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

@r =Role.new
@r.name = "admin"
@r.save

@r = Role.new
@r.name = "payers"
@r.save

@r = Role.new
@r.name = "players"
@r.save

@r = Role.new
@r.name = "guest"
@r.save
