module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false, description: "User id string"
    field :email, String, null: false, description: "User's email"
    field :lists, [Types::ListType], null: true, description: "User's Lists"
  end
end