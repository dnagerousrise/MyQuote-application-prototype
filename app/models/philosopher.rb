class Philosopher < ApplicationRecord
    # A philosopher can may have many quotes associated to them
    has_many :quotes
end
