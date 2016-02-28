class SendgridWebhooksController < ActionController::Base
  def create
    params[:to]
    params[:from]
    params[:cc]

    pp params

    render :json => { "message" => "OK" }, :status => :ok
  end
end