struct FilterItem: Identifiable, Equatable {
    var id: Int { genre.id }
    let genre: MediaGenreItem
    var isSelected: Bool = false
}
