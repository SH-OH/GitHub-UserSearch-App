import ProjectDescription

public enum ResourceType: String {
    case xib = "Resources/**/*.xib"
    case storyboards = "Resources/**/*.storyboard"
    case assets = "Resources/**"
}

public extension ResourceFileElements {
    init(_ resources: ResourceType...) {
        let resources = resources.map { ResourceFileElement(stringLiteral: $0.rawValue) }
        self.init(resources: resources)
    }
}
