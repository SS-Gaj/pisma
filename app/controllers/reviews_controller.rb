class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @reviews = Review.all
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    target_date = Date.today
    name_rw = dir_save_file(target_date) + name_save_file(target_date, '/rw-')  #def in application_controller.rb
	  unless File.exist?(name_rw)
      #overlook = Overlook.new(lk_date: target_date, lk_file: name_rw)
      @review = Review.new(rw_date: target_date, rw_file: name_rw)
      @review.save
		  f = File.new(name_rw, 'w')
		  @doc_f = Nokogiri::HTML::Document.parse <<-EOHTML
          <root>
            <day> Статья за </day>
          </root>
      EOHTML
      day = @doc_f.at_css "day"
      day.content = "Статья за " + target_date.strftime("%Y%m%d")
      #nodes = @doc_f.css "h1"
      #nodes.wrap("<div class='container'></div>")
      f << @doc_f
      f.close
	  end # unless File.exist?(name_rw)

  end #def new

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: 'Review was successfully created.' }
        format.json { render action: 'show', status: :created, location: @review }
      else
        format.html { render action: 'new' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: 'Review was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:rw_date, :rw_file)
    end
end
