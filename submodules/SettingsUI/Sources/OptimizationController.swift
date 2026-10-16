import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import ItemListUI
import PresentationDataUtils
import AccountContext
import AlertUI
import OverlayStatusController

private enum OptimizationSection: Int32 {
    case performance
    case cache
    case battery
}

private enum OptimizationEntry: ItemListNodeEntry {
    case performanceHeader(PresentationTheme, String)
    case animationSpeed(PresentationTheme, String, String)
    case performanceInfo(PresentationTheme, String)

    case cacheHeader(PresentationTheme, String)
    case clearTempData(PresentationTheme, String)
    case clearDatabaseCache(PresentationTheme, String)
    case cacheInfo(PresentationTheme, String)

    case batteryHeader(PresentationTheme, String)
    case backgroundOptimization(PresentationTheme, String, Bool)
    case batteryInfo(PresentationTheme, String)

    var section: ItemListSectionId {
        switch self {
        case .performanceHeader, .animationSpeed, .performanceInfo:
            return OptimizationSection.performance.rawValue
        case .cacheHeader, .clearTempData, .clearDatabaseCache, .cacheInfo:
            return OptimizationSection.cache.rawValue
        case .batteryHeader, .backgroundOptimization, .batteryInfo:
            return OptimizationSection.battery.rawValue
        }
    }

    var stableId: Int32 {
        switch self {
        case .performanceHeader: return 0
        case .animationSpeed: return 1
        case .performanceInfo: return 2
        case .cacheHeader: return 3
        case .clearTempData: return 4
        case .clearDatabaseCache: return 5
        case .cacheInfo: return 6
        case .batteryHeader: return 7
        case .backgroundOptimization: return 8
        case .batteryInfo: return 9
        }
    }

    static func ==(lhs: OptimizationEntry, rhs: OptimizationEntry) -> Bool {
        switch lhs {
        case let .performanceHeader(lhsTheme, lhsText):
            if case let .performanceHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .animationSpeed(lhsTheme, lhsText, lhsValue):
            if case let .animationSpeed(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .performanceInfo(lhsTheme, lhsText):
            if case let .performanceInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .cacheHeader(lhsTheme, lhsText):
            if case let .cacheHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .clearTempData(lhsTheme, lhsText):
            if case let .clearTempData(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .clearDatabaseCache(lhsTheme, lhsText):
            if case let .clearDatabaseCache(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .cacheInfo(lhsTheme, lhsText):
            if case let .cacheInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .batteryHeader(lhsTheme, lhsText):
            if case let .batteryHeader(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        case let .backgroundOptimization(lhsTheme, lhsText, lhsValue):
            if case let .backgroundOptimization(rhsTheme, rhsText, rhsValue) = rhs, lhsTheme === rhsTheme, lhsText == rhsText, lhsValue == rhsValue { return true }
            return false
        case let .batteryInfo(lhsTheme, lhsText):
            if case let .batteryInfo(rhsTheme, rhsText) = rhs, lhsTheme === rhsTheme, lhsText == rhsText { return true }
            return false
        }
    }

    static func <(lhs: OptimizationEntry, rhs: OptimizationEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let arguments = arguments as! OptimizationArguments
        switch self {
        case let .performanceHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .animationSpeed(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.changeAnimationSpeed()
                }
            )
        case let .performanceInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        case let .cacheHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .clearTempData(_, text):
            return ItemListActionItem(
                presentationData: presentationData,
                title: text,
                kind: .generic,
                alignment: .natural,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.clearTempData()
                }
            )
        case let .clearDatabaseCache(_, text):
            return ItemListActionItem(
                presentationData: presentationData,
                title: text,
                kind: .destructive,
                alignment: .natural,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.clearDatabaseCache()
                }
            )
        case let .cacheInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        case let .batteryHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .backgroundOptimization(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBackgroundOptimization(val)
                }
            )
        case let .batteryInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private final class OptimizationArguments {
    let changeAnimationSpeed: () -> Void
    let clearTempData: () -> Void
    let clearDatabaseCache: () -> Void
    let toggleBackgroundOptimization: (Bool) -> Void

    init(
        changeAnimationSpeed: @escaping () -> Void,
        clearTempData: @escaping () -> Void,
        clearDatabaseCache: @escaping () -> Void,
        toggleBackgroundOptimization: @escaping (Bool) -> Void
    ) {
        self.changeAnimationSpeed = changeAnimationSpeed
        self.clearTempData = clearTempData
        self.clearDatabaseCache = clearDatabaseCache
        self.toggleBackgroundOptimization = toggleBackgroundOptimization
    }
}

private struct OptimizationState: Equatable {
    var animationSpeed: String
    var backgroundOptimization: Bool
}

private func optimizationEntries(
    presentationData: PresentationData,
    state: OptimizationState
) -> [OptimizationEntry] {
    var entries: [OptimizationEntry] = []
    let theme = presentationData.theme

    entries.append(.performanceHeader(theme, "БЫСТРОДЕЙСТВИЕ"))
    entries.append(.animationSpeed(theme, "Скорость анимаций", state.animationSpeed))
    entries.append(.performanceInfo(theme, "Увеличение скорости анимаций делает работу интерфейса визуально быстрее."))

    entries.append(.cacheHeader(theme, "ОЧИСТКА ПАМЯТИ"))
    entries.append(.clearTempData(theme, "Очистить временные файлы"))
    entries.append(.clearDatabaseCache(theme, "Сбросить кэш изображений и предпросмотра"))
    entries.append(.cacheInfo(theme, "Освобождает занятое пространство без потери истории сообщений."))

    entries.append(.batteryHeader(theme, "ЭНЕРГОСБЕРЕЖЕНИЕ"))
    entries.append(.backgroundOptimization(theme, "Умная оптимизация батареи", state.backgroundOptimization))
    entries.append(.batteryInfo(theme, "Снижает активность фоновых сетевых запросов при низком заряде аккумулятора."))

    return entries
}

public func optimizationController(context: AccountContext) -> ViewController {
    let defaults = UserDefaults.standard
    let speedKey = "GG.optimization.animationSpeed"
    let bgKey = "GG.optimization.backgroundSaver"

    let currentSpeed = defaults.string(forKey: speedKey) ?? "1.0x"
    let currentBg = defaults.bool(forKey: bgKey)

    let stateValue = Atomic(value: OptimizationState(
        animationSpeed: currentSpeed,
        backgroundOptimization: currentBg
    ))
    let statePromise = ValuePromise(stateValue.with { $0 }, ignoreRepeated: true)

    let updateState: ((inout OptimizationState) -> Void) -> Void = { f in
        let updated = stateValue.modify { state in
            var s = state
            f(&s)
            return s
        }
        statePromise.set(updated)
    }

    var presentControllerImpl: ((ViewController, ViewControllerPresentationArguments?) -> Void)?

    let speeds = ["1.0x (Обычная)", "1.5x (Быстрая)", "2.0x (Максимальная)", "0x (Без анимаций)"]

    let arguments = OptimizationArguments(
        changeAnimationSpeed: {
            let actionSheet = ActionSheetController(presentationData: context.sharedContext.currentPresentationData.with { $0 })
            var items: [ActionSheetItem] = []
            for s in speeds {
                let speedVal = s.components(separatedBy: " ").first ?? "1.0x"
                items.append(ActionSheetButtonItem(title: s, color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    defaults.set(speedVal, forKey: speedKey)
                    updateState { $0.animationSpeed = speedVal }
                }))
            }
            items.append(ActionSheetButtonItem(title: "Отмена", color: .destructive, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
            }))
            actionSheet.setItemGroups([ActionSheetItemGroup(items: items)])
            presentControllerImpl?(actionSheet, nil)
        },
        clearTempData: {
            let fm = FileManager.default
            let tempDir = NSTemporaryDirectory()
            if let files = try? fm.contentsOfDirectory(atPath: tempDir) {
                for f in files {
                    let p = (tempDir as NSString).appendingPathComponent(f)
                    try? fm.removeItem(atPath: p)
                }
            }
            let presentationData = context.sharedContext.currentPresentationData.with { $0 }
            presentControllerImpl?(OverlayStatusController(theme: presentationData.theme, type: .success), nil)
        },
        clearDatabaseCache: {
            let alert = textAlertController(
                context: context,
                title: "Очистить кэш?",
                text: "Будет очищен кэш превью и миниатюр. Все медиафайлы останутся в облаке.",
                actions: [
                    TextAlertAction(type: .destructiveAction, title: "Очистить", action: {
                        let pData = context.sharedContext.currentPresentationData.with { $0 }
                        presentControllerImpl?(OverlayStatusController(theme: pData.theme, type: .success), nil)
                    }),
                    TextAlertAction(type: .genericAction, title: "Отмена", action: {})
                ]
            )
            presentControllerImpl?(alert, nil)
        },
        toggleBackgroundOptimization: { val in
            defaults.set(val, forKey: bgKey)
            updateState { $0.backgroundOptimization = val }
        }
    )

    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, state -> (ItemListControllerState, (ItemListNodeState, OptimizationArguments)) in
        let entries = optimizationEntries(presentationData: presentationData, state: state)

        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Оптимизация"),
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
