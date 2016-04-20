class AddCircleCiTokenOnUser < ActiveRecord::Migration
  def change
    add_column :users, :circle_token, :string
  end
end
