//
//  OnBoardingVC.swift
//  BitkiTakipApp
//
//  Created by Bayram Yeleç on 21.10.2024.
//

import UIKit

class OnBoardingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    var currentPage = 0 {
        didSet{
            pageControl.currentPage = currentPage
            if currentPage == arrayList.count - 1 {
                nextButton.setTitle("Get Started", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    var arrayList : [OnBoarding] = [
        OnBoarding(title: "Bitkilerinize İyi Bakın!", descrip: "Bitkilerinizin sulama zamanlarını asla kaçırmayın. Uygulamamız, her bitkinin ihtiyacına göre size hatırlatmalar yapar.", image: UIImage(named: "g1")!),
        OnBoarding(title: "Kişiselleştirilmiş Hatırlatmalar", descrip: "Her bitki için sulama zamanı belirleyin ve düzenli olarak bildirim alın. Böylece bitkileriniz her zaman sağlıklı kalsın.", image: UIImage(named: "g2")!),
        OnBoarding(title: "Bitkilerinizi Tanıyın", descrip: "Bitkilerinizin fotoğraflarını ekleyin, açıklamalar ekleyin ve onları daha yakından tanıyın.", image: UIImage(named: "g3")!)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        currentPage = 0
    }
    
    func setupUI(){
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        collectionView.collectionViewLayout = layout
        
    }
    

    @IBAction func nextButton(_ sender: UIButton) {
        
        if currentPage == arrayList.count - 1 {
            
            UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
            
            guard let mainVC = storyboard?.instantiateViewController(identifier: "mainid") else {return}
            mainVC.modalTransitionStyle = .crossDissolve
            mainVC.modalPresentationStyle = .fullScreen
            present(mainVC, animated: true, completion: nil)
            
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! OnBoardingCell
        let model = arrayList[indexPath.row]
        cell.models = model
        cell.setup()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = view.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
}
