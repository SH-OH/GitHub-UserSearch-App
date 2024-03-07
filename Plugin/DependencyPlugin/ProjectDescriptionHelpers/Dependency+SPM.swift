import ProjectDescription

public typealias DEP = TargetDependency

public extension DEP {
    struct SPM {}
}

public extension DEP.SPM {
    static let Kingfisher: DEP = .external(name: "Kingfisher", condition: nil)
    static let Swinject: DEP = .external(name: "Swinject", condition: nil)
    static let RxSwift: DEP = .external(name: "RxSwift", condition: nil)
    static let RxCocoa: DEP = .external(name: "RxCocoa", condition: nil)
    static let RxRelay: DEP = .external(name: "RxRelay", condition: nil)
    static let ReactorKit: DEP = .external(name: "ReactorKit", condition: nil)
}

public extension Package {
    enum SPM: CaseIterable {
        case Kingfisher
        case Swinject
        case RxSwift
        case ReactorKit
        
        public var package: Package {
            switch self {
            case .Kingfisher:
                return .remote(
                    url: "https://github.com/onevcat/Kingfisher.git",
                    requirement: .upToNextMajor(from: "7.11.0")
                )
            case .Swinject:
                return .remote(
                    url: "https://github.com/Swinject/Swinject.git",
                    requirement: .upToNextMajor(from: "2.8.4")
                )
            case .RxSwift:
                return .remote(
                    url: "https://github.com/ReactiveX/RxSwift.git",
                    requirement: .upToNextMajor(from: "6.6.0")
                )
            case .ReactorKit:
                return .remote(
                    url: "https://github.com/ReactorKit/ReactorKit.git",
                    requirement: .upToNextMajor(from: "3.2.0")
                )
            }
        }
    }
}
