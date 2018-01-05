class Fact < ActiveRecord::Base
	default_scope -> { order('fc_date DESC') }
end
