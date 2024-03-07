import DependencyPlugin
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: ModulePaths.Domain.SearchDomain.rawValue,
    targets: [
        .interface(module: .domain(.SearchDomain), dependencies: [
            .domain(target: .BaseDomain, type: .interface),
        ]),
        .implements(
            module: .domain(.SearchDomain),
            product: .staticFramework,
            spec: .init(
                dependencies: [
                    .domain(target: .BaseDomain),
                    .domain(target: .SearchDomain, type: .interface),
                    .core(target: .Database, type: .interface),
                ],
                coreDataModels: [
                    CoreDataModel("Sources/Repository/Local/Entity/User.xcdatamodeld")
                ]
            )
        ),
        .testing(module: .domain(.SearchDomain), dependencies: [
            .domain(target: .SearchDomain, type: .interface),
        ]),
        .tests(module: .domain(.SearchDomain), dependencies: [
            .domain(target: .SearchDomain),
            .domain(target: .SearchDomain, type: .testing)
        ])
    ]
)
