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
        guard !isPreview else { return }
        let itemView = StatusBarItem(sizePassthrough: sizePassthrough, utility: utility)
        let hostingView = NSHostingView(rootView: itemView)
        hostingView.frame = .init(x: 0, y: 0, width: 80, height: 24)
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.frame = hostingView.frame
        statusItem.button?.addSubview(hostingView)

        self.statusItem = statusItem
        self.hostingView = hostingView

        let menuView = MenuView(utility: utility)
        popover = NSPopover()
        popover?.contentViewController = NSHostingController(rootView: menuView)
        popover?.animates = false

        self.statusItem?.button?.target = self
        self.statusItem?.button?.action = #selector(openPopover)

        sizeCancellable = sizePassthrough.sink { [weak self] size in
            let frame = NSRect(origin: .zero, size: .init(width: size.width, height: 24))
            self?.hostingView?.frame = frame
            self?.statusItem?.button?.frame = frame
        }

        NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            self?.popover?.performClose(event)
        }
    }

    @objc
    func openPopover(_ sender: NSButton) {
        guard let popover else { return }
        if popover.isShown {
            let positioningView = sender.subviews.first { $0.identifier == NSUserInterfaceItemIdentifier(rawValue: "positioningView") }
            positioningView?.removeFromSuperview()
        } else {
            let positioningView = NSView(frame: sender.bounds)
            positioningView.identifier = NSUserInterfaceItemIdentifier(rawValue: "positioningView")
            sender.addSubview(positioningView)
            popover.show(relativeTo: positioningView.bounds, of: positioningView, preferredEdge: .maxY)
            positioningView.bounds = sender.bounds.offsetBy(dx: 0, dy: sender.bounds.height)
            if let popoverWindow = popover.contentViewController?.view.window {
                popoverWindow.setFrame(popoverWindow.frame.offsetBy(dx: 0, dy: 10), display: false)
            }
        }
    }
}
