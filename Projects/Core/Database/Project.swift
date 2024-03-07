import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Core.Database.rawValue,
    targets: [
        .interface(module: .core(.Database), dependencies: [
            
        ]),
        .implements(module: .core(.Database), dependencies: [
            .shared(target: .GlobalThirdPartyLibrary),
            .core(target: .Database, type: .interface)
        ])
    ]
)
