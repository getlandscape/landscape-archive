# frozen_string_literal: true

module Users
  module TeamActions
    extend ActiveSupport::Concern

    included do
      before_action :set_team, only: [:show]
    end

    private

      def team_show
        # @topics = Topic.where(user_id: @team.user_ids, team_id: [nil, @team.id])
        if current_user && !@team.is_member?(current_user.id)
          @can_request = true

          if TeamUser.find_by(user: current_user, status: :request)
            @have_request = true
          end
        end
        if current_user.blank? || !@team.is_member?(current_user.id)
          @noshow = true
          @topics = Topic.none.page(params[:page])
        else
          @noshow = false
          @topics = Topic.where(team_id: @team.id)
            .fields_for_list
            .last_actived.includes(:user)
          @topics = @topics.page(params[:page])
        end
      end

      def only_team!
        render_404 if @user_type != :team
      end

      def set_team
        @team = @user
      end
  end
end
