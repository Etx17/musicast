class CreateJoinTableRoomsTours < ActiveRecord::Migration[8.0]
  def change
    create_join_table :rooms, :tours do |t|
      t.index [:room_id, :tour_id]
      t.index [:tour_id, :room_id]
    end
  end
end
