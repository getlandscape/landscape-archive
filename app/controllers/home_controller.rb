# frozen_string_literal: true

class HomeController < ApplicationController
  include Topics::ListActions
  def index
    @excellent_topics = Topic.excellent.recent.fields_for_list.limit(20).to_a

    @suggest_topics = []
    if params[:page].to_i <= 1
      @suggest_topics = topics_scope.suggest.limit(3)
    end
    @topics = topics_scope.without_suggest.without_team.last_actived.page(params[:page]).per(8)
    @read_topic_ids = []
  end

  def uploads
    return render_404 if Rails.env.production?

    # This is a temporary solution for help generate image thumb
    # that when you use :file upload_provider and you have no Nginx image_filter configurations.
    # DO NOT use this in production environment.
    format, version = params[:format].split("!")
    filename = [params[:path], format].join(".")
    pragma = request.headers["Pragma"] == "no-cache"
    thumb = Homeland::ImageThumb.new(filename, version, pragma: pragma)
    if thumb.exists?
      send_file thumb.outpath, type: "image/jpeg", disposition: "inline"
    else
      render plain: "File not found", status: 404
    end
  end

  def error_404
    render_404
  end

  def markdown
  end

  def status
    render plain: "OK #{Time.now.iso8601}"
  end
end
