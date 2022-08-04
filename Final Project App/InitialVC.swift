//
//  ViewController.swift
//  Final Project App
//
//  Created by Pablo Segovia on 7/20/22.
//

import UIKit

class InitialVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var button: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("this data: ", BRUH.BRUH)
        if Checking.goHome == true {
            Checking.goHome = false
            upload()
            BRUH.BRUH = [[[]]]
            BRUH.videos = []
            BRUH.title = ""
            self.performSegue(withIdentifier: "goPopUp", sender: self)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = button.frame.size.height / 5
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        BRUH.BRUH = []
        Checking.goHome = false
        Checking.startIsEnd = false
        Checking.videoRecorded = false
        BRUH.title = ""
    }
    //https://10.0.0.116:5001/upload-data
    
    func upload() {
        let readings = BRUH.BRUH
        let videos = BRUH.videos
        let title = BRUH.title
        let description = "Not ready"
//        var didLoop = "false"
//        if Checking.startIsEnd {
//            didLoop = "true"
//        }
        let didLoop = Checking.startIsEnd ? "true" : "false"
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(readings)
            let newReadings = String(data: data, encoding: .utf8)!
            
            uploadTour(videoData: videos, readings: newReadings, title: title, description: description, didLoop: didLoop)

        } catch {
            print(error)
        }
        
    }
    
    func uploadTour(videoData: [Data], readings: String, title: String, description: String, didLoop: String) {
        let request = MultipartFormDataRequest(url: URL(string: "https://meta-tour.herokuapp.com/upload-data")!)
        request.addTextField(named: "readings", value: readings)
        request.addTextField(named: "title", value: title)
        request.addTextField(named: "description", value: description)
        request.addTextField(named: "did-loop", value: didLoop)

        
        for i in 0...videoData.count-1 {
            request.addDataField(named: "video\(i)", data: videoData[i], mimeType: "video/mp4")
        }
//        print("this is THE DATA", videoData[0], " RIGHT HERE")
//        request.addDataField(named: "video", data: videoData[0], mimeType: "video/mp4")

        
        //video/mp4
        URLSession.shared.dataTask(with: request) { data, _, error  in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                print("Success: \(data)")
            }
        }.resume()
    }
}

