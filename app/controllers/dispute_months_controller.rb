class DisputeMonthsController < ApplicationController
  before_action :set_dispute_month, only: [:show, :update, :destroy]

  # GET /dispute_months
  def index
    @dispute_months = DisputeMonth.all

    render json: @dispute_months
  end

  # GET /dispute_months/1
  def show
    render json: @dispute_month
  end

  # POST /dispute_months
  def create
    @dispute_month = DisputeMonth.new(dispute_month_params)

    if @dispute_month.save
      render json: @dispute_month, status: :created, location: @dispute_month
    else
      render json: @dispute_month.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /dispute_months/1
  def update
    if @dispute_month.update(dispute_month_params)
      render json: @dispute_month
    else
      render json: @dispute_month.errors, status: :unprocessable_entity
    end
  end

  # DELETE /dispute_months/1
  def destroy
    @dispute_month.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dispute_month
      @dispute_month = DisputeMonth.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def dispute_month_params
      params.require(:dispute_month).permit(:number, :details)
    end
end
