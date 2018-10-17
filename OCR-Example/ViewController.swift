//
//  ViewController.swift
//  OCR-Example
//
//  Created by Jan Niklas Steeg on 17.10.18.
//  Copyright © 2018 Jan Steeg. All rights reserved.
//

import UIKit
import SwiftyTesseract

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    
    @IBAction func ocrButton(_ sender: UIButton) {
        presentImagePicker()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func performImageRecognition(_ image: UIImage) {
        print("performImageRecognition() called, setting language...")
        let swiftyTesseract = SwiftyTesseract(languages: [.english])
        print("performOCR()...")
        
        swiftyTesseract.performOCR(on: image) { (recognizedString) in
            print("performOCR done...")
            guard let recognizedString = recognizedString else { return }
            print(recognizedString)
        }
        print("recognition done")
    }


}

// 1
// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    func presentImagePicker() {
        // 2
        let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Image",
                                                       message: nil, preferredStyle: .actionSheet)
        // 3
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraButton = UIAlertAction(title: "Take Photo",
                                             style: .default) { (alert) -> Void in
                                                let imagePicker = UIImagePickerController()
                                                imagePicker.delegate = self
                                                imagePicker.sourceType = .camera
                                                self.present(imagePicker, animated: true)
            }
            imagePickerActionSheet.addAction(cameraButton)
        }
        // 1
        let libraryButton = UIAlertAction(title: "Choose Existing",
                                          style: .default) { (alert) -> Void in
                                            let imagePicker = UIImagePickerController()
                                            imagePicker.delegate = self
                                            imagePicker.sourceType = .photoLibrary
                                            self.present(imagePicker, animated: true)
        }
        imagePickerActionSheet.addAction(libraryButton)
        // 2
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        imagePickerActionSheet.addAction(cancelButton)
        // 3
        present(imagePickerActionSheet, animated: true)
    }
    
    // 1
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 2
        if let selectedPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let scaledImage = selectedPhoto.scaleImage(640) {
            self.performImageRecognition(scaledImage)
        }
    }
}

// MARK: - UIImage extension
extension UIImage {
    func scaleImage(_ maxDimension: CGFloat) -> UIImage? {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        
        if size.width > size.height {
            let scaleFactor = size.height / size.width
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            let scaleFactor = size.width / size.height
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        draw(in: CGRect(origin: .zero, size: scaledSize))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
