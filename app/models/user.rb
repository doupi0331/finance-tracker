class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendship
  
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
  
  def not_friends_with?(friend_id)
    return friendships.where(friend_id: friend_id).count < 1
  end
  
  def except_current_user(users)
    users.reject {|user| user.id == self.id}
  end
  
  def self.search(param)
    return User.none if param.blank?
    
    param.strip! #清除空白
    param.downcase!
    
    return (first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
  end
  
  def self.first_name_matches(param)
    return matches('first_name', param)
  end
  
  def self.last_name_matches(param)
    return matches('last_name', param)
  end
  
  def self.email_matches(param)
    return matches('email', param)
  end
  
  def self.matches(field_name, param)
    return where("lower(#{field_name}) like ?", "%#{param}%")
  end
  
end
