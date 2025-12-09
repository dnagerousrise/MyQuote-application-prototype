class HomeController < ApplicationController
  # Allowing 10 public quotes visible in the homepage in descending order
  def index
    @quotes = Quote.where(is_public: true).order(created_at: :desc).limit(10)
  end
  # Standard users quotes
  def uquotes
    @quotes = User.find(session[:user_id]).quotes.order(created_at: :desc)
  end
end
