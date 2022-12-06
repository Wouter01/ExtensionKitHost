

public enum CEExtensionScene {

    case settings
    case other(id: String)

    public var id: String {
        switch self {
        case .settings:
            return "settings"
        case .other(let id):
            return id
        }
    }
}
