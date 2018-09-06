//
//  AppDelegate.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 2..
//  Copyright © 2018년 김종서. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        customizeNavigationBar()
        injectEnvironment()
        return true
    }
    
    private func injectEnvironment() {
        if
            let navigationController = window?.rootViewController as?
            UINavigationController,
            
            let timelineViewController = navigationController.topViewController as?
            TimelineViewController {

            let repository = FirebaseEntryRepository()
            
            let env = Environment(
                entryRepository: repository,
                settings: UserDefaults.standard
            )
            
//            print(Realm.Configuration.defaultConfiguration.fileURL!) // realm 파일의 경로 찾기
            
            timelineViewController.viewModel = TimelineViewViewModel(environment: env
            )
        }
    }
    
    private func customizeNavigationBar() {
        if let navigationController = window?.rootViewController as? UINavigationController{
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.navigationBar.barStyle = .black
            navigationController.navigationBar.tintColor = UIColor.white
            
            let bgImage = UIImage.gradientImage(with: [.gradientStart, .gradientEnd], size: CGSize(width: UIScreen.main.bounds.width, height: 1))
            navigationController.navigationBar.barTintColor = UIColor(patternImage: bgImage!)
        }
    }
}

