# MyShop
## Project 1: An iOS App for fetching and displaying product data
### Custom Collection Page
![Page1](https://github.com/ami-zou/MyShop/blob/master/Custom%20Collections%20list%20page%20-%20Screenshot.png)

### Collection Details Page
![Page2](https://github.com/ami-zou/MyShop/blob/master/Collection%20Details%20Page%20-%20Screenshot.png)

## Project 2: The core logic for a marketplace
- Product: contains all the product related information, and can be purchased:
1. When being added to the shopping cart, check its currently inventory and throw an error if it can be put on hold.
2. When being purchased, check its currently inventory and return truth if it can be successfully purchased.
- Marketplace: where all the intended purchases and adding new products are taken place.
- Shoppingcart: can be created in a marketplace and perform all the purchases:
1. Check if products can be added to the cart
2. Add products into the cart and calculate the `total_charge`
3. When `complete` is called, check if it is possible to purchase all the products - send a note and remove the item if it can't be purchased
4. When products are successfully purchased, decrease the inventory amount, charge the user, and reset the cart back to empty
