class PartsController < ApplicationController
  def new
    @part = Part.new
  end

  def create
    @part = Part.new(part_params)
    if @part.save
      redirect_to parts_path
      flash[:success] = "Part added"
    end
  end

  private

  def part_params
    params.require(:part).permit()
  end
end
