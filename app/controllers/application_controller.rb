class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  def init_myvar
    @@file_obzor = ""
    @div_article_header = ""
    @div_date = ""
    @overlook = ""
    @mas_p = ""
  end
  @reuters_dir = '/home/ss/reuters'
  def dir_save_file (date_prezent)  # used in overlooks_controller.rb
  # puts "REUTERS_DIR = #{REUTERS_DIR}"
   	@mas_p = []
	  dir_year = date_prezent.year.to_s
	  dir_mon = date_prezent.mon.to_s
	  dir_day = date_prezent.day.to_s
	  #Dir.chdir(REUTERS_DIR)
	  #REUTERS_DIR = '/home/ss/Documents/Reuters/index'
	  #Dir.chdir('/home/ss/Documents/Reuters')
    Dir.chdir('/home/ss/reuters')
	  Dir.mkdir(dir_year) unless File.directory?(dir_year)
	  Dir.chdir(dir_year)
	  Dir.mkdir(dir_mon) unless File.directory?(dir_mon)
	  Dir.chdir(dir_mon)
	  Dir.mkdir(dir_day) unless File.directory?(dir_day)
	  Dir.chdir(dir_day)
	  return Dir.pwd
  end	#my_dir

  def name_save_file (date_prezent) # used in overlooks_controller.rb
     return '/lk-' + date_prezent.strftime("%y%m%d") + '.html'
  end	#my_file
end
