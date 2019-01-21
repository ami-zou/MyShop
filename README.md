# MyShop
## Project 1: An iOS App for fetching and displaying product data
### Custom Collection Page
Fetches data from Shopify API and displays a list of the available collections:

![Page1](https://github.com/ami-zou/MyShop/blob/master/Custom%20Collections%20list%20page%20-%20Screenshot.png)


### Collection Details Page
When a collection is selected, fetch and display the product details of this collection using `collection_id`.
For each product, fetch the details using `product_id`:
1. Pass the id and other info between two view controllers using a segue
2. For each product, iterate through its `variants` to calculate the total `inventory_quantity` of this product
3. Adjust the display to display all the products info

![Page2](https://github.com/ami-zou/MyShop/blob/master/Collection%20Details%20Page%20-%20Screenshot.png)

### Testing
1. Git clone this project
2. Open it in `xcode`
3. Run on a simulator (I programmed it on an iPhone XR)


## Project 2: The core logic of a marketplace
- Product: contains all the product related information, and can be purchased:
1. When being added to the shopping cart, check its currently inventory and throw an error if it can be put on hold.
2. When being purchased, check its currently inventory and return truth if it can be successfully purchased.
- Marketplace: where all the intended purchases and adding new products are taken place.
- Shoppingcart: can be created in a marketplace and perform all the purchases:
1. Check if products can be added to the cart
2. Add products into the cart and calculate the `total_charge`
3. When `complete` is called, check if it is possible to purchase all the products - send a note and remove the item if it can't be purchased
4. When products are successfully purchased, decrease the inventory amount, charge the user, and reset the cart back to empty

### Testing
1. Git clone this project
2. Open `marketplace.rb` in a text editor
3. Change the product and purchase inputs
4. Run and check the printed statements
