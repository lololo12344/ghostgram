import Foundation
import UIKit
import CoreText

// MARK: - Enums

public enum GhostgramFont: String, CaseIterable, Codable {
    case roboto
    case openSans
    case lato
    case raleway
    case montserrat
    case metropolis
    case workSans
    case sourceSansPro
    case nanumSquareRound
    case lora
    case merriweather
    case sourceSerifPro
    case liberationSerif
    case robotoMono
    case sourceCodePro
    case mononoki

    public var displayName: String {
        switch self {
        case .roboto: return "Roboto"
        case .openSans: return "Open Sans"
        case .lato: return "Lato"
        case .raleway: return "Raleway"
        case .montserrat: return "Montserrat"
        case .metropolis: return "Metropolis"
        case .workSans: return "Work Sans"
        case .sourceSansPro: return "Source Sans Pro"
        case .nanumSquareRound: return "NanumSquareRound"
        case .lora: return "Lora"
        case .merriweather: return "Merriweather"
        case .sourceSerifPro: return "Source Serif Pro"
        case .liberationSerif: return "Liberation Serif"
        case .robotoMono: return "Roboto Mono"
        case .sourceCodePro: return "Source Code Pro"
        case .mononoki: return "Mononoki"
        }
    }

    public var regularPostScriptName: String {
        switch self {
        case .workSans: return "WorkSans-Regular"
        case .sourceSansPro: return "SourceSansPro-Regular"
        case .nanumSquareRound: return "NanumSquareRoundR"
        case .sourceSerifPro: return "SourceSerifPro-Regular"
        case .sourceCodePro: return "SourceCodePro-Regular"
        case .mononoki: return "mononoki-Regular"
        case .metropolis: return "SFCamera-Regular"
        default: return "SourceSansPro-Regular"
        }
    }

    public var boldPostScriptName: String {
        switch self {
        case .workSans: return "WorkSans-Bold"
        case .sourceSansPro: return "SourceSansPro-Bold"
        case .nanumSquareRound: return "NanumSquareRoundB"
        case .sourceSerifPro: return "SourceSerifPro-Bold"
        case .sourceCodePro: return "SourceCodePro-Bold"
        case .mononoki: return "mononoki-Bold"
        case .metropolis: return "SFCamera-Semibold"
        default: return "SourceSansPro-Bold"
        }
    }
}

public enum ReadStatusColorMode: String, CaseIterable, Codable {
    case blue
    case gray
    case custom
}

public enum TripleTapDeleteMode: String, CaseIterable, Codable {
    case none
    case local
    case everyone
}

public enum HiddenSettingsItem: String, CaseIterable, Codable {
    case savedMessages
    case recentCalls
    case devices
    case chatFolders
    case notificationsAndSounds
    case privacyAndSecurity
    case dataAndStorage
    case appearance
    case powerSaving
    case premium
    case stars
    case business
    case gifts
    case passport
    case watch
    case myProfile
    case support
    case faq
    case tips
    case wallet
}

public struct GGURLShortcut: Codable, Equatable {
    public var rawURL: String
    public var title: String
    public var faviconUrl: String?

    public init(rawURL: String, title: String, faviconUrl: String? = nil) {
        self.rawURL = rawURL
        self.title = title
        self.faviconUrl = faviconUrl
    }
}

// MARK: - Manager

public final class FontCustomizationManager {
    public static let shared = FontCustomizationManager()
    public static let settingsChangedNotification = Notification.Name("FontCustomizationSettingsChanged")

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let isEnabled = "FontCustomization.isEnabled"
        static let isCustomSelected = "FontCustomization.isCustomSelected"
        static let selectedFont = "FontCustomization.selectedFont"
        static let importedFontName = "FontCustomization.importedFontName"
        static let importedFontPath = "FontCustomization.importedFontPath"
        static let activeFontToken = "FontCustomization.activeFontToken"

        static let amoledTrueBlack = "GG.fontCustomization.amoledTrueBlack"
        static let amoledKeyboard = "GG.fontCustomization.amoledKeyboard"
        static let hideCellSeparators = "GG.fontCustomization.hideCellSeparators"
        static let senderMiniAvatars = "GG.fontCustomization.senderMiniAvatars"
        static let chatAvatarOnlineIndicator = "FontCustomization.chatAvatarOnlineIndicator"
        static let showExactLastSeen = "FontCustomization.showExactLastSeen"
        static let useTelegramServerTranscription = "FontCustomization.useTelegramServerTranscription"
        static let squareAvatarsInChatList = "FontCustomization.squareAvatarsInChatList"
        static let roundAvatarsInForums = "FontCustomization.roundAvatarsInForums"
        static let avatarSquarenessLevel = "FontCustomization.avatarSquarenessLevel"
        static let chatListItemScale = "GG.fontCustomization.chatListItemScale"
        static let tabBarUnifiedSearch = "FontCustomization.tabBarUnifiedSearch"
        static let folderBarHeightOffset = "FontCustomization.folderBarHeightOffset"
        static let folderBarBottomOffset = "FontCustomization.folderBarBottomOffset"

        static let snowflakes = "GG.fontCustomization.snowflakes"
        static let snowflakesInChat = "GG.fontCustomization.snowflakesInChat"
        static let snowflakesIntensity = "GG.fontCustomization.snowflakesIntensity"

        static let inputBarHeightPadding = "GG.fontCustomization.inputBarHeightPadding"
        static let inputBarLeftMargin = "GG.fontCustomization.inputBarLeftMargin"
        static let inputBarRightMargin = "GG.fontCustomization.inputBarRightMargin"
        static let inputBarBottomOffset = "GG.fontCustomization.inputBarBottomOffset"
        static let inputBarLeftButtonOffsetX = "GG.fontCustomization.inputBarLeftButtonOffsetX"
        static let inputBarLeftButtonOffsetY = "GG.fontCustomization.inputBarLeftButtonOffsetY"
        static let inputBarRightButtonOffsetX = "GG.fontCustomization.inputBarRightButtonOffsetX"
        static let inputBarRightButtonOffsetY = "GG.fontCustomization.inputBarRightButtonOffsetY"
        static let inputBarAccessoryButtonOffsetX = "GG.fontCustomization.inputBarAccessoryButtonOffsetX"
        static let inputBarAccessoryButtonOffsetY = "GG.fontCustomization.inputBarAccessoryButtonOffsetY"

        static let showChatTopBarBackButton = "FontCustomization.showChatTopBarBackButton"
        static let showChatTopBarTitlePanel = "FontCustomization.showChatTopBarTitlePanel"
        static let showChatTopBarAvatar = "FontCustomization.showChatTopBarAvatar"
        static let showChatTopBarPinnedMessages = "FontCustomization.showChatTopBarPinnedMessages"

        static let hideIncomingTextFormatting = "FontCustomization.hideIncomingTextFormatting"
        static let hideOutgoingTextFormatting = "FontCustomization.hideOutgoingTextFormatting"
        static let doubleTapToCopyIncoming = "GG.fontCustomization.doubleTapToCopyIncoming"
        static let tripleTapDeleteMode = "GG.fontCustomization.tripleTapDeleteMode"
        static let contextShowLocalEdit = "GG.contextShowLocalEdit"
        static let showPeerInfoShareButton = "GG.fontCustomization.showPeerInfoShareButton"
        static let localStarsBalance = "GG.fontCustomization.localStarsBalance"
        static let autoMuteNewChannels = "GG.fontCustomization.autoMuteNewChannels"

        static let readStatusColorEnabled = "GG.fontCustomization.readStatusColorEnabled"
        static let readStatusColorMode = "GG.fontCustomization.readStatusColorMode"
        static let readStatusCustomColor = "GG.fontCustomization.readStatusCustomColor"

        static let hideStoryCirclesInChatList = "GG.fontCustomization.hideStoryCirclesInChatList"
        static let storyCircleColor = "GG.fontCustomization.storyCircleColor"
        static let searchBarColor = "GG.fontCustomization.searchBarColor"
        static let searchBarColorEnabled = "GG.fontCustomization.searchBarColorEnabled"
        static let hideChatListSearchBar = "GG.fontCustomization.hideChatListSearchBar"
        static let hideProfileDescription = "GG.fontCustomization.hideProfileDescription"
        static let showConnectionStatusText = "FontCustomization.showConnectionStatusText"

        static let hideChannelComments = "FontCustomization.hideChannelComments"
        static let hideChannelViewCounts = "FontCustomization.hideChannelViewCounts"
        static let hideMessageTimestamps = "FontCustomization.hideMessageTimestamps"
        static let hideEditedStatus = "FontCustomization.hideEditedStatus"
        static let hideStarRatingBadge = "GG.fontCustomization.hideStarRatingBadge"

        static let showBindButtons = "FontCustomization.showBindButtons"
        static let showGhostModeBind = "FontCustomization.showGhostModeBind"
        static let showDeletedMessagesBind = "FontCustomization.showDeletedMessagesBind"
        static let showEditedMessagesBind = "FontCustomization.showEditedMessagesBind"
        static let showScheduledMessagesBind = "FontCustomization.showScheduledMessagesBind"
        static let showScrollToTopBind = "FontCustomization.showScrollToTopBind"
        static let showTranslateBeforeSendBind = "FontCustomization.showTranslateBeforeSendBind"
        static let showScreenshotPrivacyBind = "FontCustomization.showScreenshotPrivacyBind"

        static let showChatListAccountSwitcher = "GG.fontCustomization.showChatListAccountSwitcher"
        static let hideEditEmojiStatusAction = "GG.fontCustomization.hideEditEmojiStatusAction"
        static let settingsAccountsCollapsed = "GG.fontCustomization.settingsAccountsCollapsed"
        static let hideEditProfileColorAction = "GG.fontCustomization.hideEditProfileColorAction"
        static let hideEditProfilePhotoAction = "GG.fontCustomization.hideEditProfilePhotoAction"

        static let hiddenSettingsPrefix = "FontCustomization.hiddenSettings."
        static let hiddenSettingsOrder = "FontCustomization.hiddenSettings.order"

        static let customSettingsShortcutPeerIds = "GG.fontCustomization.customSettingsShortcutPeerIds"
        static let customSettingsShortcutMiniAppPeerIds = "GG.fontCustomization.customSettingsShortcutMiniAppPeerIds"
        static let customSettingsShortcutURLs = "GG.fontCustomization.customSettingsShortcutURLs"
    }

    private init() {}

    private func notifyChanged() {
        NotificationCenter.default.post(name: FontCustomizationManager.settingsChangedNotification, object: self)
    }

    // MARK: - Font Management

    public var isEnabled: Bool {
        get { defaults.bool(forKey: Keys.isEnabled) }
        set {
            defaults.set(newValue, forKey: Keys.isEnabled)
            notifyChanged()
        }
    }

    public var isCustomFontSelected: Bool {
        get { defaults.bool(forKey: Keys.isCustomSelected) }
        set {
            defaults.set(newValue, forKey: Keys.isCustomSelected)
            notifyChanged()
        }
    }

    public var selectedFont: GhostgramFont {
        get {
            if let raw = defaults.string(forKey: Keys.selectedFont), let font = GhostgramFont(rawValue: raw) {
                return font
            }
            return .sourceSansPro
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.selectedFont)
            defaults.set(false, forKey: Keys.isCustomSelected)
            activeFontToken += 1
            notifyChanged()
        }
    }

    public var activeFontToken: Int32 {
        get { Int32(defaults.integer(forKey: Keys.activeFontToken)) }
        set { defaults.set(Int(newValue), forKey: Keys.activeFontToken) }
    }

    public var importedFontDisplayName: String? {
        get { defaults.string(forKey: Keys.importedFontName) }
        set {
            defaults.set(newValue, forKey: Keys.importedFontName)
            notifyChanged()
        }
    }

    public var importedFontPath: String? {
        get { defaults.string(forKey: Keys.importedFontPath) }
        set {
            defaults.set(newValue, forKey: Keys.importedFontPath)
            notifyChanged()
        }
    }

    public func applyFont() {
        activeFontToken += 1
        notifyChanged()
    }

    public func resetFontSelection() {
        defaults.removeObject(forKey: Keys.selectedFont)
        defaults.removeObject(forKey: Keys.isCustomSelected)
        defaults.removeObject(forKey: Keys.importedFontName)
        defaults.removeObject(forKey: Keys.importedFontPath)
        activeFontToken += 1
        notifyChanged()
    }

    public func selectImportedFont() {
        if importedFontPath != nil {
            defaults.set(true, forKey: Keys.isCustomSelected)
            activeFontToken += 1
            notifyChanged()
        }
    }

    public func importFont(from url: URL) throws -> String {
        let fileManager = FileManager.default
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fontsDir = docs.appendingPathComponent("Fonts", isDirectory: true)
        try fileManager.createDirectory(at: fontsDir, withIntermediateDirectories: true, attributes: nil)

        let targetURL = fontsDir.appendingPathComponent(url.lastPathComponent)
        if fileManager.fileExists(atPath: targetURL.path) {
            try fileManager.removeItem(at: targetURL)
        }
        try fileManager.copyItem(at: url, to: targetURL)

        var errorRef: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(targetURL as CFURL, .process, &errorRef)

        let displayName = targetURL.deletingPathExtension().lastPathComponent
        self.importedFontDisplayName = displayName
        self.importedFontPath = targetURL.path
        self.selectImportedFont()
        return displayName
    }

    public func previewFont(for font: GhostgramFont, size: CGFloat, bold: Bool) -> UIFont {
        let name = bold ? font.boldPostScriptName : font.regularPostScriptName
        if let customFont = UIFont(name: name, size: size) {
            return customFont
        }
        return bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    }

    public static func systemPreviewFont(size: CGFloat, bold: Bool) -> UIFont {
        return bold ? UIFont.boldSystemFont(ofSize: size) : UIFont.systemFont(ofSize: size)
    }

    public func importedPreviewFont(size: CGFloat) -> UIFont? {
        guard let path = importedFontPath else { return nil }
        let url = URL(fileURLWithPath: path)
        var errorRef: Unmanaged<CFError>?
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, &errorRef)
        if let name = importedFontDisplayName, let font = UIFont(name: name, size: size) {
            return font
        }
        return nil
    }

    // MARK: - AMOLED & UI Appearance

    public var amoledTrueBlackEnabled: Bool {
        get { defaults.bool(forKey: Keys.amoledTrueBlack) }
        set {
            defaults.set(newValue, forKey: Keys.amoledTrueBlack)
            notifyChanged()
        }
    }

    public var amoledKeyboardEnabled: Bool {
        get { defaults.bool(forKey: Keys.amoledKeyboard) }
        set {
            defaults.set(newValue, forKey: Keys.amoledKeyboard)
            notifyChanged()
        }
    }

    public var hideCellSeparatorsEnabled: Bool {
        get { defaults.bool(forKey: Keys.hideCellSeparators) }
        set {
            defaults.set(newValue, forKey: Keys.hideCellSeparators)
            notifyChanged()
        }
    }

    public var senderMiniAvatarsEnabled: Bool {
        get { defaults.bool(forKey: Keys.senderMiniAvatars) }
        set {
            defaults.set(newValue, forKey: Keys.senderMiniAvatars)
            notifyChanged()
        }
    }

    public var chatAvatarOnlineIndicator: Bool {
        get { defaults.bool(forKey: Keys.chatAvatarOnlineIndicator) }
        set {
            defaults.set(newValue, forKey: Keys.chatAvatarOnlineIndicator)
            notifyChanged()
        }
    }

    public var showExactLastSeen: Bool {
        get { defaults.bool(forKey: Keys.showExactLastSeen) }
        set {
            defaults.set(newValue, forKey: Keys.showExactLastSeen)
            notifyChanged()
        }
    }

    public var useTelegramServerTranscription: Bool {
        get { defaults.bool(forKey: Keys.useTelegramServerTranscription) }
        set {
            defaults.set(newValue, forKey: Keys.useTelegramServerTranscription)
            notifyChanged()
        }
    }

    public var squareAvatarsInChatList: Bool {
        get { defaults.bool(forKey: Keys.squareAvatarsInChatList) }
        set {
            defaults.set(newValue, forKey: Keys.squareAvatarsInChatList)
            notifyChanged()
        }
    }

    public var roundAvatarsInForums: Bool {
        get { defaults.bool(forKey: Keys.roundAvatarsInForums) }
        set {
            defaults.set(newValue, forKey: Keys.roundAvatarsInForums)
            notifyChanged()
        }
    }

    public var avatarSquarenessLevel: Int32 {
        get {
            let val = defaults.integer(forKey: Keys.avatarSquarenessLevel)
            return val == 0 ? 8 : Int32(val)
        }
        set {
            defaults.set(Int(newValue), forKey: Keys.avatarSquarenessLevel)
            notifyChanged()
        }
    }

    public var chatListItemScale: Int32 {
        get { Int32(defaults.integer(forKey: Keys.chatListItemScale)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.chatListItemScale)
            notifyChanged()
        }
    }

    public var chatListItemScaleMultiplier: CGFloat {
        let base: CGFloat = 1.0
        let scale = CGFloat(chatListItemScale) * 0.05
        return max(0.7, min(1.5, base + scale))
    }

    public var tabBarUnifiedSearch: Bool {
        get { defaults.bool(forKey: Keys.tabBarUnifiedSearch) }
        set {
            defaults.set(newValue, forKey: Keys.tabBarUnifiedSearch)
            notifyChanged()
        }
    }

    public var folderBarHeightOffset: Int32 {
        get { Int32(defaults.integer(forKey: Keys.folderBarHeightOffset)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.folderBarHeightOffset)
            notifyChanged()
        }
    }

    public var folderBarBottomOffset: Int32 {
        get { Int32(defaults.integer(forKey: Keys.folderBarBottomOffset)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.folderBarBottomOffset)
            notifyChanged()
        }
    }

    // MARK: - Snowflakes

    public var snowflakesEnabled: Bool {
        get { defaults.bool(forKey: Keys.snowflakes) }
        set {
            defaults.set(newValue, forKey: Keys.snowflakes)
            notifyChanged()
        }
    }

    public var snowflakesInChatEnabled: Bool {
        get { defaults.bool(forKey: Keys.snowflakesInChat) }
        set {
            defaults.set(newValue, forKey: Keys.snowflakesInChat)
            notifyChanged()
        }
    }

    public var snowflakesIntensity: Int32 {
        get {
            let val = defaults.integer(forKey: Keys.snowflakesIntensity)
            return val == 0 ? 50 : Int32(val)
        }
        set {
            defaults.set(Int(newValue), forKey: Keys.snowflakesIntensity)
            notifyChanged()
        }
    }

    // MARK: - Input Bar Metrics

    public var inputBarHeightPadding: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarHeightPadding)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarHeightPadding)
            notifyChanged()
        }
    }

    public var inputBarLeftMargin: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarLeftMargin)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarLeftMargin)
            notifyChanged()
        }
    }

    public var inputBarRightMargin: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarRightMargin)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarRightMargin)
            notifyChanged()
        }
    }

    public var inputBarBottomOffset: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarBottomOffset)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarBottomOffset)
            notifyChanged()
        }
    }

    public var inputBarLeftButtonOffsetX: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarLeftButtonOffsetX)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarLeftButtonOffsetX)
            notifyChanged()
        }
    }

    public var inputBarLeftButtonOffsetY: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarLeftButtonOffsetY)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarLeftButtonOffsetY)
            notifyChanged()
        }
    }

    public var inputBarRightButtonOffsetX: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarRightButtonOffsetX)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarRightButtonOffsetX)
            notifyChanged()
        }
    }

    public var inputBarRightButtonOffsetY: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarRightButtonOffsetY)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarRightButtonOffsetY)
            notifyChanged()
        }
    }

    public var inputBarAccessoryButtonOffsetX: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarAccessoryButtonOffsetX)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarAccessoryButtonOffsetX)
            notifyChanged()
        }
    }

    public var inputBarAccessoryButtonOffsetY: Int32 {
        get { Int32(defaults.integer(forKey: Keys.inputBarAccessoryButtonOffsetY)) }
        set {
            defaults.set(Int(newValue), forKey: Keys.inputBarAccessoryButtonOffsetY)
            notifyChanged()
        }
    }

    // MARK: - Chat Top Bar Elements

    public var showChatTopBarBackButton: Bool {
        get { defaults.object(forKey: Keys.showChatTopBarBackButton) == nil ? true : defaults.bool(forKey: Keys.showChatTopBarBackButton) }
        set {
            defaults.set(newValue, forKey: Keys.showChatTopBarBackButton)
            notifyChanged()
        }
    }

    public var showChatTopBarTitlePanel: Bool {
        get { defaults.object(forKey: Keys.showChatTopBarTitlePanel) == nil ? true : defaults.bool(forKey: Keys.showChatTopBarTitlePanel) }
        set {
            defaults.set(newValue, forKey: Keys.showChatTopBarTitlePanel)
            notifyChanged()
        }
    }

    public var showChatTopBarAvatar: Bool {
        get { defaults.object(forKey: Keys.showChatTopBarAvatar) == nil ? true : defaults.bool(forKey: Keys.showChatTopBarAvatar) }
        set {
            defaults.set(newValue, forKey: Keys.showChatTopBarAvatar)
            notifyChanged()
        }
    }

    public var showChatTopBarPinnedMessages: Bool {
        get { defaults.object(forKey: Keys.showChatTopBarPinnedMessages) == nil ? true : defaults.bool(forKey: Keys.showChatTopBarPinnedMessages) }
        set {
            defaults.set(newValue, forKey: Keys.showChatTopBarPinnedMessages)
            notifyChanged()
        }
    }

    // MARK: - Formatting & Context

    public var hideIncomingTextFormatting: Bool {
        get { defaults.bool(forKey: Keys.hideIncomingTextFormatting) }
        set {
            defaults.set(newValue, forKey: Keys.hideIncomingTextFormatting)
            notifyChanged()
        }
    }

    public var hideOutgoingTextFormatting: Bool {
        get { defaults.bool(forKey: Keys.hideOutgoingTextFormatting) }
        set {
            defaults.set(newValue, forKey: Keys.hideOutgoingTextFormatting)
            notifyChanged()
        }
    }

    public var doubleTapToCopyIncoming: Bool {
        get { defaults.bool(forKey: Keys.doubleTapToCopyIncoming) }
        set {
            defaults.set(newValue, forKey: Keys.doubleTapToCopyIncoming)
            notifyChanged()
        }
    }

    public var tripleTapDeleteMode: TripleTapDeleteMode {
        get {
            if let raw = defaults.string(forKey: Keys.tripleTapDeleteMode), let mode = TripleTapDeleteMode(rawValue: raw) {
                return mode
            }
            return .none
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.tripleTapDeleteMode)
            notifyChanged()
        }
    }

    public var contextShowLocalEdit: Bool {
        get { defaults.bool(forKey: Keys.contextShowLocalEdit) }
        set {
            defaults.set(newValue, forKey: Keys.contextShowLocalEdit)
            notifyChanged()
        }
    }

    public var showPeerInfoShareButton: Bool {
        get { defaults.bool(forKey: Keys.showPeerInfoShareButton) }
        set {
            defaults.set(newValue, forKey: Keys.showPeerInfoShareButton)
            notifyChanged()
        }
    }

    public var localStarsBalance: Int64? {
        get {
            if defaults.object(forKey: Keys.localStarsBalance) != nil {
                return Int64(defaults.integer(forKey: Keys.localStarsBalance))
            }
            return nil
        }
        set {
            if let val = newValue {
                defaults.set(Int(val), forKey: Keys.localStarsBalance)
            } else {
                defaults.removeObject(forKey: Keys.localStarsBalance)
            }
            notifyChanged()
        }
    }

    public var autoMuteNewChannels: Bool {
        get { defaults.bool(forKey: Keys.autoMuteNewChannels) }
        set {
            defaults.set(newValue, forKey: Keys.autoMuteNewChannels)
            notifyChanged()
        }
    }

    // MARK: - Read Status Colors

    public var readStatusColorEnabled: Bool {
        get { defaults.bool(forKey: Keys.readStatusColorEnabled) }
        set {
            defaults.set(newValue, forKey: Keys.readStatusColorEnabled)
            notifyChanged()
        }
    }

    public var readStatusColorMode: ReadStatusColorMode {
        get {
            if let raw = defaults.string(forKey: Keys.readStatusColorMode), let mode = ReadStatusColorMode(rawValue: raw) {
                return mode
            }
            return .blue
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.readStatusColorMode)
            notifyChanged()
        }
    }

    public var readStatusCustomColor: String {
        get { defaults.string(forKey: Keys.readStatusCustomColor) ?? "#3390EC" }
        set {
            defaults.set(newValue, forKey: Keys.readStatusCustomColor)
            notifyChanged()
        }
    }

    public var readStatusUIColor: UIColor {
        guard readStatusColorEnabled else { return UIColor(red: 0.2, green: 0.56, blue: 0.92, alpha: 1.0) }
        switch readStatusColorMode {
        case .blue:
            return UIColor(red: 0.2, green: 0.56, blue: 0.92, alpha: 1.0)
        case .gray:
            return UIColor(white: 0.65, alpha: 1.0)
        case .custom:
            return FontCustomizationManager.parseHexColor(readStatusCustomColor) ?? UIColor(red: 0.2, green: 0.56, blue: 0.92, alpha: 1.0)
        }
    }

    // MARK: - Story Circles & Search Bar

    public var hideStoryCirclesInChatList: Bool {
        get { defaults.bool(forKey: Keys.hideStoryCirclesInChatList) }
        set {
            defaults.set(newValue, forKey: Keys.hideStoryCirclesInChatList)
            notifyChanged()
        }
    }

    public var storyCircleColor: String {
        get { defaults.string(forKey: Keys.storyCircleColor) ?? "" }
        set {
            defaults.set(newValue, forKey: Keys.storyCircleColor)
            notifyChanged()
        }
    }

    public var storyCircleUIColor: UIColor? {
        if storyCircleColor.isEmpty { return nil }
        return FontCustomizationManager.parseHexColor(storyCircleColor)
    }

    public var searchBarColor: String {
        get { defaults.string(forKey: Keys.searchBarColor) ?? "" }
        set {
            defaults.set(newValue, forKey: Keys.searchBarColor)
            notifyChanged()
        }
    }

    public var searchBarColorEnabled: Bool {
        get { defaults.bool(forKey: Keys.searchBarColorEnabled) }
        set {
            defaults.set(newValue, forKey: Keys.searchBarColorEnabled)
            notifyChanged()
        }
    }

    public var hideChatListSearchBar: Bool {
        get { defaults.bool(forKey: Keys.hideChatListSearchBar) }
        set {
            defaults.set(newValue, forKey: Keys.hideChatListSearchBar)
            notifyChanged()
        }
    }

    public var hideProfileDescription: Bool {
        get { defaults.bool(forKey: Keys.hideProfileDescription) }
        set {
            defaults.set(newValue, forKey: Keys.hideProfileDescription)
            notifyChanged()
        }
    }

    public var showConnectionStatusText: Bool {
        get { defaults.bool(forKey: Keys.showConnectionStatusText) }
        set {
            defaults.set(newValue, forKey: Keys.showConnectionStatusText)
            notifyChanged()
        }
    }

    public var hideChannelComments: Bool {
        get { defaults.bool(forKey: Keys.hideChannelComments) }
        set {
            defaults.set(newValue, forKey: Keys.hideChannelComments)
            notifyChanged()
        }
    }

    public var hideChannelViewCounts: Bool {
        get { defaults.bool(forKey: Keys.hideChannelViewCounts) }
        set {
            defaults.set(newValue, forKey: Keys.hideChannelViewCounts)
            notifyChanged()
        }
    }

    public var hideMessageTimestamps: Bool {
        get { defaults.bool(forKey: Keys.hideMessageTimestamps) }
        set {
            defaults.set(newValue, forKey: Keys.hideMessageTimestamps)
            notifyChanged()
        }
    }

    public var hideEditedStatus: Bool {
        get { defaults.bool(forKey: Keys.hideEditedStatus) }
        set {
            defaults.set(newValue, forKey: Keys.hideEditedStatus)
            notifyChanged()
        }
    }

    public var hideStarRatingBadge: Bool {
        get { defaults.bool(forKey: Keys.hideStarRatingBadge) }
        set {
            defaults.set(newValue, forKey: Keys.hideStarRatingBadge)
            notifyChanged()
        }
    }

    // MARK: - Bind Buttons (Floating Quick Action Buttons)

    public var showBindButtons: Bool {
        get { defaults.bool(forKey: Keys.showBindButtons) }
        set {
            defaults.set(newValue, forKey: Keys.showBindButtons)
            notifyChanged()
        }
    }

    public var showGhostModeBind: Bool {
        get { defaults.object(forKey: Keys.showGhostModeBind) == nil ? true : defaults.bool(forKey: Keys.showGhostModeBind) }
        set {
            defaults.set(newValue, forKey: Keys.showGhostModeBind)
            notifyChanged()
        }
    }

    public var showDeletedMessagesBind: Bool {
        get { defaults.object(forKey: Keys.showDeletedMessagesBind) == nil ? true : defaults.bool(forKey: Keys.showDeletedMessagesBind) }
        set {
            defaults.set(newValue, forKey: Keys.showDeletedMessagesBind)
            notifyChanged()
        }
    }

    public var showEditedMessagesBind: Bool {
        get { defaults.bool(forKey: Keys.showEditedMessagesBind) }
        set {
            defaults.set(newValue, forKey: Keys.showEditedMessagesBind)
            notifyChanged()
        }
    }

    public var showScheduledMessagesBind: Bool {
        get { defaults.bool(forKey: Keys.showScheduledMessagesBind) }
        set {
            defaults.set(newValue, forKey: Keys.showScheduledMessagesBind)
            notifyChanged()
        }
    }

    public var showScrollToTopBind: Bool {
        get { defaults.bool(forKey: Keys.showScrollToTopBind) }
        set {
            defaults.set(newValue, forKey: Keys.showScrollToTopBind)
            notifyChanged()
        }
    }

    public var showTranslateBeforeSendBind: Bool {
        get { defaults.bool(forKey: Keys.showTranslateBeforeSendBind) }
        set {
            defaults.set(newValue, forKey: Keys.showTranslateBeforeSendBind)
            notifyChanged()
        }
    }

    public var showScreenshotPrivacyBind: Bool {
        get { defaults.bool(forKey: Keys.showScreenshotPrivacyBind) }
        set {
            defaults.set(newValue, forKey: Keys.showScreenshotPrivacyBind)
            notifyChanged()
        }
    }

    // MARK: - Settings Items Customization

    public var showChatListAccountSwitcher: Bool {
        get { defaults.bool(forKey: Keys.showChatListAccountSwitcher) }
        set {
            defaults.set(newValue, forKey: Keys.showChatListAccountSwitcher)
            notifyChanged()
        }
    }

    public var hideEditEmojiStatusAction: Bool {
        get { defaults.bool(forKey: Keys.hideEditEmojiStatusAction) }
        set {
            defaults.set(newValue, forKey: Keys.hideEditEmojiStatusAction)
            notifyChanged()
        }
    }

    public var settingsAccountsCollapsed: Bool {
        get { defaults.bool(forKey: Keys.settingsAccountsCollapsed) }
        set {
            defaults.set(newValue, forKey: Keys.settingsAccountsCollapsed)
            notifyChanged()
        }
    }

    public var hideEditProfileColorAction: Bool {
        get { defaults.bool(forKey: Keys.hideEditProfileColorAction) }
        set {
            defaults.set(newValue, forKey: Keys.hideEditProfileColorAction)
            notifyChanged()
        }
    }

    public var hideEditProfilePhotoAction: Bool {
        get { defaults.bool(forKey: Keys.hideEditProfilePhotoAction) }
        set {
            defaults.set(newValue, forKey: Keys.hideEditProfilePhotoAction)
            notifyChanged()
        }
    }

    public static var defaultSettingsItemsOrder: [HiddenSettingsItem] {
        return HiddenSettingsItem.allCases
    }

    public var settingsItemsOrder: [HiddenSettingsItem] {
        if let rawArray = defaults.stringArray(forKey: Keys.hiddenSettingsOrder) {
            let mapped = rawArray.compactMap { HiddenSettingsItem(rawValue: $0) }
            if !mapped.isEmpty {
                return mapped
            }
        }
        return FontCustomizationManager.defaultSettingsItemsOrder
    }

    public func setSettingsItemsOrder(_ order: [HiddenSettingsItem]) {
        let rawArray = order.map { $0.rawValue }
        defaults.set(rawArray, forKey: Keys.hiddenSettingsOrder)
        notifyChanged()
    }

    public func isSettingsItemHidden(_ item: HiddenSettingsItem) -> Bool {
        return defaults.bool(forKey: Keys.hiddenSettingsPrefix + item.rawValue)
    }

    public func setSettingsItemHidden(_ item: HiddenSettingsItem, hidden: Bool) {
        defaults.set(hidden, forKey: Keys.hiddenSettingsPrefix + item.rawValue)
        notifyChanged()
    }

    // MARK: - Custom Settings Shortcuts

    public var customSettingsShortcutPeerIds: [Int64] {
        get {
            let array = defaults.array(forKey: Keys.customSettingsShortcutPeerIds) as? [NSNumber] ?? []
            return array.map { $0.int64Value }
        }
        set {
            defaults.set(newValue.map { NSNumber(value: $0) }, forKey: Keys.customSettingsShortcutPeerIds)
            notifyChanged()
        }
    }

    public func addCustomSettingsShortcut(_ peerId: Int64) {
        var current = customSettingsShortcutPeerIds
        if !current.contains(peerId) {
            current.append(peerId)
            customSettingsShortcutPeerIds = current
        }
    }

    public func removeCustomSettingsShortcut(_ peerId: Int64) {
        var current = customSettingsShortcutPeerIds
        current.removeAll { $0 == peerId }
        customSettingsShortcutPeerIds = current
    }

    public var customSettingsShortcutMiniAppPeerIds: [Int64] {
        get {
            let array = defaults.array(forKey: Keys.customSettingsShortcutMiniAppPeerIds) as? [NSNumber] ?? []
            return array.map { $0.int64Value }
        }
        set {
            defaults.set(newValue.map { NSNumber(value: $0) }, forKey: Keys.customSettingsShortcutMiniAppPeerIds)
            notifyChanged()
        }
    }

    public func addCustomSettingsMiniAppShortcut(_ peerId: Int64) {
        var current = customSettingsShortcutMiniAppPeerIds
        if !current.contains(peerId) {
            current.append(peerId)
            customSettingsShortcutMiniAppPeerIds = current
        }
    }

    public func removeCustomSettingsMiniAppShortcut(_ peerId: Int64) {
        var current = customSettingsShortcutMiniAppPeerIds
        current.removeAll { $0 == peerId }
        customSettingsShortcutMiniAppPeerIds = current
    }

    public var customSettingsShortcutURLs: [GGURLShortcut] {
        get {
            guard let data = defaults.data(forKey: Keys.customSettingsShortcutURLs),
                  let list = try? JSONDecoder().decode([GGURLShortcut].self, from: data) else {
                return []
            }
            return list
        }
        set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: Keys.customSettingsShortcutURLs)
            }
            notifyChanged()
        }
    }

    public func addCustomSettingsURLShortcut(rawURL: String, title: String) -> GGURLShortcut? {
        guard let url = URL(string: rawURL), let host = url.host else { return nil }
        let faviconUrl = "https://icons.duckduckgo.com/ip3/\(host).ico"
        let shortcut = GGURLShortcut(rawURL: rawURL, title: title, faviconUrl: faviconUrl)
        var list = customSettingsShortcutURLs
        list.removeAll { $0.rawURL == rawURL }
        list.append(shortcut)
        customSettingsShortcutURLs = list
        return shortcut
    }

    public func removeCustomSettingsURLShortcut(_ rawURL: String) {
        var list = customSettingsShortcutURLs
        list.removeAll { $0.rawURL == rawURL }
        customSettingsShortcutURLs = list
    }

    // MARK: - Color Parser Helper

    public static func parseHexColor(_ hex: String) -> UIColor? {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanHex.hasPrefix("#") {
            cleanHex.removeFirst()
        }
        guard cleanHex.count == 6 || cleanHex.count == 8 else { return nil }
        var rgbValue: UInt64 = 0
        guard Scanner(string: cleanHex).scanHexInt64(&rgbValue) else { return nil }

        if cleanHex.count == 6 {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        } else {
            return UIColor(
                red: CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000FF) / 255.0
            )
        }
    }
}
