require 'rails_helper'

module Mutations
  module Lists
    RSpec.describe CreateList, type: :request do
      describe '.resolve' do
        context "when the user is not authenticated" do
          it "responds with an error" do
            user = FactoryBot.create(:user)
            query = <<~GQL
            mutation {
              createList(input: {name: "Test List"}) {
                list { 
                  id
                }
              }
            }
            GQL
            post '/graphql', params: {query: query}, headers: headers


            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["errors"][0]["message"]).to include("You must be logged in to perform this action")
          end
        end

        context "when the user is authenticated" do
          context "when valid params are given" do
            it 'creates a users list' do
              user = FactoryBot.create(:user)
              headers = sign_in_test_headers user
              query = <<~GQL
              mutation {
                createList(input: {name: "Test List"}) {
                  list { 
                    id
                  }
                }
              }
              GQL
              post '/graphql', params: {query: query}, headers: headers

              expect(response).to have_http_status(200)
              json = JSON.parse(response.body)
              expect(json["data"]["createList"]["list"]["id"]).not_to be_nil
            end            
          end

          context "when valid params are not given" do
            it 'creates a users list' do
              user = FactoryBot.create(:user)
              headers = sign_in_test_headers user
              query = <<~GQL
              mutation {
                createList(input: {name: ""}) {
                  list { 
                    id
                  }
                }
              }
              GQL
              post '/graphql', params: {query: query}, headers: headers

              expect(response).to have_http_status(200)
              json = JSON.parse(response.body)
              expect(json["errors"][0]["message"]).to include("Name can't be blank")
            end
          end
        end
      end
    end
  end
end
