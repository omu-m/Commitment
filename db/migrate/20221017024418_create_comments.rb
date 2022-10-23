class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|

      # 子タスクIDを保存するカラム
      t.integer :subtask_id, null: false
      # 会員IDを保存するカラム
      t.integer :member_id, null: false
      # コメントを保存するカラム
      t.text :comment, null: false
      # 親(コメント)IDを保存するカラム
      t.integer :parent_id

      t.timestamps null: false
    end

    # 自身のIDを外部キーとするカラム
    add_index :comments, :parent_id

  end
end
