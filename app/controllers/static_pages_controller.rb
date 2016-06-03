class StaticPagesController < ApplicationController
  def home
  	@partrecommendations = PartRecommendation.limit(8).order("RANDOM()")

  end

  def contact
  end
end
