class CreateAttachfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :attachfiles do |t|
      t.bigint :reportid,  null: false
      t.string :path
      t.string :filename
		
      t.timestamps
    end
  end
end
