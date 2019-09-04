//
//  AppDelegate.swift
//  PlanoDeEstudos
//
//  Created by Eric Brito
//  Copyright © 2017 Eric Brito. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window?.tintColor = UIColor(named: "main")
        
        //o meu appDelegate será o responsavel
        center.delegate = self
        
        //verificando como esta o estatus das notificaficacoes
        //obetendo os status
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined { //nao pedir a autorizacao para o usuario ainda
                //vamos pedi agora
                let option = UNAuthorizationOptions.alert //serve para definir qual o tipo de notificao
                self.center.requestAuthorization(options: option, completionHandler: { (sucess, error) in
                    if error == nil {
                        print("sucesso notificacao enviada", sucess)
                    } else {
                        print(error!.localizedDescription)
                    }
                })
            } else if settings.authorizationStatus == .denied {
                print("Usuario negou a notificao!!!") //inserir as melhorias
            }
        }
        
        //verificar se trabalha com botoes de acesso
        //botao de confirmaco
        let confirmAction = UNNotificationAction(identifier: "Confirm", title: "Já estudei", options: [.foreground]) //clicando o app é acordado
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancelar", options: [])
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction,cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction]) //se o usuario ignorar eu consigo pegar esse comportamento
        center.setNotificationCategories([category])
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //aqui pegamos a notificacao com o app aberto
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //mesmo o app aberto vou pode visualizar
        completionHandler([.alert, .badge, .sound])
    }
    
    //É disparado quando o usuario recebe a notificacao
    //Conseguimos pegar a acao que ele clicou
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive response")
        let id = response.notification.request.identifier
        print("Numero do identifier", id)
        switch response.actionIdentifier {
        case "Confirm":
            print("Usuário confirmou que ja estou a mateira")
            //estou enviando um aviso que a minha notificacao foi tratada, para quem quisder ouvir
            NotificationCenter.default.post(name: NSNotification.Name("Confirmed"), object: nil, userInfo: ["id":id])
        case "Cancel":
            print("Usuário cancelou a mateira")
        case UNNotificationDefaultActionIdentifier:
            print("Usuário tocou na propria notificao")
        case UNNotificationDismissActionIdentifier:
            print("Usuário fez um dismiss na notificao, nem olhou")
        default:
            break
        }
        completionHandler()
    }
}
