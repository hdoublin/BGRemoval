//
//  ViewController.swift
//  BGRemoval
//
//  Created by HFY on 8/11/23.
//

import UIKit
import BackgroundRemoval
import SwiftUI
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var inputImage: UIImageView!
    @IBOutlet weak var outputImage: UIImageView!

    @IBOutlet weak var segmentedImage: UIImageView!
    var imagePicker = UIImagePickerController()

    var resultImage: UIImage?
    var resultImage2: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let image = UIImage(named: "bottle")
        inputImage.image = image
        do {
            resultImage = try BackgroundRemoval.init().removeBackground(image: image!)
            outputImage.image = resultImage
            resultImage2 = try BackgroundRemoval.init().removeBackground(image: image!, maskOnly: true)
            segmentedImage.image = resultImage2
            
        } catch {
            print(error.localizedDescription)
        }

    }
    @IBAction func copyBtnPressed(_ sender: Any) {
        if let image = resultImage {
            saveImageToGallery(image: image)
        }
        
//        if let image = resultImage {
//            if let data = image.pngData() {
//                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
//                try? data.write(to: filename)
//            }
//        }
    }

    
    func saveImageToGallery(image: UIImage) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges {
                    let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                    request.creationDate = Date() // Optional: Set creation date for the image
                } completionHandler: { success, error in
                    if success {
                        print("Image saved to gallery successfully.")
                    } else if let error = error {
                        print("Error saving image to gallery: \(error.localizedDescription)")
                    }
                }
            } else {
                print("Access to photo library denied.")
            }
        }
    }
}



