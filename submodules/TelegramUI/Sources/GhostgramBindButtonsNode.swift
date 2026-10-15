import Foundation
import UIKit
import AsyncDisplayKit
import Display
import TelegramCore
import TelegramPresentationData
import AccountContext

public enum GhostgramBindButtonType: String, CaseIterable {
    case ghostMode
    case antiDelete
    case editHistory
    case scheduledMessages
    case translateBeforeSend
    case scrollToTop
    case screenshotPrivacy

    public var systemIconName: String {
        switch self {
        case .ghostMode: return "eye.slash.fill"
        case .antiDelete: return "trash.slash.fill"
        case .editHistory: return "pencil.and.outline"
        case .scheduledMessages: return "clock.fill"
        case .translateBeforeSend: return "character.book.closed.fill"
        case .scrollToTop: return "arrow.up.circle.fill"
        case .screenshotPrivacy: return "camera.viewfinder"
        }
    }
}

public final class GhostgramBindButtonsNode: ASDisplayNode {
    private let context: AccountContext
    private var buttons: [ASButtonNode] = []
    public var onScrollToTop: (() -> Void)?

    public init(context: AccountContext) {
        self.context = context
        super.init()
        self.isUserInteractionEnabled = true
        self.setupButtons()
    }

    public func updateButtons() {
        self.setupButtons()
    }

    private func setupButtons() {
        for b in self.buttons {
            b.removeFromSupernode()
        }
        self.buttons.removeAll()

        let manager = FontCustomizationManager.shared
        guard manager.showBindButtons else { return }

        var activeTypes: [GhostgramBindButtonType] = []
        if manager.showGhostModeBind { activeTypes.append(.ghostMode) }
        if manager.showDeletedMessagesBind { activeTypes.append(.antiDelete) }
        if manager.showScrollToTopBind { activeTypes.append(.scrollToTop) }
        if manager.showScheduledMessagesBind { activeTypes.append(.scheduledMessages) }
        if manager.showScreenshotPrivacyBind { activeTypes.append(.screenshotPrivacy) }
        if manager.showTranslateBeforeSendBind { activeTypes.append(.translateBeforeSend) }

        for (index, type) in activeTypes.enumerated() {
            let btn = ASButtonNode()
            btn.backgroundColor = UIColor(white: 0.15, alpha: 0.85)
            btn.cornerRadius = 22
            btn.clipsToBounds = true

            let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
            let icon = UIImage(systemName: type.systemIconName, withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
            btn.setImage(icon, for: .normal)
            btn.tintColor = .white

            btn.addTarget(self, action: #selector(self.buttonPressed(_:)), forControlEvents: .touchUpInside)
            btn.view.tag = index
            self.addSubnode(btn)
            self.buttons.append(btn)
        }
    }

    @objc private func buttonPressed(_ sender: ASButtonNode) {
        let manager = FontCustomizationManager.shared
        var activeTypes: [GhostgramBindButtonType] = []
        if manager.showGhostModeBind { activeTypes.append(.ghostMode) }
        if manager.showDeletedMessagesBind { activeTypes.append(.antiDelete) }
        if manager.showScrollToTopBind { activeTypes.append(.scrollToTop) }
        if manager.showScheduledMessagesBind { activeTypes.append(.scheduledMessages) }
        if manager.showScreenshotPrivacyBind { activeTypes.append(.screenshotPrivacy) }
        if manager.showTranslateBeforeSendBind { activeTypes.append(.translateBeforeSend) }

        guard sender.view.tag < activeTypes.count else { return }
        let type = activeTypes[sender.view.tag]

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()

        switch type {
        case .ghostMode:
            let gm = GhostModeManager.shared
            gm.isEnabled = !gm.isEnabled
            sender.tintColor = gm.isEnabled ? UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) : .white
        case .antiDelete:
            let ad = AntiDeleteManager.shared
            ad.isEnabled = !ad.isEnabled
            sender.tintColor = ad.isEnabled ? UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) : .white
        case .scrollToTop:
            self.onScrollToTop?()
        case .scheduledMessages:
            break
        case .screenshotPrivacy:
            let misc = MiscSettingsManager.shared
            misc.bypassScreenshotProtection = !misc.bypassScreenshotProtection
            sender.tintColor = misc.bypassScreenshotProtection ? UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) : .white
        case .translateBeforeSend:
            manager.showTranslateBeforeSendBind = !manager.showTranslateBeforeSendBind
            sender.tintColor = manager.showTranslateBeforeSendBind ? UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0) : .white
        case .editHistory:
            break
        }
    }

    public func updateLayout(size: CGSize, bottomInset: CGFloat) {
        let btnSize: CGFloat = 44
        let spacing: CGFloat = 10
        var currentY = size.height - bottomInset - btnSize - 60

        for btn in self.buttons {
            btn.frame = CGRect(x: size.width - btnSize - 16, y: currentY, width: btnSize, height: btnSize)
            currentY -= (btnSize + spacing)
        }
    }
}
