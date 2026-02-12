class CreateComments < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
    # Should only 1 vote per user on post
    add_index :votes, [ :post_id, :user_id ], unique: true
  end
end
