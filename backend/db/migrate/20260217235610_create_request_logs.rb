class CreateRequestLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :request_logs do |t|
      t.text :original_prompt
      t.text :sanitized_prompt
      t.text :llm_response
      t.string :provider
      t.integer :prompt_tokens
      t.integer :completion_tokens
      t.decimal :total_cost
      t.float :latency

      t.timestamps
    end
  end
end
