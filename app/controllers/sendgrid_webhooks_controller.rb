class SendgridWebhooksController < ActionController::Base
  def create
    project = Project.where(:sendgrid_email => params[:to]).first

    if project.present?
      tracker_project = Tracker::Project.from_project(project)
      description = params[:html]
      description = params[:text] if description.blank?
      description = ReverseMarkdown.convert(description)

      # story = tracker_project.stories.create(:story_type => 'bug', :name => params[:subject], :description => description )
    end

    render :json => { "message" => "OK" }, :status => :ok
  end
end