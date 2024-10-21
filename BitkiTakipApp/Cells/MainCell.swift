//
//  MainCell.swift
//  BitkiTakipApp
//
//  Created by Bayram Yeleç on 16.10.2024.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    var mainVC : MainVc?
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var adLbl: UILabel!
    @IBOutlet weak var saatLbl: UILabel!
    @IBOutlet weak var mlDeger: UILabel!
    
    
    var items: Bitki? {
        didSet{
            setupUI()
        }
    }
    
    //:MARK SETUP
    
    private func setupUI(){
        
        adLbl.text = items?.titles
        saatLbl.text = items?.saats
        customImageView.image = items?.image
        mlDeger.text = "\(items?.ml ?? 0) ml"

        customImageView.layer.cornerRadius = 20
        
    }
    
    //:MARK MORE BUTTON
    
    @IBAction func moreButton(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Uyarı", message: "Veri silinsin mi ?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { _ in
            
            if let indexPath = self.mainVC?.collectionView.indexPath(for: self) {
                self.mainVC?.deleteItem(at: indexPath)
            }
        }))
        alert.addAction(UIAlertAction(title: "İptal", style: .default, handler: nil))
        self.mainVC?.present(alert, animated: true, completion: nil)
    }
    
    
    
}

