class BmapFlowcell < ActiveRecord::Base
  include ResourceTools
  include NestedResourceTools

  has_associated(:sample)
  has_associated(:study)

  def self.base_resource_key
    'id_flowcell_lims'
  end

  json do
  end
end
