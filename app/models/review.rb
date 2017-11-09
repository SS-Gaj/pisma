class Review < ActiveRecord::Base
	default_scope -> { order('rw_date DESC') }
end
