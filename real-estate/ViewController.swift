//
//  ViewController.swift
//  real-estate
//
//  Created by Nini mekhashishvili on 8/21/20.
//  Copyright © niniko mekhashishvili. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var listCollection: UICollectionView!
    
    let respone = APIResponse()
    var allvilla = [villaInfo]()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        listCollection.delegate = self
        listCollection.dataSource = self
        respone.getBands { (vila) in
             self.allvilla = vila.properties
            DispatchQueue.main.async {
                self.listCollection.reloadData()
            }
        }
    }


}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allvilla.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = listCollection.dequeueReusableCell(withReuseIdentifier: "home_cell", for: indexPath) as! HomeCollectionViewCell
        
        cell.home_title.text = allvilla[indexPath.row].thumbnail
        cell.home_price.text = "$ \(allvilla[indexPath.row].price)"
        cell.home_type.text = allvilla[indexPath.row].prop_status
        cell.bath_count.text = "\(allvilla[indexPath.row].baths ?? 0) Bathroom"
        cell.bed_count.text = "\(allvilla[indexPath.row].beds ?? 0) Bedroom"
        cell.sqr.text = "\(allvilla[indexPath.row].building_size?.size) Sqft"
        
        allvilla[indexPath.row].thumbnail?.downloadImage { (image) in
          DispatchQueue.main.async {
            cell.home_img.image = image
          }
        }
        
        return cell
    }
    
    
}
extension String {
  func downloadImage(completion: @escaping (UIImage?) -> ()) {
    guard let url = URL(string: self) else {return}
    URLSession.shared.dataTask(with: url) { (data, res, err) in
      guard let data = data else {return}
      completion(UIImage(data: data))
    }.resume()
  }
}

//extension ViewController: UISearchBarDelegate{
// func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//  newArray = allvilla.filter({$0.agents[0].name.prefix(searchText.count) == searchText})
// }
//}
