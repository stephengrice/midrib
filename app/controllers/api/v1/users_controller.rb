module Api
  module V1
    class UsersController < ApplicationController
      def index
        @users = User.all
        render json: @users
      end
      def create
        user_params = params.require(:user).permit(:name, :pubkey, :signature)
        begin
          name = user_params[:name]
          pubkey = user_params[:pubkey]
          signature = user_params[:signature]
          if name.present? and pubkey.present? and signature.present?
            # Verify signature
            public_key = OpenSSL::PKey::RSA.new(pubkey)
            if public_key.verify(OpenSSL::Digest::SHA256.new, Base64.decode64(signature), name)
              @user = User.create name: name, pubkey: pubkey
              render json: {name: @user.name, pubkey: @user.pubkey}, status: :created
            else
              render json: {message: 'Error: invalid signature'}, status: :bad_request
            end
          else
            render json: {message: 'Error: missing required field(s)'}, status: :bad_request
          end
        rescue OpenSSL::PKey::RSAError
          render json: {message: 'Error: invalid pubkey'}, status: :bad_request
        end
      end
    end
  end
end
