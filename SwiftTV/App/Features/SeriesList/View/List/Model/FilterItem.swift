struct FilterItem: Identifiable, Equatable {
    var id: Int { genre.id }
    let genre: SerieGenre
    var isSelected: Bool = false
}
