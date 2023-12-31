require 'rails_helper'

module Mutations
  module Tasks
    RSpec.describe CreateTask, type: :request do
      describe '.resolve' do
        context "when list id is provided in the request" do
          it 'creates a task in list' do
            user = FactoryBot.create(:user)
            list = FactoryBot.create(:list, user_id: user.id)
            headers = sign_in_test_headers user
            query = <<~GQL
            mutation {
              createTask(input: {name: "Test List", listId: "#{list.id}"}) {
                task { 
                  id
                }
              }
            }
            GQL
            expect {
              post '/graphql', params: {query: query}, headers: headers
            }.to change(Task, :count).by(1)
            .and change(List, :count).by(0)
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["data"]["createTask"]["task"]["id"]).not_to be_nil
          end
        end

        context "when list id is not provided in the request" do
          it 'creates a task in list' do
            user = FactoryBot.create(:user)
            headers = sign_in_test_headers user
            query = <<~GQL
            mutation {
              createTask(input: {name: "Test List"}) {
                task { 
                  id
                }
              }
            }
            GQL
            expect {
              post '/graphql', params: {query: query}, headers: headers
            }.to change(Task, :count).by(1)
            .and change(List, :count).by(1)
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["data"]["createTask"]["task"]["id"]).not_to be_nil
          end
        end

        context "when default list already exists for user" do
          it 'creates a task in default list' do
            user = FactoryBot.create(:user)
            list = FactoryBot.create(:list, user_id: user.id, name: "default")
            headers = sign_in_test_headers user
            query = <<~GQL
            mutation {
              createTask(input: {name: "Test List"}) {
                task { 
                  id
                }
              }
            }
            GQL
            expect {
              post '/graphql', params: {query: query}, headers: headers
            }.to change(Task, :count).by(1)
            .and change(List, :count).by(0)
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["data"]["createTask"]["task"]["id"]).not_to be_nil
          end          
        end
      end
    end
  end
end
