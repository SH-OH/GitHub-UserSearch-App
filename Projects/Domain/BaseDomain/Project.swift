import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.BaseDomain.rawValue,
    targets: [
        .interface(module: .domain(.BaseDomain), dependencies: [
            .shared(target: .GlobalThirdPartyLibrary),
        ]),
        .implements(module: .domain(.BaseDomain), product: .staticFramework, dependencies: [
            .domain(target: .BaseDomain, type: .interface),
            .core(target: .Networking, type: .interface),
        ]),
        .tests(module: .domain(.BaseDomain), dependencies: [
            .domain(target: .BaseDomain)
        ])
    ]
)
