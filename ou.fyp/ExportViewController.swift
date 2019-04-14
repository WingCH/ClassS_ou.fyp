//
//  ExporViewController.swift
//  ou.fyp
//
//  Created by Chan Hong Wing on 11/4/2019.
//  Copyright © 2019 Chan Hong Wing. All rights reserved.
//

import UIKit

class ExportViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func export(_ sender: UIButton) {
        
        //https://medium.com/@ji3g4kami/download-store-and-view-pdf-in-swift-af399373b451
        guard let url = URL(string: "https://us-central1-ouhkface-89b5c.cloudfunctions.net/exportExcel") else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
}

extension ExportViewController:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard (downloadTask.originalRequest?.url) != nil else { return }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let destinationURL = documentsPath.appendingPathComponent("attendance.csv")
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            print(destinationURL)
            
            //https://stackoverflow.com/a/55092044/10999568
            // Create the Array which includes the files you want to share
            var filesToShare = [Any]()
            
            // Add the path of the file to the Array
            filesToShare.append(destinationURL)
            
            // Make the activityViewContoller which shows the share-view
            let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
            
           
            DispatchQueue.main.async {
                // Show the share-view
                self.present(activityViewController, animated: true, completion: nil)
            }
            
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
