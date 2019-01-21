//
//  CollectionsTableVC.swift
//  Shop
//
//  Created by Ami Zou on 1/20/19.
//  Copyright © 2019 Ami Zou. All rights reserved.
//

import UIKit

class CollectionsTableVC: UITableViewController {
    var collectionsList: [Collection] = []
    var selectedIndex = 0
    var selectedCollectionId = 0
    var selectedCollection : Collection?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Fetching data
        let urlString = "https://shopicruit.myshopify.com/admin/custom_collections.json?page=1&access_token=c32313df0d0ef512ca64d5b336a0d7c6"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                typealias JSONDictionary = [String:Any]
                
                if let collectionsData = try JSONSerialization.jsonObject(with: data) as? JSONDictionary{
                    if let collections = collectionsData["custom_collections"] as? [JSONDictionary] {
                        for collection in collections {
                            let title = collection["title"] as! String
                            let id = collection["id"] as! Int
                            let body_html = collection["body_html"] as! String
                            //let image
                            let c = Collection(id: id, title: title, body_html: body_html)
                            self.collectionsList.append(c)
                        }
                        
                    }
                }
                
                //Reload Data
                DispatchQueue.main.async {
                    print(self.collectionsList)
                    self.tableView.reloadData()
                }
                
            } catch let jsonError {
                print(jsonError)
            }
            
        }.resume()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collectionsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "collection_cell", for: indexPath)

        cell.textLabel?.text = collectionsList[indexPath.item].title
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        selectedCollectionId = collectionsList[selectedIndex].id!
        selectedCollection = collectionsList[selectedIndex]
        
        performSegue(withIdentifier: "show_details_segue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "show_details_segue"){
            let detailsVC = segue.destination as! DetailsVC
            detailsVC.collection_id = selectedCollectionId
            detailsVC.collection = selectedCollection
        }
    }
}
