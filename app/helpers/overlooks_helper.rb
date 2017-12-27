module OverlooksHelper
  class Obrab
    def initialize(file_obrab = "")
      @@file_obrab = file_obrab
    end
    def self.file_obrab
      @@file_obrab
    end
    def self.file_obrab=(new_name_file)
      @@file_obrab = new_name_file
    end
  end
  class Obrabbtc
    def initialize(file_obrab = "")
      @@file_obrabbtc = file_obrab
    end
    def self.file_obrabbtc
      @@file_obrabbtc
    end
    def self.file_obrabbtc=(new_name_file)
      @@file_obrabbtc = new_name_file
    end
  end
end
