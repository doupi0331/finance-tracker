class Stock <  ActiveRecord::Base
  
  has_many :user_stocks
  has_many :user, through: :user_stocks
  
  # def self 為class方法
  def self.find_by_method(ticker_symbol)
    where(ticker: ticker_symbol).first
  end
  
  def self.new_from_lookup(ticker_symbol)
    # 從Api抓取資料
    looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
    # 如找不到就回傳nil，則不繼續執行
    return nil unless looked_up_stock.name
    
    new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.name)
    new_stock.last_price = new_stock.price # 自定義price method
    # 成功後回傳object
    new_stock
  end
  
  def price
    closing_price = StockQuote::Stock.quote(ticker).close
    return "#{closing_price} (Closing)" if closing_price
    
    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (Opening)" if opening_price
    
    # 如果都沒有 就回傳下面文字
    "Unavailable"
  end
end
