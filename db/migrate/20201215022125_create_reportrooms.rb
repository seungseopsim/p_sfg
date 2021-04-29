class CreateReportrooms < ActiveRecord::Migration[6.0]
  def change
    create_table :reportrooms do |t|
      t.string :roomtype,  null: false
	  t.string :userid,  null: false    
      t.text :contents
      t.text :plancontents
      t.string :bb_shoplist
      t.timestamps
    end
  end
end
