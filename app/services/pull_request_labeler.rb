require "octokit"

class PullRequestLabeler < PullRequestActionBase
  def run
    pp "PullRequestLabeler", @options, @project
  end
end