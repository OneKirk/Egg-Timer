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
    var cookingTimes = [[5, 10, 15], [5, 10, 15], [5, 10, 15], [5, 10, 15]] // Delete before deployment

    // Outlets
    @IBOutlet weak var eggSizeSelector: UISegmentedControl!
    @IBOutlet weak var eggCookingSelector: UISegmentedControl!
    
    // IBActions
    @IBAction func eggSizeSelected(_ sender: Any) {
        userEggSizeSelected = eggSizeSelector.selectedSegmentIndex
    }
    
    @IBAction func eggCookingSelected(_ sender: Any) {
        userEggCookingSelected = eggCookingSelector.selectedSegmentIndex
    }
    
    @IBAction func nextButton(_ sender: Any) {
        
        userSelectedTime = cookingTimes[userEggSizeSelected][userEggCookingSelected]
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "TimerViewController") as! TimerViewController
        myVC.userSelectedTime = userSelectedTime
        navigationController?.pushViewController(myVC, animated: true)
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

