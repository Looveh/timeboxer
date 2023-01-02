//
//  AppDelegate.swift
//  timeboxer
//
//  Created by Niclas Nilsson on 2023-01-01.
//

import Cocoa
import UserNotifications

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var window: NSWindow!
    private var statusItem: NSStatusItem!
    private var menuStartItems: [NSMenuItem] = []
    private var menuStopItem: NSMenuItem!
    private var timer: Timer!
    private var endTime: Double!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        drawLabel()
        
        setupMenus()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (_granted, _error) in }
    }
    
    func setupMenus() {
        let menu = NSMenu()
        
        menuStartItems = [
            NSMenuItem(
                title: "15 min",
                action: #selector(onMenuClickPreset1),
                keyEquivalent: "1"
            ),
            NSMenuItem(
                title: "30 min",
                action: #selector(onMenuClickPreset2),
                keyEquivalent: "2"
            ),
            NSMenuItem(
                title: "45 min",
                action: #selector(onMenuClickPreset3),
                keyEquivalent: "3"
            ),
            NSMenuItem(
                title: "60 min",
                action: #selector(onMenuClickPreset4),
                keyEquivalent: "4"
            ),
            NSMenuItem(
                title: "Custom",
                action: #selector(onMenuClickCustom),
                keyEquivalent: "c"
            )
        ]
        
        menuStopItem = NSMenuItem(
            title: "Stop",
            action: #selector(onClickStop),
            keyEquivalent: "s"
        )
        menuStopItem?.isHidden = true
        
        for item in menuStartItems {
            menu.addItem(item)
        }
        
        menu.addItem(menuStopItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(
            title: "Quit",
            action: #selector(NSApplication.terminate(_:)),
            keyEquivalent: "q"
        ))
        
        statusItem.menu = menu
    }
    
    func startTimer(endTime: Double) {
        self.endTime = endTime
        
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(timerTick),
            userInfo: nil,
            repeats: true
        )
        
        for item in menuStartItems {
            item.isHidden = true
        }
        
        menuStopItem?.isHidden = false
        
        scheduleNotifications(endTime: endTime)
        
        drawLabel()
    }
    
    func stopTimer() {
        if timer.isValid {
            timer.invalidate()
        }
        
        for item in menuStartItems {
            item.isHidden = false
        }
        
        menuStopItem.isHidden = true
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        drawLabel()
    }
    
    func drawLabel() {
        var label = ""
        
        if endTime == nil {
            label = "Timebox"
        } else {
            let diff = Int(endTime - NSDate().timeIntervalSince1970)
            let hours = diff / 3600
            let minutes = diff % 3600 / 60 + 1
            
            if diff <= 0 {
                label = "Done"
            } else if hours > 0 {
                label = "\(hours)h \(minutes)m"
            } else {
                label = "\(minutes)m"
            }
        }
        
        statusItem?.button?.title = label
    }
    
    func scheduleNotifications(endTime: Double) {
        let now = Date()
        
        for offset in [0, 5, 15] {
            let fireAt = Date(timeIntervalSince1970: endTime - Double(offset) * 60)
            
            if fireAt < now {
                continue
            }
            
            let content = UNMutableNotificationContent()
            content.title = "Timebox"
            content.body = offset == 0 ? "Done" : "\(offset) min left"
            content.sound = UNNotificationSound.default
            
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fireAt),
                repeats: false
            )

            UNUserNotificationCenter.current().add(UNNotificationRequest(
                identifier: UUID().uuidString,
                content: content,
                trigger: trigger
            ))
        }
    }
    
    @objc
    func timerTick() {
        drawLabel()
        
        if NSDate().timeIntervalSince1970 >= endTime {
            stopTimer()
        }
    }
    
    @objc
    func onMenuClickPreset1() {
        startTimer(endTime: NSDate().timeIntervalSince1970 + 15 * 60)
    }
    
    @objc
    func onMenuClickPreset2() {
        startTimer(endTime: NSDate().timeIntervalSince1970 + 30 * 60)
    }
    
    @objc
    func onMenuClickPreset3() {
        startTimer(endTime: NSDate().timeIntervalSince1970 + 45 * 60)
    }
    
    @objc
    func onMenuClickPreset4() {
        startTimer(endTime: NSDate().timeIntervalSince1970 + 60 * 60)
    }
    
    @objc
    func onMenuClickCustom() {
        let inputTextField = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        inputTextField.placeholderString = ("minutes")
        
        let alert = NSAlert()
        alert.messageText = "Timebox for"
        alert.addButton(withTitle: "Start")
        alert.addButton(withTitle: "Cancel")
        alert.accessoryView = inputTextField
        
        let response = alert.runModal()
        
        // Didn't press "Start"
        if response != NSApplication.ModalResponse.alertFirstButtonReturn {
            return
        }
        
        startTimer(endTime: NSDate().timeIntervalSince1970 + inputTextField.doubleValue * 60)
    }
    
    @objc
    func onClickStop() {
        endTime = nil
        
        stopTimer()
    }
}
