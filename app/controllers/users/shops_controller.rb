class Users::ShopsController < ApplicationController

  def index
    @offers = Offer.active
  end
end
