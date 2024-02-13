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

import Combine
import Sparkle
import SwiftUI

private var isPreview: Bool {
    return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem: NSStatusItem?
    var hostingView: NSHostingView<StatusBarItem>?
    var popover: NSPopover?

    lazy var detachedWindowController: DetachedWindowController = {
        let menuView = MenuView(utility: utility, updater: updaterController.updater)
        let windowController = DetachedWindowController(
            window: .init(contentViewController: NSHostingController(
                rootView: menuView
            ))
        )
        return windowController
    }()

    let utility: TMUtility = .init()

    var updaterController: SPUStandardUpdaterController!

    override init() {
        super.init()
        self.updaterController = .init(
            startingUpdater: true,
            updaterDelegate: nil,
            userDriverDelegate: self
        )
    }

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
            if let detachedWindow = detachedWindowController.window, detachedWindow.isVisible {
                detachedWindow.orderFrontRegardless()
            } else {
                popover.show(relativeTo: sender.bounds, of: sender, preferredEdge: .maxY)
                // fixes popover not being fully visible on the right side of the screen
                if let popoverFrame = popover.contentViewController?.view.window?.frame,
                   let screenFrame = popover.contentViewController?.view.window?.screen?.frame,
                   (popoverFrame.origin.x + Constants.Sizes.popoverWidth + 25) > screenFrame.width {
                    popover.contentViewController?.view.window?.setFrameOrigin(
                        NSPoint(x: screenFrame.width - Constants.Sizes.popoverWidth - 25, y: popoverFrame.origin.y)
                    )
                }
                popover.contentViewController?.view.window?.becomeKey()
            }
        }
    }

    private func setupPopover() {
        let menuView = MenuView(utility: utility, updater: updaterController.updater)
        popover = NSPopover()
        popover?.delegate = self
        popover?.contentViewController = NSHostingController(rootView: menuView)
        popover?.animates = false
        popover?.behavior = .semitransient
        popover?.setValue(true, forKeyPath: "shouldHideAnchor") // hide arrow
    }
}

extension AppDelegate: NSPopoverDelegate {
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }

    func detachableWindow(for popover: NSPopover) -> NSWindow? {
        return detachedWindowController.window
    }
}

extension AppDelegate: SPUStandardUserDriverDelegate {
    var supportsGentleScheduledUpdateReminders: Bool {
        return true
    }

    func standardUserDriverShouldHandleShowingScheduledUpdate(
        _ update: SUAppcastItem,
        andInImmediateFocus immediateFocus: Bool
    ) -> Bool {
        return true
    }
}

class DetachedWindowController: NSWindowController {
    init(window: NSWindow) {
        super.init(window: window)

        window.styleMask = [
            .closable,
            .titled,
            .fullSizeContentView
        ]
        window.titlebarAppearsTransparent = true
        window.standardWindowButton(.miniaturizeButton)?.isHidden = true
        window.standardWindowButton(.zoomButton)?.isHidden = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
