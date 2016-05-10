require "octokit"

class PullRequestLabeler < PullRequestActionBase
  def run
    require "pp"
    options = {:branch => @payload[:pull_request][:head][:ref]}
    pp "PullRequestLabeler", options, @project
  end
end