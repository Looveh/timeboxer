//
//  AppDelegate.swift
//  timeboxer
//
//  Created by Niclas Nilsson on 2023-01-01.
//

import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var window: NSWindow!
    
    private var statusItem: NSStatusItem!
    
    private var countdown = 0;
    
    private var timer: Timer!;
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        /*
         window = NSWindow(
         contentRect: NSRect(x: 0, y: 0, width: 480, height: 270),
         styleMask: [.miniaturizable, .closable, .resizable, .titled],
         backing: .buffered, defer: false)
         window.center()
         window.title = "No Storyboard Window"
         window.contentView = NSHostingView(rootView: SwiftUIView())
         window.makeKeyAndOrderFront(nil)
         */
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
     
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }
        
        setupMenus()
        
        startTimer()
    }
    
    func setupMenus() {
        let menu = NSMenu()
        
        let one = NSMenuItem(title: "One", action: #selector(didTapOne) , keyEquivalent: "1")
        menu.addItem(one)
        
        let two = NSMenuItem(title: "Two", action: #selector(didTapTwo) , keyEquivalent: "2")
        menu.addItem(two)
        
        let three = NSMenuItem(title: "Three", action: #selector(didTapThree) , keyEquivalent: "3")
        menu.addItem(three)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
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
    
    @objc
    func timerTimeout() {
        countdown += 1;
        
        if let button = statusItem.button {
           button.title = "\(countdown)"
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

struct SwiftUIView: View {
    var body: some View {
        Text("Hello, SwiftUI!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
