//
//  OnBoardingCell.swift
//  BitkiTakipApp
//
//  Created by Bayram Yeleç on 21.10.2024.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {
    
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var models: OnBoarding?
    
    func setup(){
        
        customImageView.image = models?.image
        titleLabel.text = models?.title
        descLabel.text = models?.descrip
        
    }
    
}
