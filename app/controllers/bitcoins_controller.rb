class BitcoinsController < ApplicationController
  def index
		@bitcoins = Bitcoin.paginate(page: params[:page])
  end

  def edit	#"Обработать"
	  @bitcoin = Bitcoin.find(params[:id])
    #editor(@bitcoins.bn_url)     
    #Obrab.new(name_file)
    Obrabbtc.new(editorbtc(@bitcoin.btc_url))
   #byebug
    redirect_to btcnew_new_overlook_path	#overlooks#new
   #redirect_to bands_path	#bands#index
  end	#def edit	#"Обработать"
  
  def editfact	#"Цифры_и_факты" из "Просмотреть биткоин" 
	  @bitcoin = Bitcoin.find(params[:id])
    Obrabbtc.new(editorbtc(@bitcoin.btc_url))
   #byebug
    redirect_to newbtc_new_fact_path	#facts#newband 
  end	#def edit	#"Обработать"

  def show	#"Просмотреть"
	  @bitcoin = Bitcoin.find(params[:id])
	  @mas_p = reader(@bitcoin.btc_url)
  end

  def destroy #"Удалить" 
  	  @bitcoin = Bitcoin.find(params[:id])
  	  @bitcoin.destroy
  	  redirect_to bitcoins_path	#bitcoins#index
  end # def destroy

  def corect #"Корр.время" 
  	  @bitcoin = Bitcoin.find(params[:id])
   	  @bitcoin.btc_date = @bitcoin.btc_date - 86400
  	  @bitcoin.save
  	  redirect_to bitcoins_path	#bitcoins#index
  end # def destroy

  def savefile	#“Save-file-txt”
 	  @bitcoin = Bitcoin.find(params[:id])
    wrieter(@bitcoin.btc_url)      
	  #render layout: false
    redirect_to bitcoins_path	#bitcoins#index
	  #redirect_back(fallback_location: root_path)
    #render body: "raw"
  end	#def savefile	#“Save-file-txt”

end
