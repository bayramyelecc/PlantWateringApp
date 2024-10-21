//
//  FeedVC.swift
//  BitkiTakipApp
//
//  Created by Bayram Yeleç on 16.10.2024.
//

import UIKit
import CoreData


class AddVC: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var viewAdd: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var secilenSaat: UIDatePicker!
    @IBOutlet weak var customImageView: UIImageView!
    @IBOutlet weak var mlStepper: UIStepper!
    @IBOutlet weak var stepperDeger: UILabel!
    
    var mainVC: MainVc?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //:MARK SETUP
    
    private func setupUI() {
        
        viewAdd.layer.cornerRadius = 20
        customImageView.layer.cornerRadius = 20
        nameTextField.delegate = self
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        customImageView.addGestureRecognizer(imageTap)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(keyboardClose))
        view.addGestureRecognizer(viewTap)
        
        mlStepper.addTarget(self, action: #selector(stepAdd), for: .valueChanged)
    }
    
    @objc func stepAdd(){
        let stepperValue = Int32(mlStepper.value)
        stepperDeger.text = "\(stepperValue) ml"
    }

    
    //:MARK KEYBOARD CLOSE
    
    @objc func keyboardClose() {
        view.endEditing(true)
    }
    
    //:MARK IMAGE TAPPED
    
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    //:MARK IMAGE PİCKER CONTROLLER
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            customImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //:MARK BACK BUTTON
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //:MARK SAVE BUTTON
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.isEmpty, let image = customImageView.image else {
            let alert = UIAlertController(title: "Hata", message: "Lütfen boş alanları doldurunuz", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let saatString = dateFormatter.string(from: secilenSaat.date)
        
        
        let mlDeger = Int32(mlStepper.value)
        
        
        let newItem = Bitki(id: UUID(), titles: name, saats: saatString, ml: mlDeger, image: image)
        mainVC?.models.append(newItem)
        mainVC?.collectionView.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let bitki = NSEntityDescription.insertNewObject(forEntityName: "Bitkiler", into: context)
        bitki.setValue(name, forKey: "titles")
        bitki.setValue(saatString, forKey: "saats")
        bitki.setValue(image.jpegData(compressionQuality: 0.5), forKey: "image")
        bitki.setValue(newItem.id, forKey: "id")
        bitki.setValue(mlDeger, forKey: "ml")
        
        do {
            try context.save()
            print("Kaydedildi")
            mainVC?.fetchData()
            
            print("\(mlStepper.value)")
            
            scheduleDailyNotification(for: saatString, plantName: name)
            
        } catch {
            print("Kaydetme hatası: \(error.localizedDescription)")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //:MARK NOTIFICATION

    private func scheduleDailyNotification(for saatString: String, plantName: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "💧 \(plantName) Suya İhtiyacı Var"
        content.body = "Bitkilerinizi Sulama Zamanı!"
        content.sound = UNNotificationSound.default

        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        guard let selectedDate = dateFormatter.date(from: saatString) else {
            print("Geçersiz saat formatı.")
            return
        }

        
        let triggerDateComponents = Calendar.current.dateComponents([.hour, .minute], from: selectedDate)
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: true)

        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim eklenirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("Günlük bildirim başarıyla eklendi.")
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = nameTextField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false}
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        return updateText.count <= 10
    }


}

