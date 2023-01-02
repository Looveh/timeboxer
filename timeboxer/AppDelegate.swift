//
//  AppDelegate.swift
//  timeboxer
//
//  Created by Niclas Nilsson on 2023-01-01.
//

import Cocoa

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
    
    func startTimer() {
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
    
    @objc
    func timerTick() {
        drawLabel()
        
        if NSDate().timeIntervalSince1970 >= endTime {
            stopTimer()
        }
    }
    
    @objc
    func onMenuClickPreset1() {
        endTime = NSDate().timeIntervalSince1970 + 15 * 60
        
        startTimer()
    }
    
    @objc
    func onMenuClickPreset2() {
        endTime = NSDate().timeIntervalSince1970 + 30 * 60
        
        startTimer()
    }
    
    @objc
    func onMenuClickPreset3() {
        endTime = NSDate().timeIntervalSince1970 + 45 * 60
        
        startTimer()
    }
    
    @objc
    func onMenuClickPreset4() {
        endTime = NSDate().timeIntervalSince1970 + 60 * 60
        
        startTimer()
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
        
        endTime = NSDate().timeIntervalSince1970 + inputTextField.doubleValue * 60
        
        startTimer()
    }
    
    @objc
    func onClickStop() {
        endTime = nil
        
        stopTimer()
    }
}
