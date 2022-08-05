//
//  ViewController.swift
//  Final Project App
//
//  Created by Pablo Segovia on 7/20/22.
//

import UIKit

class InitialVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var button: UIButton!
    
    //when the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print("this data: ", BRUH.BRUH)
        
        //if a tour has just been completed
        if Checking.goHome == true {
            Checking.goHome = false
            upload() //to the backend
            
            //reset everything
            BRUH.BRUH = [[[]]]
            BRUH.videos = []
            BRUH.title = ""
            
            self.performSegue(withIdentifier: "goPopUp", sender: self)
        }
        
    }
    
    //when the view has loaded for the first time
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //a few UI changes
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.cornerRadius = button.frame.size.height / 5
    }
    
    //when start button is pressed go to the next scene
    @IBAction func startPressed(_ sender: UIButton) {
        //resest some variables just in case
        BRUH.BRUH = []
        Checking.goHome = false
        Checking.startIsEnd = false
        Checking.videoRecorded = false
        BRUH.title = ""
    }
    
    func upload() {
        
        //when uploading set some new variables to previously saved variables
        let readings = BRUH.BRUH
        let videos = BRUH.videos
        let title = BRUH.title
        let description = "Not ready"
        let didLoop = Checking.startIsEnd ? "true" : "false"
        
        // set up JSON encoder
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        //catching errors
        do {
            // encode the data
            let data = try encoder.encode(readings)
            let newReadings = String(data: data, encoding: .utf8)!
            
            uploadTour(videoData: videos, readings: newReadings, title: title, description: description, didLoop: didLoop)

        } catch {
            print(error)
        }
        
    }
    
    func uploadTour(videoData: [Data], readings: String, title: String, description: String, didLoop: String) {
        // create POST request
        let request = MultipartFormDataRequest(url: URL(string: "https://meta-tour.herokuapp.com/upload-data")!)
        
        //add all the String variables to the request as textfields
        request.addTextField(named: "readings", value: readings)
        request.addTextField(named: "title", value: title)
        request.addTextField(named: "description", value: description)
        request.addTextField(named: "did-loop", value: didLoop)

        //add each video to the request as data
        for i in 0...videoData.count-1 {
            request.addDataField(named: "video\(i)", data: videoData[i], mimeType: "video/mp4")
        }
//        print("this is THE DATA", videoData[0], " RIGHT HERE")
//        request.addDataField(named: "video", data: videoData[0], mimeType: "video/mp4")

        //upload the data with 'request'
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

