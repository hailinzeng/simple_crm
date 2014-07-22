class CreateCommunications < ActiveRecord::Migration
  def change
    create_table :communications do |t|
      t.integer :customer_id     # 客户ID
      t.string  :name            # 姓名
      t.integer :channel         # 渠道
      t.string  :comment         # 备注

      t.references :user
      t.references :customer

      t.timestamps
    end
  end
end
