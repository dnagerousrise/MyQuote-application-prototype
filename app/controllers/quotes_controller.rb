class QuotesController < ApplicationController
  # Allows to perform CRUD operations
  before_action :set_quote, only: %i[ show edit update destroy ]
  # Calls authorize_user before allowing modifying the quotes (Checks for quote owner or is the user an administrator)
  before_action :authorize_user!, only: [:edit, :update, :destroy]


  # GET /quotes or /quotes.json
  def index
    @quotes = Quote.all
  end

  # GET /quotes/1 or /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
    @quote.build_philosopher
    8.times{@quote.quote_categories.build}
  end



  # GET /quotes/1/edit
  def edit
    @philosophers = Philosopher.order(:p_fname, :p_lname)
    @categories = Category.order(:name)
  end


  # POST /quotes or /quotes.json
  def create
    @quote = Quote.new(quote_params)
    @quote.user = current_user

    if @quote.save
      redirect_to @quote, notice: "Quote was successfully created."
    else
      @categories = Category.order(:name)
      remaining = 3 - @quote.quote_categories.size
      remaining.times { @quote.quote_categories.build } if remaining > 0
      @quote.build_philosopher if @quote.philosopher.nil?
      render :new, status: :unprocessable_entity
    end
  end


  # PATCH/PUT /quotes/1 or /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: "Quote was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1 or /quotes/1.json
  def destroy
    @quote.destroy!

    respond_to do |format|
      format.html { redirect_to quotes_path, notice: "Quote was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def quote_params
      params.require(:quote).permit(
        :quote_text, :pub_year, :comment, :is_public,
        philosopher_attributes: [:p_fname, :p_lname, :birth_year, :death_year, :biography],
        quote_categories_attributes: [:id, :category_id, :_destroy]
      )
    end

  # Only allow authorise user to edit and destroy
  def authorize_user!
    unless current_user == @quote.user || current_user.is_admin?
      redirect_to quotes_path, alert: "You’re not authorized to modify this quote."
    end
  end

end
