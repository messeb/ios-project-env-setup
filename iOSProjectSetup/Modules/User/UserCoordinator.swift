import UIKit

protocol UserCoordinating {
    func present(in navigationController: UINavigationController)
}

final class UserCoordinator: UserCoordinating {

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func present(in navigationController: UINavigationController) {
        let viewController: UserViewController = .fromStoryboard()
        let viewModel = UserPresentableViewModel(repository: repository)

        viewController.viewModel = viewModel

        navigationController.pushViewController(viewController, animated: false)
    }
}
