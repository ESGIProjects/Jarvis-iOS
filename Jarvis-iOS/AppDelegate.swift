//
//  AppDelegate.swift
//  Jarvis-iOS
//
//  Created by Jason Pierna on 13/07/2017.
//  Copyright © 2017 Jason Pierna. All rights reserved.
//

import UIKit
import UserNotifications

import Firebase
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	let gcmMessageIDKey = "gcm.message_id"
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		FirebaseApp.configure()
		
		Messaging.messaging().delegate = self
		
		UNUserNotificationCenter.current().delegate = self
		
		let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
		UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
		
		application.registerForRemoteNotifications()

		return true
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
	
	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		let userInfo = notification.request.content.userInfo
		
		if let messageID = userInfo[gcmMessageIDKey] {
			print("Message ID: \(messageID)")
		}
		print(userInfo)
		
		completionHandler([])
	}
}

extension AppDelegate: MessagingDelegate {
	func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
		print("Firebase registration token: \(fcmToken)")
		
		let url = "http://jarvis-esgi.herokuapp.com/api/registerToken"
		let parameters = [
			"deviceToken" : fcmToken,
			"os" : "ios"
		]
		
		Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
			print(response.description)
		}
	}
	
	func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
		print("Received data message: \(remoteMessage.appData)")
	}
}
