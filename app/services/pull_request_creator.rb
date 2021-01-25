require "octokit"

class PullRequestCreator < PullRequestActionBase
  def run
    return if story_id.blank?

    if pull_request
      # disable
      # story.add_label LABEL
      # story.add_note "#{pull_request_markdown} has been opened."
      story.update_status_if_needed
      update_pull_request_description
    end
  end

  def update_pull_request_description
    client = Octokit::Client.new access_token: @project.user.github_token
    existing_pull_request = client.pull_request @project.repo, pull_request.number
    client.update_pull_request @project.repo, pull_request.number, {:body => existing_pull_request[:body] + "\r\nhttps://www.pivotaltracker.com/story/show/#{pull_request.story_id}"}
  end

end