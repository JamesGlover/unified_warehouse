class SubmittedAsset < ActiveRecord::Base
  set_primary_key :dont_use_id
  alias_attribute :id, :dont_use_id

  named_scope :for_order, lambda { |order| { :conditions => { :order_uuid => order.uuid } } }
  named_scope :for_order_uuid, lambda { |uuid| { :conditions => { :order_uuid => uuid } } }
end
