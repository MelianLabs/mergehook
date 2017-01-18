class CircleciBuilder

  def initialize(options, project)
    @options = options
    @project = project
  end

  def run
    StatusCreator.new(@options, @project).run

    uri = "https://circleci.com/api/v1/project/#{@project.repo}/tree/#{URI::encode(@options[:branch])}?circle-token=#{@project.user.circle_token}"
    cmd = "curl -X POST --header \"Content-Type: application/json\" -d '{}' #{uri}"

    puts "cmd >>>", cmd

    JSON.parse(`#{cmd}`)
  end

end