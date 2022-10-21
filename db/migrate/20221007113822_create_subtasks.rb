class CreateSubtasks < ActiveRecord::Migration[6.1]
  def change
    create_table :subtasks do |t|

      # 親タスクIDを保存するカラム
      t.integer :task_id, null: false
      # 会員IDを保存するカラム
      t.integer :member_id, null: false
      # 表示名を保存するカラム
      t.string :display_name
      # 子タスクの内容を保存するカラム
      t.text :subtask_content, null: false
      # enumで管理　integer型の進捗ステータスカラム
      t.integer :progress_status,null: false, default: 0

      t.timestamps null: false
    end
  end
end
