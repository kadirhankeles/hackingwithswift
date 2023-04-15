//
//  DetailViewController.swift
//  Project-07
//
//  Created by Kadirhan Keles on 13.04.2023.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: PetitionModel?
    
    override func loadView() {
           webView = WKWebView()
           view = webView
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        let html = """
        <html>
        <head>
            <title>Başlık</title>
            <style>
                body {
                    margin: 0 2em;
                }

                h1 {
                    text-align: center;
                    font-weight: bold;
                    font-size: 40pt;
                }

                p {
                    font-size: 30pt;
                }
            </style>
        </head>
        <body>
            <h1>\(detailItem.title)</h1>
            <p>\(detailItem.body)</p>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        
    }
    

   

}
