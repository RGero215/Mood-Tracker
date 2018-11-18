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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "show new entry":
                guard let entryDetailsViewController = segue.destination as? MoodDetailedViewController else {
                    
                    //NOTE: error handling
                    return print("storyboard not set up correctly, 'show entry details' segue needs to segue to a 'MoodDetailedViewController'")
                }
                
                entryDetailsViewController.mood = MoodEntry.Mood.none
                entryDetailsViewController.date = Date()
            case "show entry details":
                guard
                    let selectedCell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: selectedCell) else {
                        return print("failed to locate index path from sender")
                }
                
                guard let entryDetailsViewController = segue.destination as? MoodDetailedViewController else {
                    return print("storyboard not set up correctly, 'show entry details' segue needs to segue to a 'MoodDetailedViewController'")
                }
                
                let entry = entries[indexPath.row]
                entryDetailsViewController.mood = entry.mood
                entryDetailsViewController.date = entry.date
                entryDetailsViewController.isEditingEntry = true
                
            default: break
            }
        }
    }
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else {
            return
        }
        
        guard let detailedEntryViewController = segue.source as? MoodDetailedViewController else {
            return print("storyboard unwind segue not set up correctly")
        }
        
        switch identifier {
        case "unwind from save":
            if detailedEntryViewController.isEditingEntry {
                print("from save button and editing an existing entry")
            } else {
                print("from save button and adding a new entry")
            }
        case "unwind from cancel":
            print("from cancel button")
        default:
            break
        }
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

