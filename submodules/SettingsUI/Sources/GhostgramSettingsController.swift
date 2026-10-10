import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import ItemListUI
import AccountContext

// MARK: - Entry Definition

private enum GhostgramSettingsSection: Int32 {
    case privacy
    case tools
    case info
}

private enum GhostgramSettingsEntry: ItemListNodeEntry {
    case privacyHeader(PresentationTheme, String)
    case ghostMode(PresentationTheme, String, String)
    case deletedMessages(PresentationTheme, String, String)
    case misc(PresentationTheme, String, String)
    
    case toolsHeader(PresentationTheme, String)
    case voiceMorpher(PresentationTheme, String, String)
    case deviceSpoof(PresentationTheme, String, String)
    case sendDelay(PresentationTheme, String, String)
    
    case info(PresentationTheme, String)
    
    var section: ItemListSectionId {
        switch self {
        case .privacyHeader, .ghostMode, .deletedMessages, .misc:
            return GhostgramSettingsSection.privacy.rawValue
        case .toolsHeader, .voiceMorpher, .deviceSpoof, .sendDelay:
            return GhostgramSettingsSection.tools.rawValue
        case .info:
            return GhostgramSettingsSection.info.rawValue
        }
    }
    
    var stableId: Int32 {
        switch self {
        case .privacyHeader: return 0
        case .ghostMode: return 1
        case .deletedMessages: return 2
        case .misc: return 3
        case .toolsHeader: return 4
        case .voiceMorpher: return 5
        case .deviceSpoof: return 6
        case .sendDelay: return 7
        case .info: return 8
        }
    }
    
    static func ==(lhs: GhostgramSettingsEntry, rhs: GhostgramSettingsEntry) -> Bool {
        switch lhs {
        case let .privacyHeader(lhsTheme, lhsText):
            if case let .privacyHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .ghostMode(lhsTheme, lhsText, lhsValue):
            if case let .ghostMode(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .deletedMessages(lhsTheme, lhsText, lhsValue):
            if case let .deletedMessages(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .misc(lhsTheme, lhsText, lhsValue):
            if case let .misc(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .toolsHeader(lhsTheme, lhsText):
            if case let .toolsHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .voiceMorpher(lhsTheme, lhsText, lhsValue):
            if case let .voiceMorpher(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .deviceSpoof(lhsTheme, lhsText, lhsValue):
            if case let .deviceSpoof(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .sendDelay(lhsTheme, lhsText, lhsValue):
            if case let .sendDelay(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .info(lhsTheme, lhsText):
            if case let .info(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        }
    }
    
    static func <(lhs: GhostgramSettingsEntry, rhs: GhostgramSettingsEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }
    
    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let arguments = arguments as! GhostgramSettingsControllerArguments
        switch self {
        case let .privacyHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .ghostMode(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openGhostMode()
                }
            )
        case let .deletedMessages(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openDeletedMessages()
                }
            )
        case let .misc(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openMisc()
                }
            )
        case let .toolsHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .voiceMorpher(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openVoiceMorpher()
                }
            )
        case let .deviceSpoof(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openDeviceSpoof()
                }
            )
        case let .sendDelay(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openSendDelay()
                }
            )
        case let .info(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

// MARK: - Arguments

private final class GhostgramSettingsControllerArguments {
    let openDeletedMessages: () -> Void
    let openGhostMode: () -> Void
    let openMisc: () -> Void
    let openDeviceSpoof: () -> Void
    let openVoiceMorpher: () -> Void
    let openSendDelay: () -> Void
    
    init(
        openDeletedMessages: @escaping () -> Void,
        openGhostMode: @escaping () -> Void,
        openMisc: @escaping () -> Void,
        openDeviceSpoof: @escaping () -> Void,
        openVoiceMorpher: @escaping () -> Void,
        openSendDelay: @escaping () -> Void
    ) {
        self.openDeletedMessages = openDeletedMessages
        self.openGhostMode = openGhostMode
        self.openMisc = openMisc
        self.openDeviceSpoof = openDeviceSpoof
        self.openVoiceMorpher = openVoiceMorpher
        self.openSendDelay = openSendDelay
    }
}

// MARK: - State

private struct GhostgramSettingsState: Equatable {
    var deletedMessagesEnabled: Bool
    var ghostModeEnabled: Bool
    var ghostModeActiveCount: Int
    var miscEnabled: Bool
    var miscActiveCount: Int
    var deviceSpoofEnabled: Bool
    var voiceMorpherEnabled: Bool
    var voiceMorpherPresetName: String
    var sendDelayEnabled: Bool
    
    static func current() -> GhostgramSettingsState {
        return GhostgramSettingsState(
            deletedMessagesEnabled: AntiDeleteManager.shared.isEnabled,
            ghostModeEnabled: GhostModeManager.shared.isEnabled,
            ghostModeActiveCount: GhostModeManager.shared.activeFeatureCount,
            miscEnabled: MiscSettingsManager.shared.isEnabled,
            miscActiveCount: MiscSettingsManager.shared.activeFeatureCount,
            deviceSpoofEnabled: DeviceSpoofManager.shared.isEnabled,
            voiceMorpherEnabled: VoiceMorpherManager.shared.isEnabled,
            voiceMorpherPresetName: VoiceMorpherManager.shared.selectedPreset.name,
            sendDelayEnabled: SendDelayManager.shared.isEnabled
        )
    }
}

// MARK: - Entries builder

private func ghostgramSettingsControllerEntries(
    presentationData: PresentationData,
    state: GhostgramSettingsState
) -> [GhostgramSettingsEntry] {
    var entries: [GhostgramSettingsEntry] = []
    let theme = presentationData.theme
    
    // Privacy Section
    entries.append(.privacyHeader(theme, "КОНФИДЕНЦИАЛЬНОСТЬ"))
    
    let ghostModeStatus = state.ghostModeEnabled ? "\(state.ghostModeActiveCount)/5" : "Выкл"
    entries.append(.ghostMode(theme, "Режим невидимки", ghostModeStatus))
    
    let deletedStatus = state.deletedMessagesEnabled ? "Вкл" : "Выкл"
    entries.append(.deletedMessages(theme, "Анти-удаление сообщений", deletedStatus))
    
    let miscStatus = state.miscEnabled ? "\(state.miscActiveCount)/5" : "Выкл"
    entries.append(.misc(theme, "Многоразовые медиа & Защита", miscStatus))
    
    // Tools Section
    entries.append(.toolsHeader(theme, "ИНСТРУМЕНТЫ"))
    
    let voiceMorpherStatus = state.voiceMorpherEnabled ? state.voiceMorpherPresetName : "Выкл"
    entries.append(.voiceMorpher(theme, "Голосовой морфер", voiceMorpherStatus))
    
    let deviceSpoofStatus = state.deviceSpoofEnabled ? "Вкл" : "Выкл"
    entries.append(.deviceSpoof(theme, "Подмена устройства", deviceSpoofStatus))
    
    let sendDelayStatus = state.sendDelayEnabled ? "Вкл" : "Выкл"
    entries.append(.sendDelay(theme, "Задержка отправки", sendDelayStatus))
    
    // Info
    entries.append(.info(theme, "Ghostgram • Локальные функции конфиденциальности. Все настройки применяются исключительно на вашем устройстве."))
    
    return entries
}

// MARK: - Controller

public func ghostgramSettingsController(context: AccountContext) -> ViewController {
    var pushControllerImpl: ((ViewController, Bool) -> Void)?
    
    let stateValue = Atomic(value: GhostgramSettingsState.current())
    let statePromise = ValuePromise(GhostgramSettingsState.current(), ignoreRepeated: true)
    
    let arguments = GhostgramSettingsControllerArguments(
        openDeletedMessages: {
            pushControllerImpl?(deletedMessagesController(context: context), true)
        },
        openGhostMode: {
            pushControllerImpl?(ghostModeController(context: context), true)
        },
        openMisc: {
            pushControllerImpl?(miscController(context: context), true)
        },
        openDeviceSpoof: {
            pushControllerImpl?(deviceSpoofController(context: context), true)
        },
        openVoiceMorpher: {
            pushControllerImpl?(voiceMorpherController(context: context), true)
        },
        openSendDelay: {
            pushControllerImpl?(sendDelayController(context: context), true)
        }
    )
    
    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, state -> (ItemListControllerState, (ItemListNodeState, Any)) in
        let entries = ghostgramSettingsControllerEntries(presentationData: presentationData, state: state)
        
        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Ghostgram"),
            leftNavigationButton: nil,
            rightNavigationButton: nil,
            backNavigationButton: ItemListBackButton(title: presentationData.strings.Common_Back),
            animateChanges: true
        )
        
        let listState = ItemListNodeState(
            presentationData: ItemListPresentationData(presentationData),
            entries: entries,
            style: .blocks,
            animateChanges: true
        )
        
        return (controllerState, (listState, arguments))
    }
    
    let controller = ItemListController(context: context, state: signal)
    
    // Refresh state when view appears
    controller.visibleBottomContentOffsetChanged = { _ in }
    controller.didAppear = { _ in
        let newState = GhostgramSettingsState.current()
        let _ = stateValue.modify { _ in newState }
        statePromise.set(newState)
    }
    
    pushControllerImpl = { [weak controller] c, animated in
        controller?.push(c)
    }
    return controller
}
