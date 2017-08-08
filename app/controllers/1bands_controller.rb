class BandsController < ApplicationController

  def index
		@bands = Band.paginate(page: params[:page])
  end

  def create
	band = Band.new(bn_head: "Моя запись 3", novelty: "Пишу вручную прямо в контроллер", 
  bn_date: "2017-08-07 17:00:00", bn_url: "http://www.reuters.com/article/global-markets-idABC123KP1QZ")
	band.save
  end

  def destroy
  end
end
