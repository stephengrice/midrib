class AddFieldsToPost < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :message, :string
    add_column :posts, :signature, :string
  end
end
