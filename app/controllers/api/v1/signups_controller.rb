# frozen_string_literal: true

module Api
  module V1
    class SignupsController < Api::ApiController
      skip_before_action :authenticate_api!
      skip_before_action :verify_authenticity_token

      def create
        @user = User.new user_params
        @user.agreed_time = Time.zone.now

        if @user.save
          Analytics::Tracker.track_signup_event @user
          respond_with @user
        else
          render json: @user.errors, status: :bad_request
        end
      end

      private

      def user_params
        params.require(:user).permit(
          :name,
          :username,
          :password,
          :agreed
        )
      end
    end
  end
end
