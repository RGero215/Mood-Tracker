//
//  ViewController.swift
//  Mood-Tracker
//
//  Created by Ramon Geronimo on 11/18/18.
//  Copyright © 2018 Ramon Geronimo. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
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
        
        if WCSession.isSupported(){
            WCSession.default.delegate = self
            WCSession.default.activate()
        }

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
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print("Error: \(error)")
        }else{
            print("Ready to communicate with apple watch.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("Deactivated")
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            print("This is the user info \(userInfo)")
            
            guard let mood = userInfo["mood"] as? String, let date =  userInfo["date"] as? Date else{ return}
            let newEntry : MoodEntry!
            
            switch mood {
            case "Amazing":
                newEntry = MoodEntry(mood: .amazing, date: date)
            case "Good":
                newEntry = MoodEntry(mood: .good, date: date)
            case "Bad":
                newEntry = MoodEntry(mood: .bad, date: date)
            case "Terrible":
                newEntry = MoodEntry(mood: .terrible, date: date)
            case "Neutral":
                newEntry = MoodEntry(mood: .neutral, date: date)
            default:
                return
            }
            
            self.entries.append(newEntry)
            self.tableView.reloadData()
        }
        
    }
    
}

