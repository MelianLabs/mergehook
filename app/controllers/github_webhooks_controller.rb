class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def github_create(payload)
    p 'github_create'
    p payload

    case payload[:action]
    when "opened"
      PullRequestCreator.new(payload, @project).run
    when "closed"
      PullRequestCloser.new(payload, @project).run
    end
  end

  def webhook_secret(payload)
    repo = pull_request_payload_repo(payload)
    @project = Project.find_by_repo(repo)
    raise ActiveRecord::RecordNotFound.new("No project named #{repo} found") unless @project
    @project.github_webhook_secret
  end

  private

  def pull_request_payload_repo(payload)
    (payload[:repository][:full_name] rescue payload[:pull_request][:base][:repo][:full_name]).downcase
  end

end
