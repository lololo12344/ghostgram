import Foundation
import UIKit
import Display
import SwiftSignalKit
import TelegramCore
import TelegramPresentationData
import ItemListUI
import AccountContext

private enum FontCustomizationSection: Int32 {
    case fonts
    case amoled
    case chat
    case snowflakes
    case bindButtons
}

private enum FontCustomizationEntry: ItemListNodeEntry {
    case fontsHeader(PresentationTheme, String)
    case customFontToggle(PresentationTheme, String, Bool)
    case fontItem(PresentationTheme, String, GhostgramFont, Bool)
    case fontsInfo(PresentationTheme, String)

    case amoledHeader(PresentationTheme, String)
    case amoledTrueBlack(PresentationTheme, String, Bool)
    case amoledKeyboard(PresentationTheme, String, Bool)
    case hideCellSeparators(PresentationTheme, String, Bool)
    case squareAvatars(PresentationTheme, String, Bool)
    case avatarSquareness(PresentationTheme, String, String)
    case senderMiniAvatars(PresentationTheme, String, Bool)
    case onlineIndicator(PresentationTheme, String, Bool)
    case exactLastSeen(PresentationTheme, String, Bool)

    case chatHeader(PresentationTheme, String)
    case checkmarkColor(PresentationTheme, String, String)
    case doubleTapToCopy(PresentationTheme, String, Bool)
    case tripleTapDelete(PresentationTheme, String, String)
    case contextLocalEdit(PresentationTheme, String, Bool)
    case hideEditedStatus(PresentationTheme, String, Bool)
    case hideMessageTimestamps(PresentationTheme, String, Bool)
    case hideChannelComments(PresentationTheme, String, Bool)
    case hideChannelViewCounts(PresentationTheme, String, Bool)
    case hideStoryCircles(PresentationTheme, String, Bool)
    case hideChatListSearchBar(PresentationTheme, String, Bool)
    case hideProfileDescription(PresentationTheme, String, Bool)
    case connectionStatusText(PresentationTheme, String, Bool)
    case autoMuteNewChannels(PresentationTheme, String, Bool)

    case snowflakesHeader(PresentationTheme, String)
    case snowflakesApp(PresentationTheme, String, Bool)
    case snowflakesChat(PresentationTheme, String, Bool)

    case bindButtonsHeader(PresentationTheme, String)
    case bindButtonsToggle(PresentationTheme, String, Bool)
    case bindGhostMode(PresentationTheme, String, Bool)
    case bindDeletedMessages(PresentationTheme, String, Bool)
    case bindScrollToTop(PresentationTheme, String, Bool)
    case bindScheduledMessages(PresentationTheme, String, Bool)
    case bindScreenshotPrivacy(PresentationTheme, String, Bool)
    case bindTranslate(PresentationTheme, String, Bool)
    case bindButtonsInfo(PresentationTheme, String)

    var section: ItemListSectionId {
        switch self {
        case .fontsHeader, .customFontToggle, .fontItem, .fontsInfo:
            return FontCustomizationSection.fonts.rawValue
        case .amoledHeader, .amoledTrueBlack, .amoledKeyboard, .hideCellSeparators, .squareAvatars, .avatarSquareness, .senderMiniAvatars, .onlineIndicator, .exactLastSeen:
            return FontCustomizationSection.amoled.rawValue
        case .chatHeader, .checkmarkColor, .doubleTapToCopy, .tripleTapDelete, .contextLocalEdit, .hideEditedStatus, .hideMessageTimestamps, .hideChannelComments, .hideChannelViewCounts, .hideStoryCircles, .hideChatListSearchBar, .hideProfileDescription, .connectionStatusText, .autoMuteNewChannels:
            return FontCustomizationSection.chat.rawValue
        case .snowflakesHeader, .snowflakesApp, .snowflakesChat:
            return FontCustomizationSection.snowflakes.rawValue
        case .bindButtonsHeader, .bindButtonsToggle, .bindGhostMode, .bindDeletedMessages, .bindScrollToTop, .bindScheduledMessages, .bindScreenshotPrivacy, .bindTranslate, .bindButtonsInfo:
            return FontCustomizationSection.bindButtons.rawValue
        }
    }

    var stableId: Int32 {
        switch self {
        case .fontsHeader: return 0
        case .customFontToggle: return 1
        case let .fontItem(_, _, font, _):
            return 2 + Int32(abs(font.rawValue.hashValue % 100))
        case .fontsInfo: return 105
        case .amoledHeader: return 106
        case .amoledTrueBlack: return 107
        case .amoledKeyboard: return 108
        case .hideCellSeparators: return 109
        case .squareAvatars: return 110
        case .avatarSquareness: return 111
        case .senderMiniAvatars: return 112
        case .onlineIndicator: return 113
        case .exactLastSeen: return 114
        case .chatHeader: return 200
        case .checkmarkColor: return 201
        case .doubleTapToCopy: return 202
        case .tripleTapDelete: return 203
        case .contextLocalEdit: return 204
        case .hideEditedStatus: return 205
        case .hideMessageTimestamps: return 206
        case .hideChannelComments: return 207
        case .hideChannelViewCounts: return 208
        case .hideStoryCircles: return 209
        case .hideChatListSearchBar: return 210
        case .hideProfileDescription: return 211
        case .connectionStatusText: return 212
        case .autoMuteNewChannels: return 213
        case .snowflakesHeader: return 300
        case .snowflakesApp: return 301
        case .snowflakesChat: return 302
        case .bindButtonsHeader: return 400
        case .bindButtonsToggle: return 401
        case .bindGhostMode: return 402
        case .bindDeletedMessages: return 403
        case .bindScrollToTop: return 404
        case .bindScheduledMessages: return 405
        case .bindScreenshotPrivacy: return 406
        case .bindTranslate: return 407
        case .bindButtonsInfo: return 408
        }
    }

    static func ==(lhs: FontCustomizationEntry, rhs: FontCustomizationEntry) -> Bool {
        switch lhs {
        case let .fontsHeader(lT, lTxt):
            if case let .fontsHeader(rT, rTxt) = rhs, lT === rT, lTxt == rTxt { return true }
            return false
        case let .customFontToggle(lT, lTxt, lV):
            if case let .customFontToggle(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .fontItem(lT, lTxt, lF, lS):
            if case let .fontItem(rT, rTxt, rF, rS) = rhs, lT === rT, lTxt == rTxt, lF == rF, lS == rS { return true }
            return false
        case let .fontsInfo(lT, lTxt):
            if case let .fontsInfo(rT, rTxt) = rhs, lT === rT, lTxt == rTxt { return true }
            return false
        case let .amoledHeader(lT, lTxt):
            if case let .amoledHeader(rT, rTxt) = rhs, lT === rT, lTxt == rTxt { return true }
            return false
        case let .amoledTrueBlack(lT, lTxt, lV):
            if case let .amoledTrueBlack(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .amoledKeyboard(lT, lTxt, lV):
            if case let .amoledKeyboard(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideCellSeparators(lT, lTxt, lV):
            if case let .hideCellSeparators(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .squareAvatars(lT, lTxt, lV):
            if case let .squareAvatars(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .avatarSquareness(lT, lTxt, lV):
            if case let .avatarSquareness(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .senderMiniAvatars(lT, lTxt, lV):
            if case let .senderMiniAvatars(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .onlineIndicator(lT, lTxt, lV):
            if case let .onlineIndicator(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .exactLastSeen(lT, lTxt, lV):
            if case let .exactLastSeen(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .chatHeader(lT, lTxt):
            if case let .chatHeader(rT, rTxt) = rhs, lT === rT, lTxt == rTxt { return true }
            return false
        case let .checkmarkColor(lT, lTxt, lV):
            if case let .checkmarkColor(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .doubleTapToCopy(lT, lTxt, lV):
            if case let .doubleTapToCopy(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .tripleTapDelete(lT, lTxt, lV):
            if case let .tripleTapDelete(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .contextLocalEdit(lT, lTxt, lV):
            if case let .contextLocalEdit(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideEditedStatus(lT, lTxt, lV):
            if case let .hideEditedStatus(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideMessageTimestamps(lT, lTxt, lV):
            if case let .hideMessageTimestamps(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideChannelComments(lT, lTxt, lV):
            if case let .hideChannelComments(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideChannelViewCounts(lT, lTxt, lV):
            if case let .hideChannelViewCounts(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideStoryCircles(lT, lTxt, lV):
            if case let .hideStoryCircles(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideChatListSearchBar(lT, lTxt, lV):
            if case let .hideChatListSearchBar(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .hideProfileDescription(lT, lTxt, lV):
            if case let .hideProfileDescription(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .connectionStatusText(lT, lTxt, lV):
            if case let .connectionStatusText(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .autoMuteNewChannels(lT, lTxt, lV):
            if case let .autoMuteNewChannels(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .snowflakesHeader(lT, lTxt):
            if case let .snowflakesHeader(rT, rTxt) = rhs, lT === rT, lTxt == rTxt { return true }
            return false
        case let .snowflakesApp(lT, lTxt, lV):
            if case let .snowflakesApp(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .snowflakesChat(lT, lTxt, lV):
            if case let .snowflakesChat(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindButtonsHeader(lT, lTxt):
            if case let .bindButtonsHeader(rT, rTxt) = rhs, lT === rT, lTxt == rTxt { return true }
            return false
        case let .bindButtonsToggle(lT, lTxt, lV):
            if case let .bindButtonsToggle(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindGhostMode(lT, lTxt, lV):
            if case let .bindGhostMode(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindDeletedMessages(lT, lTxt, lV):
            if case let .bindDeletedMessages(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindScrollToTop(lT, lTxt, lV):
            if case let .bindScrollToTop(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindScheduledMessages(lT, lTxt, lV):
            if case let .bindScheduledMessages(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindScreenshotPrivacy(lT, lTxt, lV):
            if case let .bindScreenshotPrivacy(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindTranslate(lT, lTxt, lV):
            if case let .bindTranslate(rT, rTxt, rV) = rhs, lT === rT, lTxt == rTxt, lV == rV { return true }
            return false
        case let .bindButtonsInfo(lT, lTxt):
            if case let .bindButtonsInfo(rT, rTxt) = rhs, lT === rT, lTxt == rTxt { return true }
            return false
        }
    }

    static func <(lhs: FontCustomizationEntry, rhs: FontCustomizationEntry) -> Bool {
        return lhs.stableId < rhs.stableId
    }

    func item(presentationData: ItemListPresentationData, arguments: Any) -> ListViewItem {
        let arguments = arguments as! FontCustomizationArguments
        switch self {
        case let .fontsHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .customFontToggle(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleCustomFont(val)
                }
            )
        case let .fontItem(_, text, font, selected):
            return ItemListCheckboxItem(
                presentationData: presentationData,
                title: text,
                style: .left,
                checked: selected,
                zeroSeparatorInsets: false,
                sectionId: self.section,
                action: {
                    arguments.selectFont(font)
                }
            )
        case let .fontsInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        case let .amoledHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .amoledTrueBlack(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleAmoledTrueBlack(val)
                }
            )
        case let .amoledKeyboard(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleAmoledKeyboard(val)
                }
            )
        case let .hideCellSeparators(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideCellSeparators(val)
                }
            )
        case let .squareAvatars(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleSquareAvatars(val)
                }
            )
        case let .avatarSquareness(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.changeAvatarSquareness()
                }
            )
        case let .senderMiniAvatars(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleSenderMiniAvatars(val)
                }
            )
        case let .onlineIndicator(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleOnlineIndicator(val)
                }
            )
        case let .exactLastSeen(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleExactLastSeen(val)
                }
            )
        case let .chatHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
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
        case let .doubleTapToCopy(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleDoubleTapToCopy(val)
                }
            )
        case let .tripleTapDelete(_, text, value):
            return ItemListDisclosureItem(
                presentationData: presentationData,
                title: text,
                label: value,
                sectionId: self.section,
                style: .blocks,
                action: {
                    arguments.changeTripleTapDelete()
                }
            )
        case let .contextLocalEdit(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleContextLocalEdit(val)
                }
            )
        case let .hideEditedStatus(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideEditedStatus(val)
                }
            )
        case let .hideMessageTimestamps(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideMessageTimestamps(val)
                }
            )
        case let .hideChannelComments(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideChannelComments(val)
                }
            )
        case let .hideChannelViewCounts(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideChannelViewCounts(val)
                }
            )
        case let .hideStoryCircles(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideStoryCircles(val)
                }
            )
        case let .hideChatListSearchBar(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideChatListSearchBar(val)
                }
            )
        case let .hideProfileDescription(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleHideProfileDescription(val)
                }
            )
        case let .connectionStatusText(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleConnectionStatusText(val)
                }
            )
        case let .autoMuteNewChannels(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleAutoMuteNewChannels(val)
                }
            )
        case let .snowflakesHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .snowflakesApp(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleSnowflakesApp(val)
                }
            )
        case let .snowflakesChat(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleSnowflakesChat(val)
                }
            )
        case let .bindButtonsHeader(_, text):
            return ItemListSectionHeaderItem(presentationData: presentationData, text: text, sectionId: self.section)
        case let .bindButtonsToggle(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBindButtons(val)
                }
            )
        case let .bindGhostMode(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBindGhostMode(val)
                }
            )
        case let .bindDeletedMessages(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBindDeletedMessages(val)
                }
            )
        case let .bindScrollToTop(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBindScrollToTop(val)
                }
            )
        case let .bindScheduledMessages(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBindScheduledMessages(val)
                }
            )
        case let .bindScreenshotPrivacy(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBindScreenshotPrivacy(val)
                }
            )
        case let .bindTranslate(_, text, value):
            return ItemListSwitchItem(
                presentationData: presentationData,
                title: text,
                value: value,
                sectionId: self.section,
                style: .blocks,
                updated: { val in
                    arguments.toggleBindTranslate(val)
                }
            )
        case let .bindButtonsInfo(_, text):
            return ItemListTextItem(presentationData: presentationData, text: .plain(text), sectionId: self.section)
        }
    }
}

private final class FontCustomizationArguments {
    let toggleCustomFont: (Bool) -> Void
    let selectFont: (GhostgramFont) -> Void
    let toggleAmoledTrueBlack: (Bool) -> Void
    let toggleAmoledKeyboard: (Bool) -> Void
    let toggleHideCellSeparators: (Bool) -> Void
    let toggleSquareAvatars: (Bool) -> Void
    let changeAvatarSquareness: () -> Void
    let toggleSenderMiniAvatars: (Bool) -> Void
    let toggleOnlineIndicator: (Bool) -> Void
    let toggleExactLastSeen: (Bool) -> Void
    let openCheckmarkColor: () -> Void
    let toggleDoubleTapToCopy: (Bool) -> Void
    let changeTripleTapDelete: () -> Void
    let toggleContextLocalEdit: (Bool) -> Void
    let toggleHideEditedStatus: (Bool) -> Void
    let toggleHideMessageTimestamps: (Bool) -> Void
    let toggleHideChannelComments: (Bool) -> Void
    let toggleHideChannelViewCounts: (Bool) -> Void
    let toggleHideStoryCircles: (Bool) -> Void
    let toggleHideChatListSearchBar: (Bool) -> Void
    let toggleHideProfileDescription: (Bool) -> Void
    let toggleConnectionStatusText: (Bool) -> Void
    let toggleAutoMuteNewChannels: (Bool) -> Void
    let toggleSnowflakesApp: (Bool) -> Void
    let toggleSnowflakesChat: (Bool) -> Void
    let toggleBindButtons: (Bool) -> Void
    let toggleBindGhostMode: (Bool) -> Void
    let toggleBindDeletedMessages: (Bool) -> Void
    let toggleBindScrollToTop: (Bool) -> Void
    let toggleBindScheduledMessages: (Bool) -> Void
    let toggleBindScreenshotPrivacy: (Bool) -> Void
    let toggleBindTranslate: (Bool) -> Void

    init(
        toggleCustomFont: @escaping (Bool) -> Void,
        selectFont: @escaping (GhostgramFont) -> Void,
        toggleAmoledTrueBlack: @escaping (Bool) -> Void,
        toggleAmoledKeyboard: @escaping (Bool) -> Void,
        toggleHideCellSeparators: @escaping (Bool) -> Void,
        toggleSquareAvatars: @escaping (Bool) -> Void,
        changeAvatarSquareness: @escaping () -> Void,
        toggleSenderMiniAvatars: @escaping (Bool) -> Void,
        toggleOnlineIndicator: @escaping (Bool) -> Void,
        toggleExactLastSeen: @escaping (Bool) -> Void,
        openCheckmarkColor: @escaping () -> Void,
        toggleDoubleTapToCopy: @escaping (Bool) -> Void,
        changeTripleTapDelete: @escaping () -> Void,
        toggleContextLocalEdit: @escaping (Bool) -> Void,
        toggleHideEditedStatus: @escaping (Bool) -> Void,
        toggleHideMessageTimestamps: @escaping (Bool) -> Void,
        toggleHideChannelComments: @escaping (Bool) -> Void,
        toggleHideChannelViewCounts: @escaping (Bool) -> Void,
        toggleHideStoryCircles: @escaping (Bool) -> Void,
        toggleHideChatListSearchBar: @escaping (Bool) -> Void,
        toggleHideProfileDescription: @escaping (Bool) -> Void,
        toggleConnectionStatusText: @escaping (Bool) -> Void,
        toggleAutoMuteNewChannels: @escaping (Bool) -> Void,
        toggleSnowflakesApp: @escaping (Bool) -> Void,
        toggleSnowflakesChat: @escaping (Bool) -> Void,
        toggleBindButtons: @escaping (Bool) -> Void,
        toggleBindGhostMode: @escaping (Bool) -> Void,
        toggleBindDeletedMessages: @escaping (Bool) -> Void,
        toggleBindScrollToTop: @escaping (Bool) -> Void,
        toggleBindScheduledMessages: @escaping (Bool) -> Void,
        toggleBindScreenshotPrivacy: @escaping (Bool) -> Void,
        toggleBindTranslate: @escaping (Bool) -> Void
    ) {
        self.toggleCustomFont = toggleCustomFont
        self.selectFont = selectFont
        self.toggleAmoledTrueBlack = toggleAmoledTrueBlack
        self.toggleAmoledKeyboard = toggleAmoledKeyboard
        self.toggleHideCellSeparators = toggleHideCellSeparators
        self.toggleSquareAvatars = toggleSquareAvatars
        self.changeAvatarSquareness = changeAvatarSquareness
        self.toggleSenderMiniAvatars = toggleSenderMiniAvatars
        self.toggleOnlineIndicator = toggleOnlineIndicator
        self.toggleExactLastSeen = toggleExactLastSeen
        self.openCheckmarkColor = openCheckmarkColor
        self.toggleDoubleTapToCopy = toggleDoubleTapToCopy
        self.changeTripleTapDelete = changeTripleTapDelete
        self.toggleContextLocalEdit = toggleContextLocalEdit
        self.toggleHideEditedStatus = toggleHideEditedStatus
        self.toggleHideMessageTimestamps = toggleHideMessageTimestamps
        self.toggleHideChannelComments = toggleHideChannelComments
        self.toggleHideChannelViewCounts = toggleHideChannelViewCounts
        self.toggleHideStoryCircles = toggleHideStoryCircles
        self.toggleHideChatListSearchBar = toggleHideChatListSearchBar
        self.toggleHideProfileDescription = toggleHideProfileDescription
        self.toggleConnectionStatusText = toggleConnectionStatusText
        self.toggleAutoMuteNewChannels = toggleAutoMuteNewChannels
        self.toggleSnowflakesApp = toggleSnowflakesApp
        self.toggleSnowflakesChat = toggleSnowflakesChat
        self.toggleBindButtons = toggleBindButtons
        self.toggleBindGhostMode = toggleBindGhostMode
        self.toggleBindDeletedMessages = toggleBindDeletedMessages
        self.toggleBindScrollToTop = toggleBindScrollToTop
        self.toggleBindScheduledMessages = toggleBindScheduledMessages
        self.toggleBindScreenshotPrivacy = toggleBindScreenshotPrivacy
        self.toggleBindTranslate = toggleBindTranslate
    }
}

private struct FontCustomizationState: Equatable {
    var isFontEnabled: Bool
    var selectedFont: GhostgramFont
    var amoledTrueBlack: Bool
    var amoledKeyboard: Bool
    var hideCellSeparators: Bool
    var squareAvatars: Bool
    var avatarSquareness: Int32
    var senderMiniAvatars: Bool
    var onlineIndicator: Bool
    var exactLastSeen: Bool
    var checkmarkColorModeText: String
    var doubleTapToCopy: Bool
    var tripleTapDelete: TripleTapDeleteMode
    var contextLocalEdit: Bool
    var hideEditedStatus: Bool
    var hideMessageTimestamps: Bool
    var hideChannelComments: Bool
    var hideChannelViewCounts: Bool
    var hideStoryCircles: Bool
    var hideChatListSearchBar: Bool
    var hideProfileDescription: Bool
    var connectionStatusText: Bool
    var autoMuteNewChannels: Bool
    var snowflakesApp: Bool
    var snowflakesChat: Bool
    var bindButtonsEnabled: Bool
    var bindGhostMode: Bool
    var bindDeletedMessages: Bool
    var bindScrollToTop: Bool
    var bindScheduledMessages: Bool
    var bindScreenshotPrivacy: Bool
    var bindTranslate: Bool

    static func current() -> FontCustomizationState {
        let m = FontCustomizationManager.shared
        let checkmarkText: String
        if !m.readStatusColorEnabled {
            checkmarkText = "По умолчанию"
        } else {
            switch m.readStatusColorMode {
            case .blue: checkmarkText = "Синий"
            case .gray: checkmarkText = "Серый"
            case .custom: checkmarkText = m.readStatusCustomColor
            }
        }

        return FontCustomizationState(
            isFontEnabled: m.isEnabled,
            selectedFont: m.selectedFont,
            amoledTrueBlack: m.amoledTrueBlackEnabled,
            amoledKeyboard: m.amoledKeyboardEnabled,
            hideCellSeparators: m.hideCellSeparatorsEnabled,
            squareAvatars: m.squareAvatarsInChatList,
            avatarSquareness: m.avatarSquarenessLevel,
            senderMiniAvatars: m.senderMiniAvatarsEnabled,
            onlineIndicator: m.chatAvatarOnlineIndicator,
            exactLastSeen: m.showExactLastSeen,
            checkmarkColorModeText: checkmarkText,
            doubleTapToCopy: m.doubleTapToCopyIncoming,
            tripleTapDelete: m.tripleTapDeleteMode,
            contextLocalEdit: m.contextShowLocalEdit,
            hideEditedStatus: m.hideEditedStatus,
            hideMessageTimestamps: m.hideMessageTimestamps,
            hideChannelComments: m.hideChannelComments,
            hideChannelViewCounts: m.hideChannelViewCounts,
            hideStoryCircles: m.hideStoryCirclesInChatList,
            hideChatListSearchBar: m.hideChatListSearchBar,
            hideProfileDescription: m.hideProfileDescription,
            connectionStatusText: m.showConnectionStatusText,
            autoMuteNewChannels: m.autoMuteNewChannels,
            snowflakesApp: m.snowflakesEnabled,
            snowflakesChat: m.snowflakesInChatEnabled,
            bindButtonsEnabled: m.showBindButtons,
            bindGhostMode: m.showGhostModeBind,
            bindDeletedMessages: m.showDeletedMessagesBind,
            bindScrollToTop: m.showScrollToTopBind,
            bindScheduledMessages: m.showScheduledMessagesBind,
            bindScreenshotPrivacy: m.showScreenshotPrivacyBind,
            bindTranslate: m.showTranslateBeforeSendBind
        )
    }
}

private func fontCustomizationEntries(
    presentationData: PresentationData,
    state: FontCustomizationState
) -> [FontCustomizationEntry] {
    var entries: [FontCustomizationEntry] = []
    let theme = presentationData.theme

    // Fonts
    entries.append(.fontsHeader(theme, "ШРИФТЫ"))
    entries.append(.customFontToggle(theme, "Пользовательский шрифт", state.isFontEnabled))
    if state.isFontEnabled {
        let bundledFonts: [GhostgramFont] = [
            .sourceSansPro,
            .workSans,
            .sourceCodePro,
            .sourceSerifPro,
            .nanumSquareRound,
            .mononoki,
            .metropolis,
            .roboto,
            .openSans,
            .lato,
            .raleway,
            .montserrat
        ]
        for font in bundledFonts {
            entries.append(.fontItem(theme, font.displayName, font, state.selectedFont == font))
        }
    }
    entries.append(.fontsInfo(theme, "Выбранный шрифт применяется ко всем элементам интерфейса Ghostgram."))

    // AMOLED & Appearance
    entries.append(.amoledHeader(theme, "ОФОРМЛЕНИЕ & AMOLED"))
    entries.append(.amoledTrueBlack(theme, "True Black AMOLED", state.amoledTrueBlack))
    entries.append(.amoledKeyboard(theme, "AMOLED клавиатура", state.amoledKeyboard))
    entries.append(.hideCellSeparators(theme, "Скрыть разделители ячеек", state.hideCellSeparators))
    entries.append(.squareAvatars(theme, "Квадратные аватары в чатах", state.squareAvatars))
    entries.append(.avatarSquareness(theme, "Радиус скругления аватаров", "\(state.avatarSquareness) px"))
    entries.append(.senderMiniAvatars(theme, "Мини-аватары авторов в группах", state.senderMiniAvatars))
    entries.append(.onlineIndicator(theme, "Точка 'В сети' на аватарах", state.onlineIndicator))
    entries.append(.exactLastSeen(theme, "Точное время последнего визита", state.exactLastSeen))

    // Chat & Messages
    entries.append(.chatHeader(theme, "ЧАТ И СООБЩЕНИЯ"))
    entries.append(.checkmarkColor(theme, "Цвет галочек прочитанного", state.checkmarkColorModeText))
    entries.append(.doubleTapToCopy(theme, "Двойной тап: скопировать текст", state.doubleTapToCopy))

    let deleteTitle: String
    switch state.tripleTapDelete {
    case .none: deleteTitle = "Выключено"
    case .local: deleteTitle = "Только у меня"
    case .everyone: deleteTitle = "У всех"
    }
    entries.append(.tripleTapDelete(theme, "Тройной тап: удалить сообщение", deleteTitle))
    entries.append(.contextLocalEdit(theme, "Локальное редактирование сообщений", state.contextLocalEdit))
    entries.append(.hideEditedStatus(theme, "Скрыть отметку 'изменено'", state.hideEditedStatus))
    entries.append(.hideMessageTimestamps(theme, "Скрыть время сообщений", state.hideMessageTimestamps))
    entries.append(.hideChannelComments(theme, "Скрыть кнопку комментариев", state.hideChannelComments))
    entries.append(.hideChannelViewCounts(theme, "Скрыть просмотры постов", state.hideChannelViewCounts))
    entries.append(.hideStoryCircles(theme, "Скрыть кружки историй в чатах", state.hideStoryCircles))
    entries.append(.hideChatListSearchBar(theme, "Скрыть строку поиска в чатах", state.hideChatListSearchBar))
    entries.append(.hideProfileDescription(theme, "Скрыть описание в профилях", state.hideProfileDescription))
    entries.append(.connectionStatusText(theme, "Статус подключения в заголовке", state.connectionStatusText))
    entries.append(.autoMuteNewChannels(theme, "Без звука для новых каналов", state.autoMuteNewChannels))

    // Snowflakes
    entries.append(.snowflakesHeader(theme, "СНЕГОПАД"))
    entries.append(.snowflakesApp(theme, "Снежинки в приложении", state.snowflakesApp))
    entries.append(.snowflakesChat(theme, "Снежинки внутри чатов", state.snowflakesChat))

    // Bind Buttons
    entries.append(.bindButtonsHeader(theme, "ПЛАВАЮЩИЕ КНОПКИ"))
    entries.append(.bindButtonsToggle(theme, "Включить плавающие кнопки", state.bindButtonsEnabled))
    if state.bindButtonsEnabled {
        entries.append(.bindGhostMode(theme, "Режим невидимки", state.bindGhostMode))
        entries.append(.bindDeletedMessages(theme, "Анти-удаление сообщений", state.bindDeletedMessages))
        entries.append(.bindScrollToTop(theme, "Прокрутка в самое начало", state.bindScrollToTop))
        entries.append(.bindScheduledMessages(theme, "Запланированные сообщения", state.bindScheduledMessages))
        entries.append(.bindScreenshotPrivacy(theme, "Анти-скриншот уведомление", state.bindScreenshotPrivacy))
        entries.append(.bindTranslate(theme, "Перевод перед отправкой", state.bindTranslate))
    }
    entries.append(.bindButtonsInfo(theme, "Быстрые плавающие кнопки отображаются поверх списка чатов для мгновенного доступа к функциям."))

    return entries
}

public func fontCustomizationController(context: AccountContext) -> ViewController {
    let manager = FontCustomizationManager.shared
    var pushControllerImpl: ((ViewController, Bool) -> Void)?
    var presentControllerImpl: ((ViewController, ViewControllerPresentationArguments?) -> Void)?

    let stateValue = Atomic(value: FontCustomizationState.current())
    let statePromise = ValuePromise(stateValue.with { $0 }, ignoreRepeated: true)

    let updateState: ((inout FontCustomizationState) -> Void) -> Void = { f in
        let updated = stateValue.modify { state in
            var s = state
            f(&s)
            return s
        }
        statePromise.set(updated)
    }

    let arguments = FontCustomizationArguments(
        toggleCustomFont: { val in
            manager.isEnabled = val
            updateState { $0.isFontEnabled = val }
        },
        selectFont: { font in
            manager.selectedFont = font
            updateState { $0.selectedFont = font }
        },
        toggleAmoledTrueBlack: { val in
            manager.amoledTrueBlackEnabled = val
            updateState { $0.amoledTrueBlack = val }
        },
        toggleAmoledKeyboard: { val in
            manager.amoledKeyboardEnabled = val
            updateState { $0.amoledKeyboard = val }
        },
        toggleHideCellSeparators: { val in
            manager.hideCellSeparatorsEnabled = val
            updateState { $0.hideCellSeparators = val }
        },
        toggleSquareAvatars: { val in
            manager.squareAvatarsInChatList = val
            updateState { $0.squareAvatars = val }
        },
        changeAvatarSquareness: {
            let actionSheet = ActionSheetController(presentationData: context.sharedContext.currentPresentationData.with { $0 })
            let levels: [(Int32, String)] = [(0, "0 px (Круглые)"), (4, "4 px"), (8, "8 px (Скругленные)"), (14, "14 px"), (24, "24 px (Квадратные)")]
            var items: [ActionSheetItem] = []
            for (lvl, title) in levels {
                items.append(ActionSheetButtonItem(title: title, color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    manager.avatarSquarenessLevel = lvl
                    updateState { $0.avatarSquareness = lvl }
                }))
            }
            items.append(ActionSheetButtonItem(title: "Отмена", color: .destructive, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
            }))
            actionSheet.setItemGroups([ActionSheetItemGroup(items: items)])
            presentControllerImpl?(actionSheet, nil)
        },
        toggleSenderMiniAvatars: { val in
            manager.senderMiniAvatarsEnabled = val
            updateState { $0.senderMiniAvatars = val }
        },
        toggleOnlineIndicator: { val in
            manager.chatAvatarOnlineIndicator = val
            updateState { $0.onlineIndicator = val }
        },
        toggleExactLastSeen: { val in
            manager.showExactLastSeen = val
            updateState { $0.exactLastSeen = val }
        },
        openCheckmarkColor: {
            pushControllerImpl?(checkmarkColorController(context: context), true)
        },
        toggleDoubleTapToCopy: { val in
            manager.doubleTapToCopyIncoming = val
            updateState { $0.doubleTapToCopy = val }
        },
        changeTripleTapDelete: {
            let actionSheet = ActionSheetController(presentationData: context.sharedContext.currentPresentationData.with { $0 })
            let modes: [(TripleTapDeleteMode, String)] = [
                (.none, "Выключено"),
                (.local, "Удалить только у меня"),
                (.everyone, "Удалить у всех")
            ]
            var items: [ActionSheetItem] = []
            for (m, title) in modes {
                items.append(ActionSheetButtonItem(title: title, color: .accent, action: { [weak actionSheet] in
                    actionSheet?.dismissAnimated()
                    manager.tripleTapDeleteMode = m
                    updateState { $0.tripleTapDelete = m }
                }))
            }
            items.append(ActionSheetButtonItem(title: "Отмена", color: .destructive, action: { [weak actionSheet] in
                actionSheet?.dismissAnimated()
            }))
            actionSheet.setItemGroups([ActionSheetItemGroup(items: items)])
            presentControllerImpl?(actionSheet, nil)
        },
        toggleContextLocalEdit: { val in
            manager.contextShowLocalEdit = val
            updateState { $0.contextLocalEdit = val }
        },
        toggleHideEditedStatus: { val in
            manager.hideEditedStatus = val
            updateState { $0.hideEditedStatus = val }
        },
        toggleHideMessageTimestamps: { val in
            manager.hideMessageTimestamps = val
            updateState { $0.hideMessageTimestamps = val }
        },
        toggleHideChannelComments: { val in
            manager.hideChannelComments = val
            updateState { $0.hideChannelComments = val }
        },
        toggleHideChannelViewCounts: { val in
            manager.hideChannelViewCounts = val
            updateState { $0.hideChannelViewCounts = val }
        },
        toggleHideStoryCircles: { val in
            manager.hideStoryCirclesInChatList = val
            updateState { $0.hideStoryCircles = val }
        },
        toggleHideChatListSearchBar: { val in
            manager.hideChatListSearchBar = val
            updateState { $0.hideChatListSearchBar = val }
        },
        toggleHideProfileDescription: { val in
            manager.hideProfileDescription = val
            updateState { $0.hideProfileDescription = val }
        },
        toggleConnectionStatusText: { val in
            manager.showConnectionStatusText = val
            updateState { $0.connectionStatusText = val }
        },
        toggleAutoMuteNewChannels: { val in
            manager.autoMuteNewChannels = val
            updateState { $0.autoMuteNewChannels = val }
        },
        toggleSnowflakesApp: { val in
            manager.snowflakesEnabled = val
            updateState { $0.snowflakesApp = val }
        },
        toggleSnowflakesChat: { val in
            manager.snowflakesInChatEnabled = val
            updateState { $0.snowflakesChat = val }
        },
        toggleBindButtons: { val in
            manager.showBindButtons = val
            updateState { $0.bindButtonsEnabled = val }
        },
        toggleBindGhostMode: { val in
            manager.showGhostModeBind = val
            updateState { $0.bindGhostMode = val }
        },
        toggleBindDeletedMessages: { val in
            manager.showDeletedMessagesBind = val
            updateState { $0.bindDeletedMessages = val }
        },
        toggleBindScrollToTop: { val in
            manager.showScrollToTopBind = val
            updateState { $0.bindScrollToTop = val }
        },
        toggleBindScheduledMessages: { val in
            manager.showScheduledMessagesBind = val
            updateState { $0.bindScheduledMessages = val }
        },
        toggleBindScreenshotPrivacy: { val in
            manager.showScreenshotPrivacyBind = val
            updateState { $0.bindScreenshotPrivacy = val }
        },
        toggleBindTranslate: { val in
            manager.showTranslateBeforeSendBind = val
            updateState { $0.bindTranslate = val }
        }
    )

    let signal = combineLatest(
        context.sharedContext.presentationData,
        statePromise.get()
    )
    |> map { presentationData, state -> (ItemListControllerState, (ItemListNodeState, FontCustomizationArguments)) in
        let entries = fontCustomizationEntries(presentationData: presentationData, state: state)

        let controllerState = ItemListControllerState(
            presentationData: ItemListPresentationData(presentationData),
            title: .text("Кастомизация и шрифты"),
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
    controller.didAppear = { (_: Bool) in
        let s = FontCustomizationState.current()
        let _ = stateValue.modify { _ in s }
        statePromise.set(s)
    }

    pushControllerImpl = { [weak controller] c, animated in
        controller?.push(c)
    }
    presentControllerImpl = { [weak controller] c, a in
        controller?.present(c, in: .window(.root), with: a)
    }
    return controller
}
