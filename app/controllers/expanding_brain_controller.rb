class ExpandingBrainController < ApplicationController
  def index
  end

  def new
  end

  def create
    brains = params["expanding_brain"]
    @brains = ExpandingBrain.new(brains["brain_1"], brains["brain_2"], brains["brain_3"], brains["brain_4"]).generate
    redirect_to @brains.url, status: 303
  end

  def show
  end
end
