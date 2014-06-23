class PullRequestCreator < PullRequestActionBase
  def run
    return if story_id.blank?

    if @pull_request = @project.pull_requests.create(pull_request_params)
      story.add_label LABEL
      story.add_note "#{pull_request_markdown} has been opened."
    end
  end

  def pull_request
    @pull_request
  end

  def pull_request_params
    {
      number: @payload[:number],
      branch: @payload[:pull_request][:head][:ref],
      author: @payload[:pull_request][:head][:user][:login],
      title:  @payload[:pull_request][:title],
      body:   @payload[:pull_request][:body],
      story_id: story_id
    }
  end
end