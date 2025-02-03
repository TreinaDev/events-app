class RenameTokenToCodeInSpeakers < ActiveRecord::Migration[8.0]
  def change
    rename_column :speakers, :token, :code
    rename_index :speakers, 'index_speakers_on_token', 'index_speakers_on_code'
  end
end
