class Role < ActiveHash::Base
  include ActiveHash::Enum
  self.data = [
    { id: 1, name: 'Owner'    },
    { id: 2, name: 'Invitee' }
  ]
  enum_accessor :name
end
