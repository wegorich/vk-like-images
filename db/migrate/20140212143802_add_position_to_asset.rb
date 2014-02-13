class AddPositionToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :position, :integer
  end
end
