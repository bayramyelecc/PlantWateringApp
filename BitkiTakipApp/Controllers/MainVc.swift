//
//  ViewController.swift
//  BitkiTakipApp
//
//  Created by Bayram Yeleç on 16.10.2024.
//

import UIKit
import CoreData

class MainVc: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var filteredItems: [Bitki] = []
    var models: [Bitki] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    //:MARK SETUP
    
    private func setupUI(){
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
        
    }
    
    //:MARK FETCHİNG
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Bitkiler> = Bitkiler.fetchRequest()
        
        do {
            let results = try context.fetch(fetchRequest)
            models = results.map { result in
                let title = result.value(forKey: "titles") as! String
                let saat = result.value(forKey: "saats") as! String
                let imageData = result.value(forKey: "image") as! Data
                let image = UIImage(data: imageData)!
                let id = result.value(forKey: "id") as! UUID
                let ml = result.value(forKey: "ml") as! Int32
                print("Fetched ml: \(ml)")
                return Bitki(id: id, titles: title, saats: saat, ml: ml, image: image)
            }
            filteredItems = models
            collectionView.reloadData()
        } catch {
            print("Veriler gelmedi: \(error.localizedDescription)")
        }
    }

    
    //:MARK ADD BUTTON
    
    @IBAction func addButton(_ sender: UIButton) {
        
        guard let addVC = storyboard?.instantiateViewController(identifier: "storyID") as? AddVC else {
            return
        }
        addVC.modalTransitionStyle = .flipHorizontal
        addVC.modalPresentationStyle = .fullScreen
        addVC.mainVC = self
        present(addVC, animated: true, completion: nil)
    }
    
    //:MARK DELETE ITEM
    
    func deleteItem(at indexPath: IndexPath) {
        
        let deleteItem = models[indexPath.row]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Bitkiler> = Bitkiler.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", deleteItem.id as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let result = results.first {
                context.delete(result)
                try context.save()
                models.remove(at: indexPath.row)
                filteredItems = models
                collectionView.deleteItems(at: [indexPath])
                print("Silme işlemi başarılı.")
            } else {
                print("Veri bulunamadı: \(deleteItem.id)")
            }
        } catch {
            print("Fetch hatası: \(error.localizedDescription)")
        }
    }
    
    //:MARK DELEGATE & DATA SOURCE
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCell
        let model = filteredItems[indexPath.row]
        cell.items = model
        cell.mainVC = self
        cell.layer.cornerRadius = 20
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 10, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = filteredItems[indexPath.row]
        
        if let detailvc = storyboard?.instantiateViewController(withIdentifier: "detailvc") as? DetailVC {
            detailvc.items = selectedItem
            navigationController?.pushViewController(detailvc, animated: true)
        }
        
        
            
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredItems = models
        } else {
            filteredItems = models.filter{ $0.titles.lowercased().contains(searchText.lowercased())}
        }
        collectionView.reloadData()
    }
    
    
}

