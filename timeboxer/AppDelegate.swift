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
        // 3
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "1.circle", accessibilityDescription: "1")
        }
        
        setupMenus()
    }
    
    func setupMenus() {
        // 1
        let menu = NSMenu()
        
        // 2
        let one = NSMenuItem(title: "One", action: #selector(didTapOne) , keyEquivalent: "1")
        menu.addItem(one)
        
        let two = NSMenuItem(title: "Two", action: #selector(didTapTwo) , keyEquivalent: "2")
        menu.addItem(two)
        
        let three = NSMenuItem(title: "Three", action: #selector(didTapThree) , keyEquivalent: "3")
        menu.addItem(three)
        
        menu.addItem(NSMenuItem.separator())
        
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        // 3
        statusItem.menu = menu
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
