//
//  StudyManager.swift
//  PlanoDeEstudos
//
//  Created by Pedro Silva Dos Santos on 02/09/2019.
//  Copyright © 2019 Eric Brito. All rights reserved.
//

import Foundation
import UserNotifications

//Gerenciamento dos estudos
class StudyManager {
    //singleton
    static let shared = StudyManager()
    let ud = UserDefaults.standard //será usado para persistir os dados e recuperar os planos que o usuario cadastrou
    var studyPlans: [StudyPlan] = []
    var keyValuePlans: String = "studyPlans"
    
    private init() {
        //se existir alguma coisa nessa chave, pego e decodifico no array StudyPlan
        if let data = ud.data(forKey: keyValuePlans),
            let plans = try? JSONDecoder().decode([StudyPlan].self, from: data) {
            //se tudo acima der certo, self.studyPlans = plans
            self.studyPlans = plans
        }
    }
    
    //senao houver nenhum plano criado
    func savePlans() {
        //metodo para persistir
        //converter studyPlans em data
        if let data = try? JSONEncoder().encode(studyPlans) {
            ud.set(data, forKey: keyValuePlans)
        }
    }
    
    func addPlan(_ studyPlan: StudyPlan) {
        studyPlans.append(studyPlan)
        savePlans()
    }
    
    func removePlan(index: Int) {
        //remove as pendencias do usuario com o id especifico
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [studyPlans[index].id])
        studyPlans.remove(at: index)
        savePlans()
    }
    
    func setPlanDone(id: String) {
        
        //vai no array e pega o primeiro elemento id
        //Depois verificar  se o Id resgatado, é igual ao ultimo id que foi enviado
        if let studyPlan = studyPlans.first(where: {$0.id == id}){
            studyPlan.done = true //agora tenho a atividade marcada como feita
            savePlans()
        }
    }
}
