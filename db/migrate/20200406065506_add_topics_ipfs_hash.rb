class AddTopicsIpfsHash < ActiveRecord::Migration[6.0]
  def change
    add_column :topics, :ipfs_hash, :string
  end
end
