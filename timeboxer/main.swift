//
//  main.swift
//  timeboxer
//
//  Created by Niclas Nilsson on 2023-01-01.
//

import Foundation
import Cocoa

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate

_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
