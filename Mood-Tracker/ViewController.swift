//
//  ViewController.swift
//  Mood-Tracker
//
//  Created by Ramon Geronimo on 11/18/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var entries: [MoodEntry] = []
    
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let goodEntry = MoodEntry( mood:.good, date: Date())
        let badEntry = MoodEntry( mood:.bad, date: Date())
        let neutralEntry = MoodEntry( mood:.neutral, date: Date())
        
        entries = [goodEntry, badEntry, neutralEntry]
        tableView.reloadData()
    }
    @IBAction func pressAddEntry(_ sender: UIBarButtonItem) {
        let now = Date()
        let newMood = MoodEntry(mood: .amazing, date: now)
        entries.insert(newMood, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mood entry cell", for: indexPath) as! MoodEntryTableViewCell
        let entry = entries[indexPath.row]
        cell.labelMoodTitle.text = entry.mood.stringValue
        cell.imageViewMoodColor.backgroundColor = entry.mood.colorValue
        cell.labelMoodDate.text = String(describing: entry.date)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEntry = entries[indexPath.row]
        print("Selected mood was \(selectedEntry.mood.stringValue)")
    }
    
}

