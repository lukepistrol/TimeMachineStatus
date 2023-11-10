//
//  AppDelegate.swift
//  TimeMachineStatus
//
//  Created by Lukas Pistrol on 2023-11-10.
//
//  Copyright © 2023 Lukas Pistrol. All rights reserved.
//
//  See LICENSE.md for license information.
//

import SwiftUI
import Combine

private var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var hostingView: NSHostingView<StatusBarItem>?
    var popover: NSPopover?

    let utility: TMUtility = .init()

    private var sizePassthrough = PassthroughSubject<CGSize, Never>()
    private var sizeCancellable: AnyCancellable?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // dont launch an extra instance of the menu bar item when in Xcode SwiftUI Preview
        if !isPreview {
            setupStatusItem()
            setupPopover()
        }

        // subscribe to size changes of the menu bar item
        sizeCancellable = sizePassthrough.sink { [weak self] size in
            guard let self else { return }
            let frame = NSRect(origin: .zero, size: .init(width: size.width, height: 24))
            self.hostingView?.frame = frame
            self.statusItem?.button?.frame = frame
        }

        // dismiss the popover when mouse clicks anywhere outside the app
        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            self?.popover?.performClose(event)
        }
    }

    private func setupStatusItem() {
        let itemView = StatusBarItem(sizePassthrough: sizePassthrough, utility: utility)
        let hostingView = NSHostingView(rootView: itemView)
        hostingView.frame = .init(x: 0, y: 0, width: 80, height: 24)
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.frame = hostingView.frame
        statusItem.button?.addSubview(hostingView)

        self.statusItem = statusItem
        self.hostingView = hostingView

        self.statusItem?.button?.target = self
        self.statusItem?.button?.action = #selector(openPopover)
    }

    @objc
    private func openPopover(_ sender: NSButton) {
        guard let popover else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
        }
    }

    private func setupPopover() {
        let menuView = MenuView(utility: utility)
        popover = NSPopover()
        popover?.contentViewController = NSHostingController(rootView: menuView)
        popover?.animates = false
        popover?.behavior = .applicationDefined
        popover?.setValue(true, forKeyPath: "shouldHideAnchor") // hide arrow
    }
}
