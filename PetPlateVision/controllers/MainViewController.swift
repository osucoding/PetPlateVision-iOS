//
//  MainViewController.swift
//  PetPlateVision
//
//  Created by John Choi on 4/4/23.
//

import UIKit
import Vision
import CoreML

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!

    let imagePicker = UIImagePickerController()

    let mlService = MLService.instance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        imagePicker.delegate = self
//        imagePicker.sourceType = .camera
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedImage

            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert image")
            }

            self.title = mlService.detect(image: ciimage) ?? "Unable to classify"
        }

        imagePicker.dismiss(animated: true, completion: nil)
    }

    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        let prompt = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { action in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let library = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        prompt.addAction(camera)
        prompt.addAction(library)
        present(prompt, animated: true, completion: nil)
    }



}

