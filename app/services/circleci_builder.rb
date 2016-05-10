class CircleciBuilder

  def initialize(options, project)
    @options = options
    @project = project
  end

  def run
    uri = "https://circleci.com/api/v1/project/#{@project.repo}/tree/#{URI::encode(options[:branch])}?circle-token=#{@project.user.circle_token}"
    cmd = "curl -X POST --header \"Content-Type: application/json\" -d '{}' #{uri}"
    JSON.parse(`#{cmd}`)
  end

end