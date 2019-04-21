require "set"
# require "pivotal-tracker"

module Tracker
  class Account
    def initialize(token)
      @client = TrackerApi::Client.new(token: token)
    end

    def projects
      @client.projects
    end
  end

  class Project
    attr_reader :project

    def initialize(token, project_id)
      @client = TrackerApi::Client.new(token: token)
      @project = @client.project(project_id)
    end

    def story(story_id)
      Story.new(@project, story_id)
    end

    def self.from_project(project)
      Tracker::Project.new(project.user.pivotal_tracker_api_token, project.tracker_project_id.to_i)
    end
  end

  class Story
    def initialize(project, story_id)
      @story = project.story(story_id.to_i)
    end

    def add_label(label)
      label = TrackerApi::Resources::Label.new(name: label)

      # GOOD
      @story.labels = @story.labels.dup.push(label)
      @story.save
    end
  end
end
