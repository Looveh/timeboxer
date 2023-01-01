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
    
    private var menuStartItem: NSMenuItem!
    private var menuStopItem: NSMenuItem!
    
    private var countdown = -1;
    
    private var timer: Timer!;
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        drawLabel()
        
        setupMenus()
        
        startTimer()
    }
    
    func setupMenus() {
        let menu = NSMenu()

        menuStartItem = NSMenuItem(
            title: "Start",
            action: #selector(didTapStart),
            keyEquivalent: "s"
        )

        menuStopItem = NSMenuItem(
            title: "Stop",
            action: #selector(didTapStop),
            keyEquivalent: "s"
        )
        menuStopItem?.isHidden = true
        
        menu.addItem(menuStartItem)
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
            selector: #selector(timerTimeout),
            userInfo: nil,
            repeats: true
        )
        
        menuStartItem?.isHidden = true
        menuStopItem?.isHidden = false
    }
    
    func drawLabel() {
        statusItem?.button?.title = countdownLabel()
    }
    
    func countdownLabel() -> String {
        if countdown < 0 {
            return "Timebox"
        } else if countdown == 0 {
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
            stopTimer()
        }
    }
    
    func stopTimer() {
        if timer.isValid {
            timer.invalidate()
        }
        
        menuStartItem.isHidden = false
        menuStopItem.isHidden = true
        
        drawLabel()
    }
    
    @objc
    func didTapStart() {
        // TODO
    }
    
    @objc
    func didTapStop() {
        countdown = -1
        
        stopTimer()
    }
}
