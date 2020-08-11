module Api
  module V1
    class PostsController < ApplicationController
      def index
        render json: {message: 'hello'}
      end
    end
  end
end
