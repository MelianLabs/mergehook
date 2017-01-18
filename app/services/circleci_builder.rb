class CircleciBuilder

  def initialize(options, project)
    @options = options
    @project = project
  end

  def run
    # https://circleci.com/docs/parameterized-builds/#detail
    # https://circleci.com/docs/api/#new-build
    StatusCreator.new(@options, @project).run

    uri = "https://circleci.com/api/v1.1/project/#{@project.repo}/tree/#{URI::encode(@options[:branch])}?circle-token=#{@project.user.circle_token}"
    cmd = "curl -X POST --header \"Content-Type: application/json\" -d '{}' #{uri}"

    puts "cmd >>>", cmd

    res = `#{cmd}`

    JSON.parse(res) rescue res
  end

end