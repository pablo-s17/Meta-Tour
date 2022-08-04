//
//  TestCamera.swift
//  Final Project App
//
//  Created by Pablo Segovia on 7/31/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVKit


class TestCamera: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordButton.layer.borderWidth = 1
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            print("camera available")
            
            let videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .camera
            videoPicker.mediaTypes = [kUTTypeMovie as String]
//            videoPicker.mediaTypes = [UTType.movie.identifier as String]
            videoPicker.allowsEditing = false
            videoPicker.cameraDevice = .rear
            //            videoPicker.cameraOverlayView
            videoPicker.videoQuality = .typeMedium
            //            videoPicker.videoMaximumDuration = 10
            
            self.present(videoPicker, animated: true, completion: nil)
            
        } else {
            
            print("camera NOT available")
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Check for the media type
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeMovie:
            // Handle video selection result
            print("Selected media is video")
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            print(videoUrl)
            
        default:
            print("Mismatched type: \(mediaType)")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
