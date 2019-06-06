//
//  HistoryViewController.swift
//  someapp
//
//  Created by User on 04/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreData

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunCell") as! HistoryTableViewCell
        let run = runs[indexPath.row]
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let intervalFormatter = DateComponentsFormatter()
            intervalFormatter.allowedUnits = [.hour, .minute, .second]
            intervalFormatter.zeroFormattingBehavior = .pad
            
            cell.valueLabel?.text = intervalFormatter.string(from: TimeInterval(run.duration * 60))
            break
        case 1:
            cell.valueLabel?.text = String(run.distance) + " km"
            break
        case 2:
            cell.valueLabel?.text = String(format: "%.1f km/h", run.speed)
            break
        case 3:
            cell.valueLabel?.text = String(run.calories) + " cal"
            break
        default:
            break
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        cell.dateLabel.text = formatter.string(from: (run.date as Date?) ?? Date())
        
        return cell
    }
    
    
}

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var runs = [Run]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Run")
        
        do {
            runs = try context.fetch(fetchRequest) as! [Run]
        }
        catch let error as NSError {
            print("Data loading error: \(error)")
        }
        
        runs.sort(by: { $0.date!.compare($1.date! as Date) == .orderedAscending ? true : false })
        
        self.tableView.reloadData()
        
    }

    @IBAction func changeMetric(_ sender: Any) {
        self.tableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
