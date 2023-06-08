require 'rails_helper'

module Mutations
  module Auth
    RSpec.describe SignUp, type: :request do
      describe '.resolve' do
        context "when the request is invalid" do
          it 'responds with an error' do
            params = FactoryBot.attributes_for(:user)
            query = <<~GQL
            mutation {
              signUp(input: {email: "", password: "#{params[:password]}"}) {
                token
                user {
                  id
                  email
                }
              }
            }
            GQL
            post '/graphql', params: {query: query}
  
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["errors"][0]["message"]).to include("Email can't be blank")
          end

          it 'responds with an error' do
            params = FactoryBot.attributes_for(:user)
            query = <<~GQL
            mutation {
              signUp(input: {email: "email@gmail.com", password: ""}) {
                token
                user {
                  id
                  email
                }
              }
            }
            GQL
            post '/graphql', params: {query: query}
  
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["errors"][0]["message"]).to include("Password can't be blank")
          end
        end

        context "when the request is valid" do
          it 'create a user and signs in the user' do
            params = FactoryBot.attributes_for(:user)
            query = <<~GQL
            mutation {
              signUp(input: {email: "#{params[:email]}", password: "#{params[:password]}"}) {
                token
                user {
                  id
                  email
                }
              }
            }
            GQL
            post '/graphql', params: {query: query}
  
            expect(response).to have_http_status(200)
            json = JSON.parse(response.body)
            expect(json["data"]["signUp"]["token"]).not_to be_nil
          end
        end
      end
    end
  end
end
