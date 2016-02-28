class SendgridWebhooksController < ActionController::Base
  def create
    email_regex = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i
    project     = Project.where(:sendgrid_email => params[:to]).first

    if project.present?
      tracker_project = Tracker::Project.from_project(project)
      description = params[:html]
      description = params[:text] if description.blank?
      description = ReverseMarkdown.convert(description)

      
      requester_email = (params[:from] || "").scan(email_regex).to_a.first || "emanuel@mytime.com"
      requester = tracker_project.project.memberships.all.find{|e| e.email == requester_email}

      new_story_attrs = {
        :story_type   => 'bug', 
        :name         => params[:subject], 
        :description  => description,
        :estimate     => 0,
        :requested_by => requester.try(:name),
        :labels       => ["email-hook"],
      }
      if params[:cc].present?
        owner_email = params[:cc].scan(email_regex).to_a.first
        owner = tracker_project.project.memberships.all.find{|e| e.email == owner_email}

        new_story_attrs[:owned_by] = owner.try(:name)
      end
      
      story = tracker_project.project.stories.create(new_story_attrs)
    end

    render :json => { "message" => "OK" }, :status => :ok
  end
end