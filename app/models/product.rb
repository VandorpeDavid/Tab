# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string(255)      not null
#  price_cents         :integer          default(0), not null
#  category            :integer          default(0)
#  stock               :integer          default(0), not null
#  avatar_file_name    :string(255)
#  avatar_content_type :string(255)
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

class Product < ActiveRecord::Base
  has_many :order_items
  has_attached_file :avatar, styles: { medium: "100x100>" }, default_style: :medium

  enum category: %w(food beverages other)

  validates :name, presence: true
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates_attachment :avatar, presence: true, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }

  def price
    self.price_cents / 100.0
  end

  def price=(value)
    if value.is_a? String then value.sub!(',', '.') end
    self.price_cents = (value.to_f * 100).to_int
  end
end
