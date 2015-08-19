class AddReagentKitBarcode < ActiveRecord::Migration
  def change
    change_table :iseq_flowcell do |t|
      t.string   'reagent_kit_barcode',    limit: 30,  comment: 'The barcode for the reagent kit or cartridge', :after => :flowcell_barcode
    end
  end
end
