class Customer < ApplicationRecord
    has_secure_password

    has_many :addresses
    has_many :credit_cards
    has_many :purchases
    has_many :cards, through: :purchases
    has_many :trades, through: :purchases
    has_one :shopping_cart
    belongs_to :store

    after_create :create_shopping_cart

    before_validation :ensure_no_space_username

    validate :no_space_in_username
    validates :username, presence: true
    validates :username, uniqueness: true
    validates :username, length: { in: 8..15}
    validates :password, length: { in: 8..15}

    #return uniq trades array
    def transactions
        self.trades.uniq
    end

    private
    def create_shopping_cart
        ShoppingCart.create(customer_id: self.id)
    end

    def ensure_no_space_username
        self.username = self.username.split.join
    end

    def no_space_in_username
        if self.username.include?(' ')
            errors.add(:space, "is not allowed in username")
        end
    end
end
