//
//  DetailVC.swift
//  BitkiTakipApp
//
//  Created by Bayram Yeleç on 18.10.2024.
//

import UIKit
import CoreData

class DetailVC: UIViewController {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailSaat: UILabel!
    @IBOutlet weak var detailMl: UILabel!
    @IBOutlet weak var detailAciklama: UITextView!
    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var altView: UIView!
    @IBOutlet weak var altViewiki: UIView!
    
    
    var items: Bitki?
    
    var descItems : [Desc] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardClose))
        view.addGestureRecognizer(tapGesture)
        
        fetchData()
        
        if detailAciklama.text == "" {
            detailAciklama.becomeFirstResponder()
        }
        
    }
    
    @objc func keyboardClose(){
        view.endEditing(true)
    }
    
    func setupUI(){
        detailTitle.text = items?.titles
        detailSaat.text = items?.saats
        detailMl.text = "\(items?.ml ?? 0) ml"
        detailImage.image = items?.image
        
        bodyView.layer.cornerRadius = 30
        altView.layer.cornerRadius = 10
        altViewiki.layer.cornerRadius = 10
        detailImage.layer.cornerRadius = 20
        detailAciklama.layer.cornerRadius = 10
 
    }
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<DescNew> = DescNew.fetchRequest()

        guard let bitkiId = items?.id else {
            detailAciklama.text = "Açıklama yok."
            return
        }

        fetchRequest.predicate = NSPredicate(format: "bitkiId == %@", bitkiId as CVarArg)

        do {
            let descItems: [DescNew] = try context.fetch(fetchRequest)

            if let lastItem = descItems.last {
                detailAciklama.text = lastItem.descitem ?? ""
            }
        } catch {
            print("Veri çekme hatası: \(error)")
        }
    }

    

    @IBAction func saveButton(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let descr = NSEntityDescription.insertNewObject(forEntityName: "DescNew", into: context)
        descr.setValue(detailAciklama.text, forKey: "descitem")
        descr.setValue(items?.id, forKey: "bitkiId")
        descr.setValue(UUID(), forKey: "id")

        do {
            try context.save()
            print("Açıklama kayıt edildi")
            
            let alert = UIAlertController(title: "Kayıt edildi..", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default))
            present(alert, animated: true, completion: nil)
            
        } catch {
            print("Kaydetme hatası: \(error)")
        }
    }
    

}


