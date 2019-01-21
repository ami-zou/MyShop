//
//  ViewController.swift
//  Shop
//
//  Created by Ami Zou on 1/20/19.
//  Copyright © 2019 Ami Zou. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var collectionBody: UILabel!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var detailsList: UITableView!
    
    var collection_id = 0
    var collection_name: String = ""
    //var collection_image: UIImage
    var collection : Collection?
    var productIds : [Int] = []
    var productsList : [Product] = []
    
    var testingData = ["K1", "K2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionCard()
        
        //Fetching the list of products using collection_i
        let urlString = "https://shopicruit.myshopify.com/admin/collects.json?collection_id=\(collection_id)&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                typealias JSONDictionary = [String:Any]
                
                if let collectsData = try JSONSerialization.jsonObject(with: data) as? JSONDictionary{
                    print(collectsData)
                    if let collects = collectsData["collects"] as? [JSONDictionary] {
                        
                        for collect in collects {
                            let product_id = collect["product_id"] as! Int
                            print(product_id)
                            self.productIds.append(product_id)
                        }
                    }
                }
                
                //Get product details using product_id
                self.fetchProductDetails()
                
                //Reload Data
                DispatchQueue.main.async {
                    self.detailsList.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
            }.resume()
    }
    
    func fetchProductDetails() -> Void {
        //Parsing URL strings to include all the product ids separated by commas
        print(productIds)
        if productIds.count < 1 { return }
        
        var urlString : String = "https://shopicruit.myshopify.com/admin/products.json?ids="
        urlString += String(productIds[0])
        
        for id in productIds.indices.dropFirst(){
            urlString += ","
            urlString += String(productIds[id])
        }
        
        urlString += "&page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        
        print(urlString)
        
        //Create URL + URLSession for fetching data:
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                typealias JSONDictionary = [String:Any]
                
                if let productsData = try JSONSerialization.jsonObject(with: data) as? JSONDictionary{
                    print(productsData)
                    if let products = productsData["products"] as? [JSONDictionary] {
                        
                        for product in products {
                            let title = product["title"] as! String
                            var inventory_quantity = 0
                            
                            if let variants = product["variants"] as? [JSONDictionary]{
                                for variant in variants{
                                    let inventory = variant["inventory_quantity"] as? Int ?? 0
                                    inventory_quantity += inventory
                                }
                            }
                            
                            let p = Product(title: title, inventory_quantity: inventory_quantity, collection_name: self.collection_name)
                            print("This is p", p)
                            self.productsList.append(p)
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.detailsList.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
        }.resume()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detail_cell", for: indexPath) as! DetailCell
 
        let product = productsList[indexPath.row]
        cell.detailTitle?.text = product.title
        cell.detailInventory?.text = "Inventory: " + String(product.inventory_quantity)
        cell.collectionName?.text = "Collection: " + self.collection_name
        
        return cell
    }
    
    func createCollectionCard(){
        collection_name = collection?.title ?? ""
        collectionTitle.text = self.collection_name
        collectionBody.text = collection?.body_html
        collectionBody.numberOfLines = 0
        collectionBody.lineBreakMode = NSLineBreakMode.byWordWrapping
        //TODO: Add another function to return optimum height
    }
    
}

class DetailCell: UITableViewCell {
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailInventory: UILabel!
    @IBOutlet weak var collectionName: UILabel!
    @IBOutlet weak var collectionImg: UIImageView!
}

//TODO Create a collection card that adjust its own height
