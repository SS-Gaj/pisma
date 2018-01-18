class FactsController < ApplicationController
  before_action :set_fact, only: [:show, :edit, :update, :destroy]

  # GET /facts
  # GET /facts.json
  def index
#    @facts = Fact.all
		@facts = Fact.paginate(page: params[:page])

  end

  # GET /facts/1
  # GET /facts/1.json
  def show
  end

  # GET /facts/new
  def new
    @fact = Fact.new
  end

  # GET /facts/1/edit
  def edit
  end

  # POST /facts
  # POST /facts.json
  def create
    @fact = Fact.new(fact_params)

    respond_to do |format|
      if @fact.save
        format.html { redirect_to @fact, notice: 'Fact was successfully created.' }
        format.json { render action: 'show', status: :created, location: @fact }
      else
        format.html { render action: 'new' }
        format.json { render json: @fact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /facts/1
  # PATCH/PUT /facts/1.json
  def update
    respond_to do |format|
      if @fact.update(fact_params)
        format.html { redirect_to @fact, notice: 'Fact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @fact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /facts/1
  # DELETE /facts/1.json
  def destroy
    @fact.destroy
    respond_to do |format|
      format.html { redirect_to facts_url }
      format.json { head :no_content }
    end
  end

  def newband #"Цифры_и_факты" из "Просмотреть". Сюда попадаем из def editfact bands_controller
    texttocopy  #/app/controllers/application_controller.rb
  end

  def newbtc #"Цифры_и_факты" из "Просмотреть". Сюда попадаем из def editfact bitcoins_controller
    texttocopy  #/app/controllers/application_controller.rb
#  	render "newband"
  end
  
  def copyband #копирование фактов из ленты новостей в БД 'Band'
  #вызывается в цепочке нажатия "Цифры_и_факты" в "Просмотреть"
    texttocopy  #/app/controllers/application_controller.rb
    factsave    #сохранение абзаца в БД 'Fact'
  	render "newband"
  end #def fact #копирование фактов из ленты новостей в БД 'Fact'

  def copybtc #копирование фактов из ленты новостей в БД 'Bitcoin'
  #вызывается в цепочке нажатия "Цифры_и_факты" в "Просмотреть"
    texttocopy  #/app/controllers/application_controller.rb
    factsave    #сохранение абзаца в БД 'Fact'
  	render "newbtc"
  end #def fact #копирование фактов из ленты новостей в БД 'Fact'

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fact
      @fact = Fact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fact_params
      params.require(:fact).permit(:fc_range, :fc_fact, :fc_myurl, :fc_isxurl, :fc_date)
    end
end
