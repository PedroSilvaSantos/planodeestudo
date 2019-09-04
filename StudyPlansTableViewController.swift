//
//  NotificationsTableViewController.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit

class StudyPlansTableViewController: UITableViewController {

    let sm = StudyManager.shared
    
    //formatar a data
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy HH:mm"
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Escutando a notificacao que foi criada no appDelegate
        NotificationCenter.default.addObserver(self, selector: #selector(onReceive(notification:)), name: NSNotification.Name(rawValue: "Confirmed"), object: nil)
    }
    
    @objc func onReceive(notification: Notification) {
        if let userInfo = notification.userInfo, let id = userInfo["id"] as? String {
            sm.setPlanDone(id: id)
             tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sm.studyPlans.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let studyPlan = sm.studyPlans[indexPath.row]
        cell.textLabel?.text = studyPlan.section //assunto
        cell.detailTextLabel?.text = dateFormatter.string(from: studyPlan.date) //pego a minha data e formato no valor aceitavel
        cell.backgroundColor = studyPlan.done ? .green : .white
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sm.removePlan(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
            tableView.reloadData()
        }
    }
}
