require "octokit"

class PullRequestLabeler < PullRequestActionBase
  def run
    # disable
    return 

    require "pp"
    options = {
      :branch => @payload[:pull_request][:head][:ref],
      :sha    => @payload[:pull_request][:head][:sha],
      :status => "success"
    }

    res = nil
    if ["LGTM", "Needs Review"].include?(@payload[:label][:name])
      res = CircleciBuilder.new(options, @project).run
      puts "@res >>>", @res
    end

    res
  end
end