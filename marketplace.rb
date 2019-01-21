# Every product should have a title, price, and inventory_count.

class Product
    attr_accessor :title, :price, :inventory_count

    def initialize(title: 'Title', 
                   price: 0.0, 
                   inventory_count: 1)
        @title = title
        @price = price
        @inventory_count = inventory_count
        @purchase_amount = 0

        puts "Initializing #{@inventory_count} numbers of #{@title} with price #{@price} each!"
    end

    def on_hold(amount = 1)
        if @inventory_count >= amount
            @purchase_amount = amount
            puts "putting #{@purchase_amount} on hold now!"
            true
        else #TODO: maybe prompt an error
            puts "Oops! We currently only have #{@inventory_count} #{@title}. Can't add #{amount} to cart :("
            false
        end
    end

    def purchase
        if @inventory_count >= @purchase_amount
            @inventory_count-= @purchase_amount
            puts "Now you just successfully purchased #{@purchase_amount} #{@title}!! Current inventory count is #{@inventory_count}."
            @purchase_amount = 0
            true
        else
            puts "Low inventory! Can't purchase #{@purchase_amount} #{@title}"
            false
        end
    end
end

class Marketplace

    def initialize(products = [])
        @products = products
        @shoppingcart = Shoppingcart.new
    end

    def addProduct(product)
        @products.push(product)
    end

    def addProducts(products = [])
        @products.push(*products)
    end

    def fetchProduct(product_name = nil)
        product = if product_name
                    @products.select{ |p| p.title == product_name}[0] #TODO: a better comparison/select way?
                  else
                    @products
                  end
        product
    end

    def one_click_purchase(product_name, purchase_amount = 1)
        add_to_cart(product_name, purchase_amount)
        complete_cart
    end

    def add_to_cart(product_name, purchase_amount = 1)
        p = fetchProduct(product_name)
        puts "Oh no! Can't add to card because this product doesn't exist!!" if p.nil? #TODO: throw and handle this error
        @shoppingcart.add(p, purchase_amount) unless p.nil?
    end

    def complete_cart
        @shoppingcart.complete
        @shoppingcart = Shoppingcart.new
    end
end

class Shoppingcart

    def initialize
        @products = []
        @total_value = 0
    end

    def add(product, purchase_amount)
        if product.on_hold(purchase_amount)
            @products << product
            product_value = product.price * purchase_amount
            puts "Product value is #{product.price} * #{purchase_amount} = #{product_value}"
            @total_value+= product_value
            puts "Now adding #{purchase_amount} #{product.title} to the cart with value #{product_value}. Total value is #{@total_value}"
        else
            #TODO: handle lowInventoryError throw by Product 
        end
    end

    def complete
        @products.each do |product|
            product.purchase
        end
    end
end


# Testing:
p1 = Product.new(title: "Coffee", price: 4.5, inventory_count: 4)

puts "The inventory account is : #{p1.inventory_count}"

p1.on_hold(5)
p1.purchase

p2 = Product.new(title: "Ice Cream", price: 6, inventory_count: 10)
p3 = Product.new(title: "Tea bag", price: 1.5, inventory_count: 8)
p4 = Product.new(title: "Muffin", price: 2.99, inventory_count: 6)

m = Marketplace.new()

m.addProduct(p1)
m.fetchProduct

products = [p2, p3, p4]
m.addProducts(products)
m.fetchProduct

m.fetchProduct("Ice Cream")

m.add_to_cart("Muffin", 2)
m.add_to_cart("Coffee", 3)
m.add_to_cart("Tea bag", 10)

m.complete_cart

m.one_click_purchase("Tea bag", 2)

puts "End"