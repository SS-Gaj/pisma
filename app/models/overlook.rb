class Overlook < ActiveRecord::Base
	default_scope -> { order('lk_date DESC') }
end
