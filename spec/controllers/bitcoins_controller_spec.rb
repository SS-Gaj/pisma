require 'spec_helper'

describe BitcoinsController do

  describe "GET '–no-test-framework'" do
    it "returns http success" do
      get '–no-test-framework'
      response.should be_success
    end
  end

end
