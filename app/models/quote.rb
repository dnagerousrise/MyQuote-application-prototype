class Quote < ApplicationRecord
  # Each quote belongs to a user
  belongs_to :user
  # Each quote may optionally belong to a philosopher (can be nil)
  belongs_to :philosopher, optional: true
  # A quote can have many quote_categories and deleting a quote removes its quote_categories
  has_many :quote_categories, dependent: :destroy
  # Through quote_categories, a quote is associated with many categories
  has_many :categories, through: :quote_categories
  # Allows nested form submission for quote_categories, including deletion via _destroy
  accepts_nested_attributes_for :quote_categories, allow_destroy: true
  # Allows nested form submission for philosopher details
  accepts_nested_attributes_for :philosopher
  # Ensures the quote text is present before saving
  validates :quote_text, presence: true 
end
