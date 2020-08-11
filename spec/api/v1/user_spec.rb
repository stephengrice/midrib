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
describe "POST /api/v1/users" do
  describe "valid signature" do
    before do
      rsa_key = OpenSSL::PKey::RSA.new(2048)
      private_key_pem = rsa_key.to_pem
      public_key_pem = rsa_key.public_key.to_pem
      name = 'test name!'
      post '/api/v1/users', params: { :name => name, pubkey: public_key_pem, signature: private_key.sign(OpenSSL::Digest::SHA256.new, name)}
    end
    it 'returns the fields passed to it' do
      expect(JSON.parse(response.body)['name']).to eq('test name')
      expect(JSON.parse(response.body)['pubkey']).to eq('test pubkey')
      expect(JSON.parse(response.body)['signature']).to eq('test signature')
    end
    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end
  end
  describe "invalid signature" do
    before do
      post '/api/v1/users', params: { :name => 'test name', pubkey: 'test pubkey', signature: 'test signature'}
    end
    it 'returns an error message' do
      expect(JSON.parse(response.body)['message']).to eq('Error: signature verification failed.')
    end
    it 'returns an invalid status' do
      expect(response).to have_http_status(:invalid)
    end
  end
end
