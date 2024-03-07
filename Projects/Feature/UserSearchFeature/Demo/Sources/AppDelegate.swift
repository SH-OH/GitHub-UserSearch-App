import UIKit
@testable import UserSearchFeature
@testable import SearchDomainTesting
@testable import SearchDomain

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let searchUseCase = SearchUseCaseSpy()
        let chars: [Character] = ["a", "b", "c", "d", "e"]
        
        searchUseCase.fetchUsersFromRemoteReturn = [
            .init(id: 0, nickname: "aaa", profileUrl: nil, isFavorited: false),
            .init(id: 1, nickname: "aab", profileUrl: nil, isFavorited: false),
            .init(id: 2, nickname: "abb", profileUrl: nil, isFavorited: false),
            .init(id: 3, nickname: "bbb", profileUrl: nil, isFavorited: false),
            .init(id: 4, nickname: "bbc", profileUrl: nil, isFavorited: false),
            .init(id: 5, nickname: "bcc", profileUrl: nil, isFavorited: false),
            .init(id: 6, nickname: "ccc", profileUrl: nil, isFavorited: false),
            .init(id: 7, nickname: "ccd", profileUrl: nil, isFavorited: false),
            .init(id: 8, nickname: "ddd", profileUrl: nil, isFavorited: false),
            .init(id: 9, nickname: "zzz", profileUrl: nil, isFavorited: false),
            .init(id: 10, nickname: "yyy", profileUrl: nil, isFavorited: false),
        ]
        
        let factory = UserSearchFactoryImpl(
            searchUseCase: searchUseCase,
            searchEventBroker: SearchEventBrokerImpl()
        )
        window?.rootViewController = factory.makeViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
