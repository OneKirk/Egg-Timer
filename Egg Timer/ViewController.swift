//
//  ViewController.swift
//  Egg Timer
//
//  Created by Thomas Kirk on 17/12/2017.
//  Copyright © 2017 OneKirk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Variable declaration
    var userSelectedTime: Int = 0
    var userEggSizeSelected: Int = 0
    var userEggCookingSelected: Int = 0
    var cookingTimes = [[300, 390, 480], [330, 420, 510], [360, 450, 540], [390, 480, 570]]

    // Outlets
    @IBOutlet weak var eggSizeSelector: UISegmentedControl!
    @IBOutlet weak var eggCookingSelector: UISegmentedControl!
    
    // IBActions
    @IBAction func eggSizeSelected(_ sender: Any) {
        userEggSizeSelected = eggSizeSelector.selectedSegmentIndex
        setUserSelectedTime()
    }
    
    @IBAction func eggCookingSelected(_ sender: Any) {
        userEggCookingSelected = eggCookingSelector.selectedSegmentIndex
        setUserSelectedTime()
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEggSizeSelected = eggSizeSelector.selectedSegmentIndex
        userEggCookingSelected = eggCookingSelector.selectedSegmentIndex
        setUserSelectedTime()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimer" {
            
            if let timerViewController = segue.destination as? TimerViewController {
                
                timerViewController.userSelectedTime = userSelectedTime
            }
        }
    }
    
    func setUserSelectedTime() {
        userSelectedTime = cookingTimes[userEggSizeSelected][userEggCookingSelected]
    }
    
}
