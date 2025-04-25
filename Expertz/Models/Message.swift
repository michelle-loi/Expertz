import Foundation

/**
 Identifiable: Allows the Chat to be identified by its id
 Codable: Allows conversion between swift structure and Firebase structure
 */
struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var senderId: String
    var timestamp: Date // the time the message was sent
}
