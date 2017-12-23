//
//  ViewController.swift
//  Aim for that 2017
//
//  Created by Moisés Córdova on 19/11/17.
//  Copyright © 2017 Moisés Córdova. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    
    var currentValue : Int = 50
    var targetValue  : Int = 0
    var score        : Int = 0
    var round        : Int = 0
    var time         : Int = 0
    var timer        : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetGame()
        self.updateLabels()
    }
    
    func stepupSlider(){
        let thumbImageNormal = #imageLiteral(resourceName: "SliderThumb-Normal")
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        let trackLeftImage = #imageLiteral(resourceName: "SliderTrackLeft")
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        
        self.slider.setThumbImage(thumbImageNormal, for: .normal)
        self.slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        let insets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        
        let trackLeftResizable = trackLeftImage.resizableImage(withCapInsets: insets)
        
        let trackRightResizable = trackRightImage.resizableImage(withCapInsets: insets)
        
        self.slider.setMinimumTrackImage(trackLeftResizable, for: .normal)
        self.slider.setMinimumTrackImage(trackRightResizable, for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        
        let difference : Int = abs(self.currentValue - self.targetValue)
        
        var points = 100 - difference
        
        let title : String
        
        switch difference {
        case 0:
            title = "Puntuación Perfecta!"
            points = Int(10.0 * Float(points))
        case 1...5:
            title = "Casi Perfecto!"
            points = Int(1.5 * Float(points))
        case 6...12:
            title = "Te ha faltado poco"
            points = Int(1.2 * Float(points))
        default:
            title = "Te has ido lejos..."
        }
        
        let message =  "Has marcado \(points)"
        
        self.score += points
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        let action = UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.startNewRound()
        })
        alert.addAction(action)
    }
    
    func startNewRound() {
        self.targetValue = 1 + Int(arc4random_uniform(100))
        self.currentValue = Int(slider.value)
        self.round += 1
        updateLabels()
    }
    
    func updateLabels() {
        self.targetLabel.text = "\(self.targetValue)"
        self.scoreLabel.text = "\(self.score)"
        self.roundLabel.text = "\(self.round)"
        self.timeLabel.text = "\(self.time)"
        transition()
    }
    
    @IBAction func startNewGame(){
        resetGame()
        updateLabels()
        transition()
    }
    
    func transition() {
        let transition = CATransition()
        transition.type = kCATransitionFade
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.view.layer.add(transition, forKey: nil)
    }
    
    func resetGame(){
        var maxscore = UserDefaults.standard.integer(forKey: "maxscore")
        if maxscore < self.score {
            maxscore = self.score
            UserDefaults.standard.set(maxscore, forKey: "maxscore")
        }
        self.maxScoreLabel.text = "\(maxscore)"
        
        self.score = 0
        self.round = 0
        self.time = 60
        
        if timer != nil {
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        self.updateLabels()
        self.startNewRound()
    }
    
    func showFinalPuntuaction() {
        self.timer?.invalidate()
        let message = "Tu puntuación final fue de \(self.score)"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (resetGame) in
            self.resetGame()
        })
        alert.addAction(action)
    }
    
    @objc func tick() {
        self.time -= 1
        self.timeLabel.text = "\(self.time)"
        if self.time <= 0 {
            self.showFinalPuntuaction()
        }
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        self.currentValue = Int(sender.value)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
