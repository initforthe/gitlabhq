class AddHipchatRoomIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :hipchat_room_id, :string
  end
end
