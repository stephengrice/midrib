require 'rails_helper'

describe "get all uesrs route", :type => :request do
  let!(:users) {FactoryBot.create_list(:random_user, 20) }
  before { get '/api/v1/users' }
  it 'returns all users' do
    expect(JSON.parse(response.body).size).to eq(20)
  end
  it 'returns status code 200' do
    expect(response).to have_http_status(:success)
  end
end
