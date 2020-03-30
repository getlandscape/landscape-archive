class AddEthereumAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :ethereum_address, :string
  end
end
