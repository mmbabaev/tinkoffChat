//
//  ViewController.swift
//  TinkoffChat
//
//  Created by Mihail Babaev on 20.09.17.
//  Copyright © 2017 mbabaev. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var aboutField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet private weak var profileImageView: UIImageView!
   @IBOutlet private weak var cameraButton: UIButton!

    private let imagePicker = UIImagePickerController()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cameraButton.backgroundColor = .iconBackground
        cameraButton.roundCorners()
        profileImageView.layer.cornerRadius = cameraButton.layer.cornerRadius
        
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
    }
    
    @IBAction private func cameraAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "", message: "Изменить фотографию профиля", preferredStyle: .actionSheet)
        let cameraAction = alertSheetAction(for: .camera)
        let photosAction = alertSheetAction(for: .photoLibrary)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.profileImageView.image = .defaultAvatar
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
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
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = (info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage {
            profileImageView.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}

