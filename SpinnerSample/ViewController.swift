//
//  ViewController.swift
//  SpinnerSample
//
//  Created by Rajesh  on 02/09/25.
//

import UIKit

class ViewController: UIViewController {
    private var rsSpinnerView : RSSpinnerView?

    @IBOutlet weak var segmentSelector: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rsSpinnerView = RSSpinnerView(spinnerType: .small, spinnerColor: .dark, onView: self.view)

        // Do any additional setup after loading the view.
    }

    @IBAction func segmentEvent(_ sender: Any) {
        guard let segmentController = sender as? UISegmentedControl else { return  }
        switch segmentController.selectedSegmentIndex{
        case 0:
            self.rsSpinnerView?.addSpinner()
            self.view.bringSubviewToFront(self.segmentSelector)
        case 1:
            self.rsSpinnerView?.removeSpinner()
        default:
            self.rsSpinnerView?.removeSpinner()
        }
    }
    
}

