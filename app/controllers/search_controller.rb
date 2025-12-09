class SearchController < ApplicationController
  # Allowing search by category (Search logic)
  def index
    query = params[:category_name].to_s.downcase.strip

    if query.blank?
      @quotes = []
      @category = nil
    else
      @category = Category.where("LOWER(name) LIKE ?", "%#{query}%").first

      if @category
        @quotes = @category.quotes.where(is_public: true).includes(:user, :philosopher)
      else
        @quotes = []
      end
    end
  end
end
