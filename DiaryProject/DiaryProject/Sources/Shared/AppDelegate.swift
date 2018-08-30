//
//  AppDelegate.swift
//  DiaryProject
//
//  Created by 김종서 on 2018. 8. 2..
//  Copyright © 2018년 김종서. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
            //            timelineViewController.environment = Environment()
            
            let entries: [Entry] = [ // 어제
                Entry(createdAt: Date.before(1), text: "어제 일기"), Entry(createdAt: Date.before(1), text: "어제 일기"), Entry(createdAt: Date.before(1), text: "어제 일기"),
                // 2일 전
                Entry(createdAt: Date.before(2), text: "2일 전 일기"), Entry(createdAt: Date.before(2), text: "2일 전 일기"), Entry(createdAt: Date.before(2), text: "2일 전 일기"), Entry(createdAt: Date.before(2), text: "2일 전 일기"), Entry(createdAt: Date.before(2), text: "2일 전 일기"), Entry(createdAt: Date.before(2), text: "2일 전 일기"),
                // 3일 전
                Entry(createdAt: Date.before(3), text: "3일 전 일기"), Entry(createdAt: Date.before(3), text: "3일 전 일기")
            ]
            
            let repository = InMemoryEntryRepository(entries: entries)
            let env = Environment(entryRepository: repository)
            
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

