//
//  ViewController.swift
//  LogsManager
//
//  Created by Anton Plebanovich on 02/11/2019.
//  Copyright (c) 2019 Anton Plebanovich. All rights reserved.
//

import UIKit

import APExtensions
import LogsManager
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Logs directory: \(c.documentsDirectoryUrl.path)/LogsManager/")
        
        let vcComponent = LogComponent(name: "ViewController", logName: "VC") { filePath, _ in
            let fileName = String.getFileName(filePath: filePath)
            return fileName == "ViewController"
        }
        LoggersManager.shared.registerLogComponent(vcComponent)
        
        let didAppearComponent = LogComponent(name: "Did Appear", logName: "viewDidAppear") { _, function in
            return function.hasPrefix("viewDidAppear")
        }
        LoggersManager.shared.registerLogComponent(didAppearComponent)
        
        let fileLogger = FileLogger(mode: .all, logLevel: .verbose)
        LoggersManager.shared.addLogger(fileLogger)
        
        let logger = ConsoleLogger(mode: .specificComponents([vcComponent]), logLevel: .verbose, newLinesSeparation: true)
        LoggersManager.shared.addLogger(logger)
        logDebug("Test1")
        
        LoggersManager.shared.removeLogger(logger)
        logDebug("Test2")
        
        LoggersManager.shared.addLogger(logger)
        logDebug("Test3")
        
        LoggersManager.shared.unregisterLogComponent(vcComponent)
        logDebug("Test4")
        
        let allLogger = ConsoleLogger(mode: .all, logLevel: .verbose, newLinesSeparation: false)
        LoggersManager.shared.addLogger(allLogger)
        logDebug("Test5")
        
        let allLogComponent2 = LogComponent(name: "All2", logName: "", isLogForThisComponent: { _, _ in true })
        LoggersManager.shared.registerLogComponent(allLogComponent2)
        logDebug("Test6")
        
        let allLogComponent3 = LogComponent(name: "All3", logName: "3", isLogForThisComponent: { _, _ in true })
        let allLogComponent4 = LogComponent(name: "All4", logName: "4", isLogForThisComponent: { _, _ in true })
        LoggersManager.shared.registerLogComponent(allLogComponent3)
        LoggersManager.shared.registerLogComponent(allLogComponent4)
        logDebug("Test7")
        
        let all3Logger = ConsoleLogger(mode: .specificComponents([allLogComponent3]), logLevel: .warning, newLinesSeparation: false)
        LoggersManager.shared.addLogger(all3Logger)
        logInfo("Test 8")
        logWarning("Test 9")
        
        logError("Test 9.1", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]))
        logError("Test 9.2", data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        logError("Test 10", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        
        let allAlertLogger = AlertLogger(mode: .all, logLevel: .error)
        LoggersManager.shared.addLogger(allAlertLogger)
        
        if #available(iOS 10.0, *) {
            let allNotificationsLogger = NotificationLogger(mode: .all, logLevel: .error)
            LoggersManager.shared.addLogger(allNotificationsLogger)
        }
        
        logError("Test 11", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert], completionHandler: { _, _ in })
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: nil) { _ in
            g.sharedApplication.startBackgroundTaskIfNeeded()
            
            g.asyncMain(2) {
                logError("BG test", error: NSError(domain: "Test Domain", code: -1, userInfo: ["hm": "hm", "hm2": "hm2"]), data: ["one": "one", "two": "two", "dic": ["one": "one", "two": "two"]])
                g.sharedApplication.startBackgroundTaskIfNeeded()
            }
        }
        
        testSameLine()
        testSameLine()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        logDebug("viewDidAppear called")
    }
    
    private func testSameLine() {
        logDebug("Test same line")
    }
}
