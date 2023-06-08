module Types
  class MutationType < Types::BaseObject
    # Auth
    field :sign_up, mutation: Mutations::Auth::SignUp
    field :sign_in, mutation: Mutations::Auth::SignIn

    # List
    field :create_list, mutation: Mutations::Lists::CreateList
    field :delete_list, mutation: Mutations::Lists::DeleteList
  end
end
