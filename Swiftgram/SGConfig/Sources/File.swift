import Foundation

public struct SGConfig: Codable {
    public var apiUrl: String = "https://127.0.0.1"
    public var webappUrl: String = "https://127.0.0.1"
    public var botUsername: String = "SwiftgramBot"
    public var publicKey: String?
    public var iaps: [String] = []
}

public let SG_CONFIG: SGConfig = SGConfig()
public let SG_API_WEBAPP_URL_PARSED = URL(string: SG_CONFIG.webappUrl)!
