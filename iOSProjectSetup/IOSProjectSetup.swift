import UIKit

final class IOSProjectSetup {

    private let userCoordinating: UserCoordinating

    init(userCoordinating: UserCoordinating) {
        self.userCoordinating = userCoordinating
    }

    func present(in window: UIWindow) {
        let navigationController = UINavigationController()

        userCoordinating.present(in: navigationController)

        window.rootViewController = navigationController
        window.makeKeyAndVisible();
    }
}

extension IOSProjectSetup {
    convenience init?() {
        guard let userRepository = RandomUserAPIClient() else {
            return nil
        }

        self.init(userCoordinating: UserCoordinator(repository: userRepository))
    }
}
