class Category < ApplicationRecord
    # A category can be linked to many quote_categories and deleting a category removes its quote_categories
    has_many :quote_categories, dependent: :destroy
    # Through quote_categories, a category is associated with many quotes
    has_many :quotes, through: :quote_categories
    # Ensures that every category has a name before saving
    validates :name, presence: true
end
