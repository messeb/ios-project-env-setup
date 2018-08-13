import Foundation
import RxSwift
import RxCocoa

protocol UserViewModel {
    var inputs: UserViewModelInputs { get }
    var outputs: UserViewModelOutputs { get }
}

protocol UserViewModelInputs {
    func fetch()
}

protocol UserViewModelOutputs {
    var image: Driver<UIImage?> { get }
    var salutation: Driver<String> { get }
    var firstname: Driver<String> { get }
    var lastname: Driver<String> { get }
    var loading: Driver<Bool> { get }
}

final class UserPresentableViewModel: UserViewModel {
    var inputs: UserViewModelInputs {
        return self
    }

    var outputs: UserViewModelOutputs {
        return self
    }

    private let userPublisher = BehaviorSubject<User>(value: User())
    private let loadingRelay = BehaviorRelay<Bool>(value: false)
    private let repository: UserRepository

    let salutation: Driver<String>
    let firstname: Driver<String>
    let lastname: Driver<String>
    let image: Driver<UIImage?>
    let loading: Driver<Bool>

    init(repository: UserRepository) {
        salutation = userPublisher
            .asObserver()
            .map { $0.name.title }
            .asDriver(onErrorJustReturn: "")

        firstname = userPublisher
            .asObserver()
            .map { $0.name.first }
            .asDriver(onErrorJustReturn: "abc")

        lastname = userPublisher
            .asObserver()
            .map { $0.name.last }
            .asDriver(onErrorJustReturn: "")

        image = userPublisher
            .asObserver()
            .map {
                guard let imageURL = $0.picture.large else {
                    return nil
                }
                do {
                    let imageData = try Data(contentsOf: imageURL)
                    return UIImage(data: imageData)
                } catch {
                    return nil
                }
            }
            .asDriver(onErrorJustReturn: nil)

        loading = loadingRelay
            .asDriver(onErrorJustReturn: false)

        self.repository = repository
    }
}

extension UserPresentableViewModel: UserViewModelInputs {
    func fetch() {
        loadingRelay.accept(true)
        repository.fetch { [weak self] user in
            guard let user = user else {
                return
            }

            self?.userPublisher.onNext(user)
            self?.loadingRelay.accept(false)
        }
    }
}

extension UserPresentableViewModel: UserViewModelOutputs {

}
