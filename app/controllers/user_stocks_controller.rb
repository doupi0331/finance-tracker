class UserStocksController < ApplicationController
  before_action :set_user_stock, only: [:show, :edit, :update, :destroy]

  # GET /user_stocks
  # GET /user_stocks.json
  def index
    @user_stocks = UserStock.all
  end

  # GET /user_stocks/1
  # GET /user_stocks/1.json
  def show
  end

  # GET /user_stocks/new
  def new
    @user_stock = UserStock.new
  end

  # GET /user_stocks/1/edit
  def edit
  end

  # POST /user_stocks
  # POST /user_stocks.json
  def create
    if params[:stock_id].present?
      # 如果資料庫有存在這個stock id, 則直接存取
      @user_stock = UserStock.new(stock_id: params[:stock_id], user: current_user)
    else
      # 如果id找不到, 就用stock ticker去找
      stock = Stock.find_by_ticker(params[:stock_ticker])
      if stock
        # 資料庫有資料的話就新增
        @user_stock = UserStock.new(user: current_user, stock: stock)
      else
        # 資料庫沒有的話, 就從API抓取資料
        stock = Stock.new_from_lookup(params[:stock_ticker])
        # 並存取至資料庫中
        if stock.save
          # 之後再將user_stock儲存至資料庫
          @user_stock = UserStock.new(user: current_user, stock: stock)
        else
          # 連api都找不到的話，就顯示錯誤訊息
          @user_stock = nil
          flash[:error] = "Stock is not available"
        end
      end
    end

    respond_to do |format|
      if @user_stock.save
        format.html { redirect_to my_portfolio_path, 
          notice: "Stock #{@user_stock.stock.ticker} was successfully added." }
        format.json { render :show, status: :created, location: @user_stock }
      else
        format.html { render :new }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stocks/1
  # PATCH/PUT /user_stocks/1.json
  def update
    respond_to do |format|
      if @user_stock.update(user_stock_params)
        format.html { redirect_to root_path, 
          notice: "Stock #{@user_stock.stock.ticker} was successfully added." }
        format.json { render :show, status: :ok, location: @user_stock }
      else
        format.html { render :edit }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stocks/1
  # DELETE /user_stocks/1.json
  def destroy
    @user_stock.destroy
    respond_to do |format|
      format.html { redirect_to my_portfolio_path, notice: 'Stock was successfully removed from portfolio.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_stock
      @user_stock = UserStock.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_stock_params
      params.require(:user_stock).permit(:user_id, :stock_id)
    end
end
