//
//  ProductiveViewController.swift
//  Hourglass
//
//  Created by Caroline Zhou and Tao Ong on 11/28/17.
//  Copyright © 2017 Caroline Zhou and Tao Ong. All rights reserved.
//

import UIKit
import Lottie

class ProductiveViewController: UIViewController {
    
    var model : Hourglass!
    var currentTask = ""
    
    var timer = Timer()
    var isPlaying = false
    
    
    var animationView = LOTAnimationView(name: "hourglass")
    var imageRect = CGRect(x: 93, y: 250, width: 500, height: 300)
    
    var done = LOTAnimationView(name: "done")
    var doneRect = CGRect(x: 153, y: 507, width: 70, height: 70)
    
    
    @IBOutlet weak var currentActivity: UILabel!
    @IBOutlet weak var productiveOrNot: UILabel!
    var productiveOrNotText = "Being productive"
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var currActivityLabel: UILabel!
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    @objc func UpdateTimer() {
        if self.model.productive {
            self.model.totalProductiveCounter += 0.1
            self.model.productiveCounter += 0.1
            timerLabel.text = String(format: "%.1f", self.model.totalProductiveCounter)
            if self.model.totalProductiveCounter.rounded(.towardZero).truncatingRemainder(dividingBy: 30) == 0 && self.model.productiveCounter > 1 {
                self.model.productiveCounter = 0
                self.model.numTreesGrown += 1
                animationView.stop()
                animationView = LOTAnimationView(name: "hourglass2")
                prepareAnimation()
                animationView.play()
                done.removeFromSuperview()
            }
            
            
            if var activities = UserDefaults.standard.value(forKey: "activities") as? Dictionary<String, Double> {
                let counter = self.model.totalProductiveCounter
                activities.updateValue(counter, forKey: self.currentTask)
                self.model.activities = activities
                UserDefaults.standard.set(self.model.activities, forKey: "activities")
                print(activities)
            }
            if self.model.productiveCounter > 9 && self.model.productiveCounter < 9.1 {
                animationView.stop()
                animationView = LOTAnimationView(name: "hourglass3")
                prepareAnimation()
                animationView.play()
            } else if self.model.productiveCounter > 18 && self.model.productiveCounter < 18.1 {
                animationView.stop()
                animationView = LOTAnimationView(name: "hourglass4")
                prepareAnimation()
                animationView.play()
            } else if self.model.productiveCounter > 27 && self.model.productiveCounter < 27.1 {
                animationView.stop()
                animationView = LOTAnimationView(name: "hourglass5")
                prepareAnimation()
                self.view.addSubview(done)
                done.play()
            }
            
        
        } else if self.model.unproductive {
            self.model.unproductiveCounter += 0.1
            timerLabel.text = String(format: "%.1f", self.model.unproductiveCounter)
            
            if var activities = UserDefaults.standard.value(forKey: "activities") as? Dictionary<String, Double> {
                let counter = self.model.unproductiveCounter
                activities.updateValue(counter, forKey: self.currentTask)
                self.model.activities = activities
                UserDefaults.standard.set(self.model.activities, forKey: "activities")
                print(activities)
            }
        }
    }
    
    @IBAction func startTimer(_ sender: AnyObject) {
        if(isPlaying) {
            return
        }
        startButton.isEnabled = false
        pauseButton.isEnabled = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
        isPlaying = true
        animationView.loopAnimation = true
        animationView.play()
    }
    
    @IBAction func pauseTimer(_ sender: AnyObject) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        isPlaying = false
        animationView.loopAnimation = false
        
        
    }
    
    @IBAction func resetTimer(_ sender: AnyObject) {
        startButton.isEnabled = true
        pauseButton.isEnabled = false
        
        timer.invalidate()
        isPlaying = false
        animationView.stop()
        if self.model.productive {
            self.model.totalProductiveCounter = 0.0
            self.model.productiveCounter = 0.0
            timerLabel.text = String(self.model.totalProductiveCounter)
            animationView = LOTAnimationView(name: "hourglass2")
        } else if self.model.unproductive {
            self.model.unproductiveCounter = 0.0
            timerLabel.text = String(self.model.unproductiveCounter)
            animationView = LOTAnimationView(name: "hourglass")
        }
        prepareAnimation()
    }
    
    @IBAction func switchTimer(_ sender: AnyObject) {
        if (self.model.productive) {
            self.timer.invalidate()
            resetTimer(sender)
            self.model.unproductive = true
            self.model.productive = false
            self.model.productiveCounter = 0.0
            self.model.totalProductiveCounter = 0.0
            productiveOrNot.text = "Unproductive"
            productiveOrNot.textColor = UIColor.white
            timerLabel.textColor = UIColor.white
            currActivityLabel.textColor = UIColor.white
            animationView = LOTAnimationView(name: "hourglass")
        }
        else if (self.model.unproductive) {
            self.timer.invalidate()
            resetTimer(sender)
            self.model.unproductive = false
            self.model.productive = true
            self.model.unproductiveCounter = 0.0
            productiveOrNot.text = "Productive"
            productiveOrNot.textColor = UIColor.black
            timerLabel.textColor = UIColor.black
            currActivityLabel.textColor = UIColor.black
            animationView = LOTAnimationView(name: "hourglass2")
        }
        
        self.currentActivity.text = ""
        prepareAnimation()
        drawButtons()
        
        startButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode = .scaleAspectFit
        pauseButton.imageView?.contentMode = .scaleAspectFit
        
        let alert = UIAlertController(title: "Alert", message: "Input Intended Task or Activity", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
            self.currentTask = (alert?.textFields![0].text!)!      // alert.textFields![0].text! is the input text from the textfield in the alert
            if let activities = UserDefaults.standard.value(forKey: "activities") as? Dictionary<String, Double> {
                self.model.activities = activities
            }
            self.currentActivity.text = self.currentTask
            self.model.currentActivity = self.currentTask
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "E.g. Studying for biology midterm"
            // textField.isSecureTextEntry = true     // for password input
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func prepareAnimation() {
        animationView.frame = imageRect
        animationView.contentMode = .scaleAspectFill
        animationView.loopAnimation = true
        animationView.animationSpeed = 0.9
        self.view.addSubview(animationView)
    }
    
    func drawButtons() {
        // Set correct bg image and buttons
        if self.model.productive {
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "productive")?.draw(in: self.view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
            startButton.setImage(UIImage(named: "play.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            startButton.imageView?.contentMode = .scaleAspectFit
            // startButton.imageEdgeInsets = UIEdgeInsetsMake(15.0, 15.0, 15.0, 5.0)
            stopButton.setImage(UIImage(named: "stop.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            stopButton.imageView?.contentMode = .scaleAspectFit
            pauseButton.setImage(UIImage(named: "pause.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            pauseButton.imageView?.contentMode = .scaleAspectFit
            switchButton.setImage(UIImage(named: "good.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if self.model.unproductive {
            UIGraphicsBeginImageContext(self.view.frame.size)
            UIImage(named: "unproductive")?.draw(in: self.view.bounds)
            let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            self.view.backgroundColor = UIColor(patternImage: image)
            
            startButton.setImage(UIImage(named: "play.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            stopButton.setImage(UIImage(named: "stop.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            pauseButton.setImage(UIImage(named: "pause.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
            switchButton.setImage(UIImage(named: "bad.png")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pauseButton.isEnabled = false
        
        if self.model.productive {
            animationView = LOTAnimationView(name: "hourglass2")
            timerLabel.text = String(self.model.totalProductiveCounter)
        } else {
            animationView = LOTAnimationView(name: "hourglass")
            timerLabel.text = String(self.model.unproductiveCounter)
            productiveOrNot.textColor = UIColor.white
            timerLabel.textColor = UIColor.white
            currActivityLabel.textColor = UIColor.white
        }
        prepareAnimation()
        done.frame = doneRect
        done.contentMode = .scaleAspectFill
        self.view.addSubview(done)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.productiveOrNot.text = self.productiveOrNotText
        self.timer.invalidate()
        
        drawButtons()
        startButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode = .scaleAspectFit
        pauseButton.imageView?.contentMode = .scaleAspectFit
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Activity tracking logic. First presents an alert asking user to input task s/he is working on. Then stores mappings of task to time spent on task in a dictionary that is locally persistent.
        
        currActivityLabel.text = self.model.currentActivity
        
        if self.model.productive && self.model.totalProductiveCounter == 0 || self.model.unproductive && self.model.unproductiveCounter == 0 {
            self.currentActivity.text = ""
            let alert = UIAlertController(title: "Alert", message: "Input Intended Task or Activity", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
                self.currentTask = (alert?.textFields![0].text!)!      // alert.textFields![0].text! is the input text from the textfield in the alert
                if let activities = UserDefaults.standard.value(forKey: "activities") as? Dictionary<String, Double> {
                    self.model.activities = activities
                }
                self.currentActivity.text = self.currentTask
                self.model.currentActivity = self.currentTask
            }))
            alert.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "E.g. Studying for biology midterm"
                // textField.isSecureTextEntry = true     // for password input
            })
            self.present(alert, animated: true, completion: nil)
        }
        
        if self.model.productive && self.model.productiveCounter == 0 {
            timerLabel.text = String(self.model.totalProductiveCounter)
        } else if self.model.unproductive && self.model.unproductiveCounter == 0 {
            productiveOrNot.textColor = UIColor.white
            timerLabel.textColor = UIColor.white
            currActivityLabel.textColor = UIColor.white
        }
        
        if self.model.productive {
            timerLabel.text = String(self.model.totalProductiveCounter)
        } else {
            timerLabel.text = String(self.model.unproductiveCounter)
        }
        
        
        
        
//        Use this for tracking number of times user began working on a task
//        if var result = UserDefaults.standard.value(forKey: "activities") as? Dictionary<String, Int> {
//            if let oldValue = result.updateValue(1, forKey: alert.textFields![0].text!) {
//                result.updateValue(oldValue + 1, forKey: alert.textFields![0].text!)
//            }
//        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        isPlaying = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
