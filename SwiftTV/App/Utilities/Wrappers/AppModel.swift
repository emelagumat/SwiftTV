
@propertyWrapper
struct DTOModel<T, U> {
    var wrappedValue: T
    private var mapper: Mapping<T, U>
    
    var projectedValue: U {
        mapper.map(wrappedValue)
    }
    
    init(wrappedValue: T, _ mapper: Mapping<T, U>) {
        self.wrappedValue = wrappedValue
        self.mapper = mapper
    }
}

struct Sample {
    @DTOModel(.string.toInt)
    var id: String = ""
    
    @DTOModel(.int.toString)
    var age: Int = 34
    
    func mec() {
        let moc = id
        let muc = $id
    }
}

// MARK: - Mapping
public struct Mapping<Z, U> {
    public let map: (Z) -> U
    
    public init(map: @escaping (Z) -> U) {
        self.map = map
    }
}

public extension Mapping where Z == String {
    static var toInt: Mapping<String, Int> {
        .init { Int($0) ?? .zero }
    }
}

public extension Mapping {
    enum string {
        static var toInt: Mapping<String, Int> { .toInt }
    }
    
    enum int {
        static var toString: Mapping<Int, String> { .toString }
    }
}

public extension Mapping where Z == Int {
    static var toString: Mapping<Int, String> {
        .init { String($0) }
    }
}
