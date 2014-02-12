class CreateUserAlbums < ActiveRecord::Migration
  def change
    create_table :user_albums do |t|
      t.string :name
      t.belongs_to :user

      t.timestamps

    end
    add_index :user_albums, :user_id
  end
end
