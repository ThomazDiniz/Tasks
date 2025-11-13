module AuthenticationTestHelper
  def secret_key
    Rails.application.credentials.secret_key_base || Rails.application.secret_key_base || 'your-secret-key-change-in-production'
  end
  
  def auth_token_for(user)
    JWT.encode({ user_id: user.id }, secret_key)
  end
  
  def auth_headers_for(user)
    { 'Authorization' => "Bearer #{auth_token_for(user)}" }
  end
end

RSpec.configure do |config|
  config.include AuthenticationTestHelper
end

