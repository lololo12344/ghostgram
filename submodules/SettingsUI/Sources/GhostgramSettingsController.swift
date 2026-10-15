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
    case customization
    case tools
    case info
}

private enum GhostgramSettingsEntry: ItemListNodeEntry {
    case privacyHeader(PresentationTheme, String)
    case ghostMode(PresentationTheme, String, String)
    case deletedMessages(PresentationTheme, String, String)
    case misc(PresentationTheme, String, String)
    
    case customizationHeader(PresentationTheme, String)
    case fontCustomization(PresentationTheme, String, String)
    case checkmarkColor(PresentationTheme, String, String)

    case toolsHeader(PresentationTheme, String)
    case optimization(PresentationTheme, String)
    case plugins(PresentationTheme, String)
    case voiceMorpher(PresentationTheme, String, String)
    case deviceSpoof(PresentationTheme, String, String)
    
    case info(PresentationTheme, String)
    
    var section: ItemListSectionId {
        switch self {
        case .privacyHeader, .ghostMode, .deletedMessages, .misc:
            return GhostgramSettingsSection.privacy.rawValue
        case .customizationHeader, .fontCustomization, .checkmarkColor:
            return GhostgramSettingsSection.customization.rawValue
        case .toolsHeader, .optimization, .plugins, .voiceMorpher, .deviceSpoof:
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
        case .customizationHeader: return 4
        case .fontCustomization: return 5
        case .checkmarkColor: return 6
        case .toolsHeader: return 7
        case .optimization: return 8
        case .plugins: return 9
        case .voiceMorpher: return 10
        case .deviceSpoof: return 11
        case .info: return 12
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
        case let .customizationHeader(lhsTheme, lhsText):
            if case let .customizationHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .fontCustomization(lhsTheme, lhsText, lhsValue):
            if case let .fontCustomization(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .checkmarkColor(lhsTheme, lhsText, lhsValue):
            if case let .checkmarkColor(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .toolsHeader(lhsTheme, lhsText):
            if case let .toolsHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .optimization(lhsTheme, lhsText):
            if case let .optimization(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .plugins(lhsTheme, lhsText):
            if case let .plugins(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .voiceMorpher(lhsTheme, lhsText, lhsValue):
            if case let .voiceMorpher(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .deviceSpoof(lhsTheme, lhsText, lhsValue):
            if case let .deviceSpoof(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
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
        case let .customizationHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .fontCustomization(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openFontCustomization()
                }
            )
        case let .checkmarkColor(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openCheckmarkColor()
                }
            )
        case let .toolsHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .optimization(_, text):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: "",
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openOptimization()
                }
            )
        case let .plugins(_, text):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: "",
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.openPlugins()
                }
            )
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
    let openFontCustomization: () -> Void
    let openCheckmarkColor: () -> Void
    let openOptimization: () -> Void
    let openPlugins: () -> Void
    let openDeviceSpoof: () -> Void
    let openVoiceMorpher: () -> Void
    
    init(
        openDeletedMessages: @escaping () -> Void,
        openGhostMode: @escaping () -> Void,
        openMisc: @escaping () -> Void,
        openFontCustomization: @escaping () -> Void,
        openCheckmarkColor: @escaping () -> Void,
        openOptimization: @escaping () -> Void,
        openPlugins: @escaping () -> Void,
        openDeviceSpoof: @escaping () -> Void,
        openVoiceMorpher: @escaping () -> Void
    ) {
        self.openDeletedMessages = openDeletedMessages
        self.openGhostMode = openGhostMode
        self.openMisc = openMisc
        self.openFontCustomization = openFontCustomization
        self.openCheckmarkColor = openCheckmarkColor
        self.openOptimization = openOptimization
        self.openPlugins = openPlugins
        self.openDeviceSpoof = openDeviceSpoof
        self.openVoiceMorpher = openVoiceMorpher
    }
}

// MARK: - State

private struct GhostgramSettingsState: Equatable {
    var deletedMessagesEnabled: Bool
    var ghostModeEnabled: Bool
    var ghostModeActiveCount: Int
    var miscEnabled: Bool
    var miscActiveCount: Int
    var customFontName: String
    var checkmarkColorStatus: String
    var deviceSpoofEnabled: Bool
    var voiceMorpherEnabled: Bool
    var voiceMorpherPresetName: String
    
    static func current() -> GhostgramSettingsState {
        let fm = FontCustomizationManager.shared
        let fontText = fm.isEnabled ? fm.selectedFont.displayName : "Системный"
        let checkmarkText = fm.readStatusColorEnabled ? fm.readStatusColorMode.rawValue.capitalized : "По умолчанию"

        return GhostgramSettingsState(
            deletedMessagesEnabled: AntiDeleteManager.shared.isEnabled,
            ghostModeEnabled: GhostModeManager.shared.isEnabled,
            ghostModeActiveCount: GhostModeManager.shared.activeFeatureCount,
            miscEnabled: MiscSettingsManager.shared.isEnabled,
            miscActiveCount: MiscSettingsManager.shared.activeFeatureCount,
            customFontName: fontText,
            checkmarkColorStatus: checkmarkText,
            deviceSpoofEnabled: DeviceSpoofManager.shared.isEnabled,
            voiceMorpherEnabled: VoiceMorpherManager.shared.isEnabled,
            voiceMorpherPresetName: VoiceMorpherManager.shared.selectedPreset.name
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
    
    let miscStatus = state.miscEnabled ? "\(state.miscActiveCount)/6" : "Выкл"
    entries.append(.misc(theme, "Многоразовые медиа & Защита", miscStatus))
    
    // Customization Section
    entries.append(.customizationHeader(theme, "КАСТОМИЗАЦИЯ & ОФОРМЛЕНИЕ"))
    entries.append(.fontCustomization(theme, "Шрифты и внешний вид", state.customFontName))
    entries.append(.checkmarkColor(theme, "Цвет галочек сообщений", state.checkmarkColorStatus))

    // Tools Section
    entries.append(.toolsHeader(theme, "ИНСТРУМЕНТЫ & РАСШИРЕНИЯ"))
    entries.append(.optimization(theme, "Оптимизация и кэш"))
    entries.append(.plugins(theme, "Плагины и скрипты (GGPlugin IDE)"))

    let voiceMorpherStatus = state.voiceMorpherEnabled ? state.voiceMorpherPresetName : "Выкл"
    entries.append(.voiceMorpher(theme, "Голосовой морфер", voiceMorpherStatus))
    
    let deviceSpoofStatus = state.deviceSpoofEnabled ? "Вкл" : "Выкл"
    entries.append(.deviceSpoof(theme, "Подмена устройства", deviceSpoofStatus))
    
    // Info
    entries.append(.info(theme, "Ghostgram 13.0 • Все функции и PRO-возможности разблокированы бесплатно на вашем устройстве."))
    
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
        openFontCustomization: {
            pushControllerImpl?(fontCustomizationController(context: context), true)
        },
        openCheckmarkColor: {
            pushControllerImpl?(checkmarkColorController(context: context), true)
        },
        openOptimization: {
            pushControllerImpl?(optimizationController(context: context), true)
        },
        openPlugins: {
            pushControllerImpl?(GGPluginEditorController(context: context), true)
        },
        openDeviceSpoof: {
            pushControllerImpl?(deviceSpoofController(context: context), true)
        },
        openVoiceMorpher: {
            pushControllerImpl?(voiceMorpherController(context: context), true)
        }
    )
    
    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, state -> (ItemListControllerState, (ItemListNodeState, GhostgramSettingsControllerArguments)) in
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
    controller.didAppear = { (_: Bool) in
        let newState = GhostgramSettingsState.current()
        let _ = stateValue.modify { _ in newState }
        statePromise.set(newState)
    }
    
    pushControllerImpl = { [weak controller] c, animated in
        controller?.push(c)
    }
    return controller
}
