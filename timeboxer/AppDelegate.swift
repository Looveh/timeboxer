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
    
    private var countdown = 10;
    
    private var timer: Timer!;
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        drawLabel()
        
        setupMenus()
        
        startTimer()
    }
    
    func setupMenus() {
        let one = NSMenuItem(title: "One", action: #selector(didTapOne) , keyEquivalent: "1")
        let two = NSMenuItem(title: "Two", action: #selector(didTapTwo) , keyEquivalent: "2")
        let three = NSMenuItem(title: "Three", action: #selector(didTapThree) , keyEquivalent: "3")

        let menu = NSMenu()

        menu.addItem(one)
        menu.addItem(two)
        menu.addItem(three)
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
            selector: #selector(timerTimeout),
            userInfo: nil,
            repeats: true
        )
    }
    
    func drawLabel() {
        statusItem?.button?.title = countdownLabel()
    }
    
    func countdownLabel() -> String {
        if countdown <= 0 {
            return "Done"
        }
        
        let hours = countdown / 3600
        let minutes = countdown % 3600 / 60
        let seconds = countdown % 60
        
        var label = ""
        
        if hours > 0 {
            label += "\(hours)h "
        }
        
        if minutes > 0 || hours > 0 {
            label += "\(minutes)m "
        }
        
        label += "\(seconds)s"
        
        return label
    }
    
    @objc
    func timerTimeout() {
        countdown -= 1
        
        drawLabel()
        
        if countdown <= 0 {
            timer.invalidate()
        }
    }
    
    private func changeStatusBarButton(number: Int) {
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "\(number).circle", accessibilityDescription: number.description)
        }
    }
    
    @objc
    func didTapOne() {
        changeStatusBarButton(number: 1)
    }
    
    @objc
    func didTapTwo() {
        changeStatusBarButton(number: 2)
    }
    
    @objc
    func didTapThree() {
        changeStatusBarButton(number: 3)
    }
}
