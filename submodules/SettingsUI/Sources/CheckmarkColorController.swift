import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import ItemListUI
import PresentationDataUtils
import AlertUI
import AccountContext

private enum CheckmarkColorSection: Int32 {
    case toggle
    case mode
    case customHex
    case presets
}

private enum CheckmarkColorEntry: ItemListNodeEntry {
    case toggleHeader(PresentationTheme, String)
    case toggle(PresentationTheme, String, Bool)
    case toggleInfo(PresentationTheme, String)
    
    case modeHeader(PresentationTheme, String)
    case modeItem(PresentationTheme, String, ReadStatusColorMode, Bool)
    
    case customHexHeader(PresentationTheme, String)
    case customHexItem(PresentationTheme, String, String)
    
    case presetsHeader(PresentationTheme, String)
    case presetItem(PresentationTheme, String, String, Bool)

    var section: ItemListSectionId {
        switch self {
        case .toggleHeader, .toggle, .toggleInfo:
            return CheckmarkColorSection.toggle.rawValue
        case .modeHeader, .modeItem:
            return CheckmarkColorSection.mode.rawValue
        case .customHexHeader, .customHexItem:
            return CheckmarkColorSection.customHex.rawValue
        case .presetsHeader, .presetItem:
            return CheckmarkColorSection.presets.rawValue
        }
    }

    var stableId: Int32 {
        switch self {
        case .toggleHeader: return 0
        case .toggle: return 1
        case .toggleInfo: return 2
        case .modeHeader: return 3
        case let .modeItem(_, _, mode, _):
            switch mode {
            case .blue: return 4
            case .gray: return 5
            case .custom: return 6
            }
        case .customHexHeader: return 7
        case .customHexItem: return 8
        case .presetsHeader: return 9
        case let .presetItem(_, hex, _, _):
            return 10 + Int32(abs(hex.hashValue % 1000))
        }
    }

    static func ==(lhs: CheckmarkColorEntry, rhs: CheckmarkColorEntry) -> Bool {
        switch lhs {
        case let .toggleHeader(lhsTheme, lhsText):
            if case let .toggleHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .toggle(lhsTheme, lhsText, lhsValue):
            if case let .toggle(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .toggleInfo(lhsTheme, lhsText):
            if case let .toggleInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .modeHeader(lhsTheme, lhsText):
            if case let .modeHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .modeItem(lhsTheme, lhsText, lhsMode, lhsSelected):
            if case let .modeItem(rhsTheme, rhsText, rhsMode, rhsSelected) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsMode == rhsMode, lhsSelected == rhsSelected { return true }
            return false
        case let .customHexHeader(lhsTheme, lhsText):
            if case let .customHexHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .customHexItem(lhsTheme, lhsText, lhsValue):
            if case let .customHexItem(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .presetsHeader(lhsTheme, lhsText):
            if case let .presetsHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .presetItem(lhsTheme, lhsHex, lhsName, lhsSelected):
            if case let .presetItem(rhsTheme, rhsHex, rhsName, rhsSelected) = rhs, lhsTheme === rhsTheme, lhsHex == rhsHex, lhsName == rhsName, lhsSelected == rhsSelected { return true }
            return false
        }
    }

    static func <(lhs: CheckmarkColorEntry, rhs: CheckmarkColorEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let arguments = arguments as! CheckmarkColorArguments
        switch self {
        case let .toggleHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .toggle(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleEnabled(val)
                }
            )
        case let .toggleInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        case let .modeHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .modeItem(_, text, mode, selected):
            return ItemListCheckboxItem(
                presentationData: presentationData,
                title: text,
                style: .left,
                checked: selected,
                zeroSeparatorInsets: false,
                sectionId: self.section,
                action: {
                    arguments.selectMode(mode)
                }
            )
        case let .customHexHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .customHexItem(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.editCustomHex()
                }
            )
        case let .presetsHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .presetItem(_, hex, name, selected):
            return ItemListCheckboxItem(
                presentationData: presentationData,
                title: "\(name) (\(hex))",
                style: .left,
                checked: selected,
                zeroSeparatorInsets: false,
                sectionId: self.section,
                action: {
                    arguments.selectPreset(hex)
                }
            )
        }
    }
}

private final class CheckmarkColorArguments {
    let toggleEnabled: (Bool) -> Void
    let selectMode: (ReadStatusColorMode) -> Void
    let editCustomHex: () -> Void
    let selectPreset: (String) -> Void

    init(
        toggleEnabled: @escaping (Bool) -> Void,
        selectMode: @escaping (ReadStatusColorMode) -> Void,
        editCustomHex: @escaping () -> Void,
        selectPreset: @escaping (String) -> Void
    ) {
        self.toggleEnabled = toggleEnabled
        self.selectMode = selectMode
        self.editCustomHex = editCustomHex
        self.selectPreset = selectPreset
    }
}

private struct CheckmarkColorState: Equatable {
    var isEnabled: Bool
    var mode: ReadStatusColorMode
    var customHex: String
}

private let colorPresets: [(hex: String, name: String)] = [
    ("#3390EC", "Telegram Blue"),
    ("#4CAF50", "Зеленый"),
    ("#9C27B0", "Фиолетовый"),
    ("#E91E63", "Розовый"),
    ("#FF9800", "Оранжевый"),
    ("#00BCD4", "Голубой"),
    ("#FFD700", "Золотой"),
    ("#E53935", "Красный")
]

private func checkmarkColorEntries(
    presentationData: PresentationData,
    state: CheckmarkColorState
) -> [CheckmarkColorEntry] {
    var entries: [CheckmarkColorEntry] = []
    let theme = presentationData.theme

    entries.append(.toggleHeader(theme, "ЦВЕТ ГАЛОЧЕК ПРОЧИТАННОГО"))
    entries.append(.toggle(theme, "Кастомный цвет галочек", state.isEnabled))
    entries.append(.toggleInfo(theme, "Позволяет переопределить стандартный синий цвет двух галочек прочитанного сообщения."))

    if state.isEnabled {
        entries.append(.modeHeader(theme, "РЕЖИМ"))
        entries.append(.modeItem(theme, "Синий (Telegram)", .blue, state.mode == .blue))
        entries.append(.modeItem(theme, "Серый (Нейтральный)", .gray, state.mode == .gray))
        entries.append(.modeItem(theme, "Пользовательский цвет", .custom, state.mode == .custom))

        if state.mode == .custom {
            entries.append(.customHexHeader(theme, "HEX ЗНАЧЕНИЕ"))
            entries.append(.customHexItem(theme, "Текущий цвет", state.customHex))

            entries.append(.presetsHeader(theme, "ГОТОВЫЕ ЦВЕТА"))
            for preset in colorPresets {
                let isSelected = state.customHex.uppercased() == preset.hex.uppercased()
                entries.append(.presetItem(theme, preset.hex, preset.name, isSelected))
            }
        }
    }

    return entries
}

public func checkmarkColorController(context: AccountContext) -> ViewController {
    let manager = FontCustomizationManager.shared
    let stateValue = Atomic(value: CheckmarkColorState(
        isEnabled: manager.readStatusColorEnabled,
        mode: manager.readStatusColorMode,
        customHex: manager.readStatusCustomColor
    ))
    let statePromise = ValuePromise(stateValue.with { $0 }, ignoreRepeated: true)

    let updateState: ((inout CheckmarkColorState) -> Void) -> Void = { f in
        let updated = stateValue.modify { state in
            var s = state
            f(&s)
            return s
        }
        statePromise.set(updated)
    }

    var presentControllerImpl: ((ViewController, ViewControllerPresentationArguments?) -> Void)?

    let arguments = CheckmarkColorArguments(
        toggleEnabled: { val in
            manager.readStatusColorEnabled = val
            updateState { $0.isEnabled = val }
        },
        selectMode: { mode in
            manager.readStatusColorMode = mode
            updateState { $0.mode = mode }
        },
        editCustomHex: {
            let actionSheet = ActionSheetController(presentationData: context.sharedContext.currentPresentationData.with { $0 })
            let colors: [(String, String)] = [
                ("#FF2D55", "Ярко-розовый"),
                ("#5856D6", "Индиго"),
                ("#AF52DE", "Пурпурный"),
                ("#007AFF", "Синий"),
                ("#34C759", "Изумрудный"),
                ("#FF9500", "Оранжевый"),
                ("#FFCC00", "Желтый"),
                ("#5AC8FA", "Бирюзовый"),
                ("#FFFFFF", "Белый"),
                ("#000000", "Черный")
            ]
            var items: [ActionSheetItem] = []
            for (hex, name) in colors {
                items.append(ActionSheetButtonItem(title: "\(name) (\(hex))", color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    manager.readStatusCustomColor = hex
                    updateState { $0.customHex = hex }
                }))
            }
            items.append(ActionSheetButtonItem(title: "Отмена", color: .destructive, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
            }))
            actionSheet.setItemGroups([ActionSheetItemGroup(items: items)])
            presentControllerImpl?(actionSheet, nil)
        },
        selectPreset: { hex in
            manager.readStatusCustomColor = hex
            updateState { $0.customHex = hex }
        }
    )

    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, state -> (ItemListControllerState, (ItemListNodeState, CheckmarkColorArguments)) in
        let entries = checkmarkColorEntries(presentationData: presentationData, state: state)

        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Цвет галочек"),
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
    presentControllerImpl = { [weak controller] c, presentationArguments in
        controller?.present(c, in: .window(.root), with: presentationArguments)
    }
    return controller
}
