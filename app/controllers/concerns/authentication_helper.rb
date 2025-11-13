module AuthenticationHelper
  def encode_token(payload)
    JWT.encode(payload, secret_key)
  end
  
  def decode_token(token)
    JWT.decode(token, secret_key)[0]
  end
  
  private
  
  def secret_key
    Rails.application.credentials.secret_key_base || Rails.application.secret_key_base || 'your-secret-key-change-in-production'
  end
end

