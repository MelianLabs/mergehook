require "octokit"

class StatusCreator < PushActionBase
  def run
    require 'open-uri'

    client = Octokit::Client.new access_token: @project.user.github_token
    client.create_status @project.repo, @options[:sha], @options[:status], {
        :target_url  => "https://mymergehook.herokuapp.com/projects/#{@project.id}/trigger_build/#{URI::encode(@options[:branch])}?sha=#{@options[:sha]}", 
        :context     => "Run Tests",
        :description => "Click 'Details' link on the right to start running tests on CircleCI"
    }
  end
end