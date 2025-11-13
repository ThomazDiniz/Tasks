module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_user!, only: [:login, :register]
      
      def register
        user = User.new(user_params)
        
        if user.save
          token = encode_token({ user_id: user.id })
          render json: { token: token, user: { id: user.id, email: user.email } }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      def login
        user = User.find_by(email: params[:email])
        
        if user&.authenticate(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { token: token, user: { id: user.id, email: user.email } }
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end
      
      private
      
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
  end
end

