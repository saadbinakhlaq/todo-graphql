module Types
  class QueryType < Types::BaseObject
    # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField

    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :me, resolver: Queries::Users::Me
    field :user_lists, resolver: Queries::Lists::UserLists
    field :show_list, resolver: Queries::Lists::ListShow
    field :user_tasks, resolver: Queries::Tasks::UserTasks
  end
end
