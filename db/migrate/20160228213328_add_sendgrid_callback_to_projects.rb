class AddSendgridCallbackToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :sendgrid_email, :string
  end
end
