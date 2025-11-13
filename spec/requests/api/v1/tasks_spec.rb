require 'rails_helper'

RSpec.describe 'Tasks API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers_for(user) }
  
  describe 'GET /api/v1/tasks' do
    let!(:task1) { create(:task, user: user) }
    let!(:task2) { create(:task, user: user) }
    let!(:other_user_task) { create(:task) }
    
    it 'returns all tasks for the authenticated user' do
      get '/api/v1/tasks', headers: headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq(2)
      expect(json_response.map { |t| t['id'] }).to contain_exactly(task1.id, task2.id)
    end
    
    it 'returns unauthorized without token' do
      get '/api/v1/tasks'
      
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  describe 'GET /api/v1/tasks/:id' do
    let(:task) { create(:task, user: user) }
    
    it 'returns the task' do
      get "/api/v1/tasks/#{task.id}", headers: headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['id']).to eq(task.id)
      expect(json_response['title']).to eq(task.title)
    end
    
    it 'returns 404 for non-existent task' do
      get '/api/v1/tasks/99999', headers: headers
      
      expect(response).to have_http_status(:not_found)
    end
    
    it 'returns 404 for task belonging to another user' do
      other_task = create(:task)
      get "/api/v1/tasks/#{other_task.id}", headers: headers
      
      expect(response).to have_http_status(:not_found)
    end
  end
  
  describe 'POST /api/v1/tasks' do
    let(:valid_params) do
      {
        task: {
          title: 'New Task',
          description: 'Task description',
          status: 'pending',
          due_date: (Date.current + 1.day).to_s
        }
      }
    end
    
    it 'creates a new task' do
      expect {
        post '/api/v1/tasks', params: valid_params, headers: headers
      }.to change(Task, :count).by(1)
      
      expect(response).to have_http_status(:created)
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq('New Task')
      expect(json_response['user_id']).to eq(user.id)
    end
    
    it 'returns 422 for invalid params' do
      invalid_params = { task: { title: '', status: 'pending' } }
      
      post '/api/v1/tasks', params: invalid_params, headers: headers
      
      expect(response).to have_http_status(:unprocessable_entity)
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to be_present
    end
    
    it 'returns 422 when due_date is in the past' do
      invalid_params = {
        task: {
          title: 'Task',
          status: 'pending',
          due_date: Date.yesterday.to_s
        }
      }
      
      post '/api/v1/tasks', params: invalid_params, headers: headers
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'PUT /api/v1/tasks/:id' do
    let(:task) { create(:task, user: user, title: 'Original Title') }
    
    it 'updates the task' do
      put "/api/v1/tasks/#{task.id}", params: { task: { title: 'Updated Title' } }, headers: headers
      
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['title']).to eq('Updated Title')
      expect(task.reload.title).to eq('Updated Title')
    end
    
    it 'returns 422 for invalid params' do
      put "/api/v1/tasks/#{task.id}", params: { task: { title: '' } }, headers: headers
      
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
  
  describe 'DELETE /api/v1/tasks/:id' do
    let!(:task) { create(:task, user: user) }
    
    it 'deletes the task' do
      expect {
        delete "/api/v1/tasks/#{task.id}", headers: headers
      }.to change(Task, :count).by(-1)
      
      expect(response).to have_http_status(:no_content)
    end
  end
end

