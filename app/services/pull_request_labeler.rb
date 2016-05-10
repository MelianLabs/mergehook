require "octokit"

class PullRequestLabeler < PullRequestActionBase
  def run
    require "pp"
    pp "PullRequestLabeler", @options, @project
  end
end