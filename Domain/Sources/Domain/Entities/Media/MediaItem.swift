import Foundation

public protocol MediaItem {
    var id: Int { get }
    var backdropURL: String { get }
    var posterURL: String { get }
    var category: MediaItemCategory { get }
    var genres: [MediaGenre] { get }
    var rate: MediaItemRate { get }
}
