class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  
  def full_name
    return "#{first_name} #{last_name}".strip if (first_name || last_name)
    return "Anonymous"
  end
  
  def can_add_stock?(ticker_symbol)
    return under_stock_limit? && !stock_already_added?(ticker_symbol)
  end
  
  def under_stock_limit?
    return (user_stocks.count < 10)
  end
  
  def stock_already_added?(ticker_symbol)
    # 從API上旬找不到的話就回傳false, 為無效的stock
    stock = Stock.find_by_ticker(ticker_symbol)
    return false unless stock
    return user_stocks.where(stock_id: stock.id).exists?
  end
end
