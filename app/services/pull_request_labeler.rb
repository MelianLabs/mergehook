require "octokit"

class PullRequestLabeler < PullRequestActionBase
  def run
    require "pp"
    options = {
      :branch => @payload[:pull_request][:head][:ref]
    }

    res = nil
    if ["LGTM", "Needs Review"].include?(@payload[:label][:name])
      res = CircleciBuilder.new(options, @project).run
      puts "@res >>>", @res
    end
        
    res
  end
end