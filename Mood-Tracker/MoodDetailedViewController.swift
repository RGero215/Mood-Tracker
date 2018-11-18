//
//  MoodDetailedViewController.swift
//  Mood-Tracker
//
//  Created by Ramon Geronimo on 11/18/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class MoodDetailedViewController: UIViewController {
    var date: Date!
    var mood: MoodEntry.Mood!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(date, mood)
    }
}
