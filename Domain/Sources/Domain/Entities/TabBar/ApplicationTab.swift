
public struct ApplicationTab: Equatable {
    public let id: String
    public let name: String
    public let symbolName: String
    
    public init(
        id: String,
        name: String,
        symbolName: String
    ) {
        self.id = id
        self.name = name
        self.symbolName = symbolName
    }
}
