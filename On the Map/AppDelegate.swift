//
//  AppDelegate.swift
//  On the Map
//
//  Created by Niklas Rammerstorfer on 24.11.17.
//  Copyright © 2017 Niklas Rammerstorfer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var account: Account?
    var studentInformationToOverwrite: StudentInformation?

    // MARK: Constants

    struct Identifiers{
        struct Segues {
            static let MainView = "ShowMainView"
            static let InformationPostingFromMapView = "ShowInformationPostingViewFromMapView"
            static let InformationPostingFromTableView = "ShowInformationPostingViewFromTableView"
        }

        struct ViewControllers {
            static let InformationPostingDetail = "InformationPostingDetailViewController"
        }
    }

    // MARK: Common methods

    static func openURL(urlString: String){
        var urlString = urlString

        if urlString.lengthOfBytes(using: .utf8) >= 4{
            let index = urlString.index(urlString.startIndex, offsetBy: 4)
            let substring = urlString[..<index]

            if substring != "http"{
                urlString = prefixUrlStringWithHttp(urlString: urlString)
            }
        }
        else{
            urlString = prefixUrlStringWithHttp(urlString: urlString)
        }

        if let url = URL(string: urlString){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    private static func prefixUrlStringWithHttp(urlString: String) -> String{
        var urlString = urlString
        urlString = "http://\(urlString)"
        return urlString

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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

