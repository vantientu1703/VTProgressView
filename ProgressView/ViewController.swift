//
//  ViewController.swift
//  ProgressView
//
//  Created by Van Tien Tu on 04/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: ProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.progressView.progress = 30
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

