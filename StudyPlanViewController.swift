//
//  StudyViewController.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.

import UIKit
import UserNotifications

class StudyPlanViewController: UIViewController {

    @IBOutlet weak var tfCourse: UITextField!
    @IBOutlet weak var tfSection: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    
    let sm = StudyManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pegando a Date desse momento e setando como data minima
        dpDate.minimumDate = Date()
        
    }

    //plano de estudo cadastrado
    @IBAction func schedule(_ sender: UIButton) {
        let id = String(Date().timeIntervalSince1970)
        print("Descricao do campo ID", id)
        let studyPlan = StudyPlan(course: tfCourse.text!, section: tfSection.text!, date: dpDate.date, done: false, id: id)
        
        //criando as notificao
        let content = UNMutableNotificationContent()
        content.title = "Lembrete"
        content.subtitle = "Matéria: \(studyPlan.course)"
        content.body = "Estudar \(studyPlan.section)"
        
        //content.sound = UNNotificationSound(named: "arquivodesom.caf") //caf extensao de som mais leve
        content.categoryIdentifier = "Lembrete"
        //momento que será disparado trigger (data fixa/ localização/ )
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false) //nao repita
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dpDate.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //requisica do notificacao - id (identificasdor unico para notificao diferente)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil) //adicionei minha notificacao
        
        //plano adicionado
        sm.addPlan(studyPlan)
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}
