require 'spec_helper'

describe "Band pages" do

  subject { page }

  describe "Band index-pages" do
    before { visit bands_path }

    it { should have_content('Новости') }
    it { should have_title(full_title('Новости')) }
  end
end


