class EventObserver < ActiveRecord::Observer
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers

  observe :event

  def after_save(event)
  end

  def after_create(event)
    project = event.project
    if project.try(:hipchat_room_id).present?
      hipchat = HipChat::API.new(Gitlab.config.notifications.hipchat_api_key)
      if event.push_with_commits?
        event.commits.each do |commit|
          commit = CommitDecorator.decorate(commit)
          url = project_commit_url(project, commit, host: Gitlab.config.web.host)
          message = %{#{project.name}: <a href="#{url}">#{commit.short_id(8)}</a>: #{commit.author_name}: #{truncate(commit.title, length: 50)}}
          log_info hipchat.rooms_message(event.project.hipchat_room_id, 'Gitlab', message, 1, 'yellow').inspect
        end
      end
    end
  rescue Exception => e
    log_info e.message
    log_info e.backtrace.join('\n')
  end

  protected

  def log_info message
    Gitlab::AppLogger.info message
  end
end
