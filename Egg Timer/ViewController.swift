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
    var userSelectedTime = 0
    var userEggSizeSelected = 0
    var userEggCookingSelected = 0
    // var cookingTimes = [[300, 390, 480], [330, 420, 510], [360, 450, 540], [390, 480, 570]]
    var cookingTimes = [[5, 15, 30], [5, 15, 30], [5, 15, 30], [5, 15, 30]] // Delete before deployment

    // Outlets
    @IBOutlet weak var eggSizeSelector: UISegmentedControl!
    @IBOutlet weak var eggCookingSelector: UISegmentedControl!
    
    // IBActions
    @IBAction func eggSizeSelected(_ sender: Any) {
        userEggSizeSelected = eggSizeSelector.selectedSegmentIndex
        userSelectedTime = cookingTimes[userEggSizeSelected][userEggCookingSelected]
    }
    
    @IBAction func eggCookingSelected(_ sender: Any) {
        userEggCookingSelected = eggCookingSelector.selectedSegmentIndex
        userSelectedTime = cookingTimes[userEggSizeSelected][userEggCookingSelected]
    }
    
    @IBAction func nextButton(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTimer" {
            let timerViewController = segue.destination as! TimerViewController
            
            timerViewController.userSelectedTime = userSelectedTime
        }
    }
    
    // Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userEggSizeSelected = eggSizeSelector.selectedSegmentIndex
        userEggCookingSelected = eggCookingSelector.selectedSegmentIndex
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

