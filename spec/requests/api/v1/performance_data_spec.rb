RSpec.describe Api::V1::PerformanceDataController, type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:credentials) { user.create_new_auth_token }
  let(:headers) { { HTTP_ACCEPT: 'application/json' }.merge!(credentials) }
  let(:not_headers) { {HTTP_ACCEPT: 'application/json'} }

  describe 'POST /api/v1/performance_data' do
    it 'creates a data entry' do
      post '/api/v1/performance_data', params: {
        performance_data: { data: { message: 'Average' } }
      }, headers: headers

      entry = PerformanceData.last
      expect(entry.data).to eq 'message' => 'Average'
    end
  end

  describe 'GET /api/v1/performance_data' do
    before do
      5.times { user.performance_data.create(data: { message: 'Average' }) }
    end

    it 'returns the collection of performance data' do
      get '/api/v1/performance_data', headers: headers
      binding.pry
      expect(response_json['entries'].count).to eq 5
    end

    it 'does not return a collection of performance data if user is not logged in' do
      get '/api/v1/performance_data', headers: not_headers
      expect(response_json['errors']).to eq ["You need to sign in or sign up before continuing."]
    end

    it 'returns a collection of performance data that belongs to the logged in user' do
      get '/api/v1/performance_data', headers: headers
      expect((response_json['entries']).first['user_id']).to eq user['id']
    end

  end

end