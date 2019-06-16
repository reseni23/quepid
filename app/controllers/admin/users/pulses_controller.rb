# frozen_string_literal: true

module Admin
  module Users
    class PulsesController < Admin::AdminController
      before_action :set_user
      before_action :set_data
      respond_to :json

      def show
        render json: @data
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def set_data
        if 'metadata' == params[:data]
          @data = Metadatum.where(user_id: @user.id)
            .where('last_viewed_at >= :start AND last_viewed_at <= :end',
                   start: params[:start],
                   end:   params[:end])
            .group(:last_viewed_at)
            .count
        elsif 'scores' == params[:data]
          @data = Score.where(user_id: @user.id)
            .where('created_at >= :start AND created_at <= :end',
                   start: params[:start],
                   end:   params[:end])
            .group(:created_at)
            .count
        elsif 'cases-created' == params[:data]
          @data = Case.where(user_id: @user.id)
            .where('created_at >= :start AND created_at <= :end',
                   start: params[:start],
                   end:   params[:end])
            .group(:created_at)
            .count
        elsif 'teams-created' == params[:data]
          @data = Team.where(owner_id: @user.id)
            .where('created_at >= :start AND created_at <= :end',
                   start: params[:start],
                   end:   params[:end])
            .group(:created_at)
            .count
        elsif 'queries-created' == params[:data]
          @data = Query.joins(:case)
            .where(cases: { user_id: @user.id })
            .where('`queries`.`created_at` >= :start AND `queries`.`created_at` <= :end',
                   start: params[:start],
                   end:   params[:end])
            .group('`queries`.`created_at`')
            .count
        end

        @data = @data.map do |k, v|
          [ k.to_i, v ]
        end.to_h
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength
    end
  end
end
