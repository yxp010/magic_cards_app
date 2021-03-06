class ShoppingCart < ApplicationRecord

    belongs_to :customer, optional: true
    has_and_belongs_to_many :cards


    #{card: quantity} hash in cart
    def uniq_cards_quantity_hash
        hash = {}
        self.cards.each do |card|
           if hash[card] == nil
            hash[card] = 1
           else 
            hash[card] += 1
           end
        end
        hash
    end

    def make_purchase
        self.cards.each do |card|
        end
    end

    def total_price
        self.cards.map {|card| card.price.to_f}.sum.floor(2)
    end

    def change_card_quantity(card_id, quantity)
        join_class_arr = CardsShoppingCart.where("card_id = ? and shopping_cart_id = ?", card_id, self.id)
        join_class_arr.each do |join_class|
            join_class.destroy
        end
        quantity.times do 
            CardsShoppingCart.create(card_id: card_id, shopping_cart_id: self.id)
        end
    end

    def out_of_stock
        errors = []
        self.uniq_cards_quantity_hash.each do |card, quantity_in_cart|
            if card.quantity < quantity_in_cart
                errors << "Card '#{card.name}' has only #{card.quantity} in stock." 
            end
        end
        errors.empty? ? nil : errors
    end
end