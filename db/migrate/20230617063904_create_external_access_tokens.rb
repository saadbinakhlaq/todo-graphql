class CreateExternalAccessTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :external_access_tokens do |t|
      t.string :provider
      t.references :user, null: false, foreign_key: true
      t.string :access_token
      t.timestamps
    end
  end
end
