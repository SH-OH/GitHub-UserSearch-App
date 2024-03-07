import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Shared.ConcurrencyUtility.rawValue,
    targets: [
        .implements(module: .shared(.ConcurrencyUtility))
    ]
)
