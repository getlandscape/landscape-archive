# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, except: %i[index city]

  etag { @user }
  etag { @user&.teams if @user&.user_type == :user }

  include Users::TeamActions
  include Users::UserActions

  def index
    @total_user_count = User.count
    @active_users = User.without_team.fields_for_list.hot.limit(100)
  end

  def city
    location = Location.location_find_by_name(params[:id])
    return render_404 if location.nil?
    @users = User.where(location_id: location.id).without_team.fields_for_list
    @users = @users.order(replies_count: :desc).page(params[:page]).per(60)

    render_404 if @users.count == 0
  end

  def show
    @user_type == :team ? team_show : user_show
  end

  def new_request
    @team = Team.find_by_login!(params[:id])
    @team_user = TeamUser.new(user: current_user, team: @team, role: :member, status: :request)
    @team_user.actor_id = current_user.id
    @team_user.save(context: :request)
    p @team_user
    redirect_to user_path(params[:id])
  end

  protected

    def set_user
      @user = User.find_by_login!(params[:id])

      # 转向正确的拼写
      if @user.login != params[:id]
        redirect_to user_path(@user.login), status: 301
        return
      end

      render_404 if @user.deleted?

      @user_type = @user.user_type
    end

    # Override render method to render difference view path
    def render(*args)
      options = args.extract_options!
      if @user_type
        options[:template] ||= "/#{@user_type.to_s.tableize}/#{params[:action]}"
      end
      super(*(args << options))
    end
end
