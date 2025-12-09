class QuoteCategory < ApplicationRecord
  # Each quote category belongs to a quote
  belongs_to :quote
  # Each quote category belongs to a category
  belongs_to :category
end
