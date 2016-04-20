class GithubWebhooksController < ActionController::Base
  include GithubWebhook::Processor

  def push(payload)
    client = Octokit::Client.new access_token: @project.user.github_token
    branch = payload[:ref].split("/").last
    client.create_status project.repo, payload[:head], "success", {:target_url => "https://mymergehook.herokuapp.com/projects/#{@project.id}/trigger_build/#{branch}", :context => "Trigger Build"}
    # commit = Commit.new(payload)
    # if commit.merge_to_master?
    #   story = tracker_project.story(commit.story_id)
    #   story.finish
    #   story.remove_label "pull-request"
    # end
  end

  def pull_request(payload)
    case payload[:action]
    when "opened"
      PullRequestCreator.new(payload, @project).run
    when "closed"
      PullRequestCloser.new(payload, @project).run
    when "synchronize"
      PullRequestUpdater.new(payload, @project).run
    when "reopened"
      PullRequestReopener.new(payload, @project).run
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