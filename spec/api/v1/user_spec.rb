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
  before do
    rsa_key = OpenSSL::PKey::RSA.new(2048)
    @private_key_pem = rsa_key.to_pem
    @public_key_pem = rsa_key.public_key.to_pem
    @private_key = OpenSSL::PKey::RSA.new(@private_key_pem)
    @public_key = OpenSSL::PKey::RSA.new(@public_key_pem)
    @name = 'test name!'
    @signature = @private_key.sign(OpenSSL::Digest::SHA256.new, @name)
  end
  describe "valid signature" do
    before do
      post '/api/v1/users', params: { user: { :name => @name, pubkey: @public_key_pem, signature: Base64.encode64(@signature)}}
    end
    it 'returns the fields passed to it' do
      expect(JSON.parse(response.body)['name']).to eq(@name)
      expect(JSON.parse(response.body)['pubkey']).to eq(@public_key_pem)
    end
    it 'returns a created status' do
      expect(response).to have_http_status(:created)
    end
    # it 'returns valid signature' do
    #   signature = JSON.parse(response.body)['signature']
    #   name = JSON.parse(response.body)['name']
    #   expect(@public_key.verify(OpenSSL::Digest::SHA256.new, signature, name)).to be true
    # end
  end
  describe "invalid signature" do
    before do
      post '/api/v1/users', params: { user: {:name => 'test name', pubkey: @public_key_pem, signature: 'fake signature'}}
    end
    it 'returns an error message' do
      expect(JSON.parse(response.body)['message']).to eq('Error: invalid signature')
    end
    it 'returns an invalid status' do
      expect(response).to have_http_status(:bad_request)
    end
  end
  describe "invalid pubkey" do
    before do
      post '/api/v1/users', params: { user: { :name => 'test name', pubkey: 'not a pubkey', signature: 'fake signature'}}
    end
    it 'returns an error message' do
      expect(JSON.parse(response.body)['message']).to eq('Error: invalid pubkey')
    end
    it 'returns an invalid status' do
      expect(response).to have_http_status(:bad_request)
    end
  end
  describe "missing required field" do
    before do
      post '/api/v1/users', params: { user: { :name => 'test name', pubkey: 'not a pubkey'}}
    end
    it 'returns an error message' do
      expect(JSON.parse(response.body)['message']).to eq('Error: missing required field(s)')
    end
    it 'returns an invalid status' do
      expect(response).to have_http_status(:bad_request)
    end
  end
end
