class CreateTaskMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :task_members do |t|

      # 親タスクIDを保存するカラム
      t.integer :task_id, null: false
      # 会員IDを保存するカラム
      t.integer :member_id, null: false

      t.timestamps null: false
    end
  end
end
