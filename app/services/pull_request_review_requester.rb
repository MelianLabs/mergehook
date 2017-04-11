require "octokit"

class PullRequestReviewRequester < PullRequestActionBase
  def run
    require "pp"
    options = {
      :branch => @payload[:pull_request][:head][:ref],
      :sha    => @payload[:pull_request][:head][:sha],
      :status => "success"
    }

    res = CircleciBuilder.new(options, @project).run
    puts "@res >>>", @res

    res
  end
end