//
//  AboutUSViewController.swift
//  Aim for that 2017
//
//  Created by Moisés Córdova on 12/11/17.
//  Copyright © 2017 Moisés Córdova. All rights reserved.
//

import UIKit

class AboutUSViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWebView()
    }
    
    func loadWebView() {
        if let url = Bundle.main.url(forResource: "AimForThat", withExtension: "html") {
            print(url)
            
            let baseURL = URL(fileURLWithPath: Bundle.main.bundlePath)
            
            if let htmlData = try? Data(contentsOf: url){
                self.webView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseURL)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed() {
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
