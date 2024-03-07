import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Shared.UIKitUtility.rawValue,
    targets: [
        .implements(module: .shared(.UIKitUtility))
    ]
)
