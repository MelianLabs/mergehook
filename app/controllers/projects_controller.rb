class ProjectsController < ApplicationController
  before_action :ensure_current_user_pivotal_tracker_api_token, only: :index
  before_action :set_project, only: [:destroy, :trigger_build]
  before_action :set_tracker_projects, only: [:index, :new, :create]
  skip_before_action :authenticate_user!, only: [:trigger_build]

  def index
    @projects = current_user.projects
  end

  def new
    @project = current_user.projects.build
  end

  def create
    @project = ProjectCreator.new(project_params).run(current_user)
    if @project.persisted?
      redirect_to projects_path
    else
      render :new
    end
  end

  def destroy
    GithubUnsubscriber.new(@project).run(current_user)
    @project.destroy
    redirect_to projects_path
  end

  def trigger_build
    options = {
      :branch => params[:branch],
      :sha    => params[:sha],
      :status => "success"
    }
    StatusCreator.new(options, @project)

    uri = "https://circleci.com/api/v1/project/#{@project.repo}/tree/#{params[:branch]}?circle-token=#{@project.user.circle_token}"
    @res = JSON.parse(`curl -X POST --header "Content-Type: application/json" -d '{}' #{uri}`)
  end

  private

  def set_project
    @project = if current_user.present?
      current_user.projects.find(params[:id])
    else
      Project.find(params[:id])
    end
  end

  def set_tracker_projects
    return unless current_user.pivotal_tracker_api_token
    account = Tracker::Account.new(current_user.pivotal_tracker_api_token)
    @tracker_projects = account.projects.map { |p| [ p.name, p.id ] }
  end

  def project_params
    params.require(:project).permit(:repo, :tracker_project_id)
  end

  def ensure_current_user_pivotal_tracker_api_token
    if current_user.pivotal_tracker_api_token.blank?
      redirect_to edit_user_path(current_user), alert: "Please set up your Pivotal Tracker API token first."
      false
    end
  end
end
