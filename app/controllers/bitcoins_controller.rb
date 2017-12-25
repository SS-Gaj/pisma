class BitcoinsController < ApplicationController
  def index
		@bitcoins = Bitcoin.paginate(page: params[:page])
  end

  def edit	#"Обработать"
  end	#def edit	#"Обработать"
  
  def show	#"Просмотреть"
	  @bitcoin = Bitcoin.find(params[:id])
	  @mas_p = reader(@bitcoin.btc_url)
  end

  def savefile	#“Save-file-txt”
 	  @bitcoin = Bitcoin.find(params[:id])
    wrieter(@bitcoin.btc_url)      
	  #render layout: false
    redirect_to bitcoins_path	#bitcoins#index
	  #redirect_back(fallback_location: root_path)
    #render body: "raw"
  end	#def savefile	#“Save-file-txt”

end
