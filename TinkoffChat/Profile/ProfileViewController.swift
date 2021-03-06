//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 20.09.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController, ScrollViewKeyboardHandler {
    
    @IBOutlet weak var aboutField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var cameraButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var gcdButton: RoundButton!
    @IBOutlet weak var coreDataButton: RoundButton!
    
    var activeField: UITextField?
    var scrollView: UIScrollView {
        return profileScrollView
    }
    
    private var profile: Profile? = nil
    
    private let imagePicker = UIImagePickerController()
    private let gcdDataManager = GCDDataManager()
    private let operationDataManager = OperationDataManager()
    private let storageManager = StorageManager()
    
    private let fileName = "tinkoff_profile_data"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Профиль"
        
        cameraButton.backgroundColor = .iconBackground
        cameraButton.roundCorners()
        profileImageView.layer.cornerRadius = cameraButton.layer.cornerRadius
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        
        nameField.delegate = self
        aboutField.delegate = self
    
        scrollView.keyboardDismissMode = .onDrag
        
        //readProfile(dataManager: operationDataManager)
        readCoreData()
        
        setButtons(enabled: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.deregisterFromKeyboardNotifications()
    }
    
    @IBAction private func cameraAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Изменить фотографию профиля", preferredStyle: .actionSheet)
        let cameraAction = alertSheetAction(for: .camera)
        let photosAction = alertSheetAction(for: .photoLibrary)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.profileImageView.image = .defaultAvatar
        }
        let cancelAction = UIAlertAction(title: "Закрыть", style: .cancel)
        
        alert.addAction(cameraAction)
        alert.addAction(photosAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func alertSheetAction(for sourceType: UIImagePickerControllerSourceType) -> UIAlertAction {
        let title = sourceType == .camera ? "Камера" : "Фото"
        let action = UIAlertAction(title: title, style: .default) { _ in
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
            if sourceType == .camera && cameraStatus == .denied {
                self.showSettingsAlert()
                return
            }
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                self.imagePicker.sourceType = sourceType
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        return action
    }
    
    private func showSettingsAlert() {
        let alert = UIAlertController(title: "У приложения нет доступа к камере", message: "Разрешите использовать камеру в настройках", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveProfileCoreData(_ sender: RoundButton) {
        self.saveCoreData()
        //self.saveProfile(dataManager: operationDataManager)
    }
    
    @IBAction func saveProfileGCD(_ sender: RoundButton) {
        self.saveProfile(dataManager: gcdDataManager)
    }
    
    func saveProfile(dataManager: DataManager) {
        let name = nameField.textValue
        let about = aboutField.textValue
        let image = profileImageView.image ?? UIImage.defaultAvatar
        
        let newProfile = Profile(name: name, about: about, image: image)
        
        let newData = NSKeyedArchiver.archivedData(withRootObject: newProfile)
        
        self.startLoading()
        dataManager.save(data: newData, to: fileName) {
            success in
            
            self.endLoading()
            
            if success {
                self.profile = newProfile
                self.setButtons(enabled: false)
                self.showAlert(message: "Данные сохранены")
            } else {
                self.showErrorAlert(message: "Не увдалось сохранить данные") {
                    self.saveProfile(dataManager: dataManager)
                }
            }
        }
    }
    
    func readProfile(dataManager: DataManager) {
        self.startLoading()
        
        dataManager.read(from: fileName) {
            data in
            
            self.endLoading()
            
            if let data = data,
                let profile = NSKeyedUnarchiver.unarchiveObject(with: data) as? Profile {
                
                self.profile = profile
                
                self.nameField.text = profile.name
                self.aboutField.text = profile.about
                self.profileImageView.image = profile.image
            }
        }
    }
    
    private func startLoading() {
        setButtons(enabled: false)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    private func endLoading() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    private func setButtons(enabled: Bool) {
        gcdButton.isEnabled = enabled
        coreDataButton.isEnabled = enabled
    }
    
    @IBAction func dismissClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK - UITextFieldDelegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            aboutField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !activityIndicator.isAnimating {
            setButtons(enabled: true)
        }
        
        return true
    }
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = (info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage {
            
            profileImageView.image = image
            
            if !activityIndicator.isAnimating {
                setButtons(enabled: true)
            }
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Core data profile 

extension ProfileViewController {
    func saveCoreData() {
        let name = nameField.textValue
        let about = aboutField.textValue
        
        self.startLoading()
        
        let context = storageManager.privateContext
        
        context.perform {
            [weak self] in
            if let appUser = AppUser.findOrInsertAppUser(with: "CURRENT_USER_IDENTIFIER", in: context),
                let currentUser = appUser.currentUser {
                
                currentUser.name = name
                currentUser.about = about
            }
            
            self?.storageManager.performSave(context: context) { (success) in
                self?.coreDataSavedUser(success)
            }
        }
    }
    
    private func coreDataSavedUser(_ success: Bool) {
        DispatchQueue.main.async {
            
            self.endLoading()
            if success {
                self.showAlert(title: "Успешно", message: "Пользователь сохранен!")
            } else {
                self.showErrorAlert(message: "Нет изменений")
            }
        }
    }
    
    func readCoreData() {
        self.endLoading()
        if let appUser = AppUser.findOrInsertAppUser(with: "CURRENT_USER_IDENTIFIER", in: storageManager.mainContext) {
            nameField.text = appUser.currentUser?.name
            aboutField.text = appUser.currentUser?.about
        }
    }
}

