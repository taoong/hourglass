//
//  ViewController.swift
//  Hourglass
//
//  Created by Tao Ong and Caroline Zhou on 11/23/17.
//  Copyright © 2017 Tao Ong and Caroline Zhou. All rights reserved.
//


import UIKit

class HomeViewController: UIViewController {

    var model : Hourglass!
    var pressID : Int?
    
    @IBOutlet weak var numTrees: UILabel!
    @IBOutlet weak var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.model = Hourglass()
        
        // Load background image
        UIGraphicsBeginImageContext(self.view.frame.size)
        UIImage(named: "homescreen")?.draw(in: self.view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.numTrees.text = String(model.numTreesGrown)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func toProductive(sender: UIButton) {
        self.pressID = sender.tag
        performSegue(withIdentifier: "segue", sender: sender)
    }
    
    @IBAction func toUnproductive(sender: UIButton) {
        self.pressID = sender.tag
        performSegue(withIdentifier: "segue", sender: sender)
    }
    
    @IBAction func toActivityTracker(_ sender: Any) {
        performSegue(withIdentifier: "segueToActivityTracker", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "segue" {
                if let dest = segue.destination as? ProductiveViewController {
                    if self.pressID == 0 {  // productive button was pressed
                        if self.model.unproductive {
                            self.model.productiveCounter = 0.0
                        }
                        dest.productiveOrNotText = "Productive"
                        self.model.productive = true
                        self.model.unproductive = false
                        self.model.unproductiveCounter = 0.0
                    } else if self.pressID == 1 {   // unproductive button was pressed
                        if self.model.productive {
                            self.model.unproductiveCounter = 0.0
                        }
                        dest.productiveOrNotText = "Unproductive"
                        self.model.unproductive = true
                        self.model.productive = false
                        self.model.productiveCounter = 0.0
                    }
                    dest.model = self.model
                }
            } else if identifier == "segueToActivityTracker" {
                if let dest = segue.destination as? ActivityTrackerViewController {
                    // nothing needs to be done, at least as of rn
                }
            }
        }
    }

}

