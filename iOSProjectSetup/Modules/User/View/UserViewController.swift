import UIKit
import RxSwift
import RxCocoa
import MBProgressHUD

final class UserViewController: UIViewController {
    @IBOutlet private var userImageView: UIImageView!
    @IBOutlet private var salutationLabel: UILabel!
    @IBOutlet private var firstnameLabel: UILabel!
    @IBOutlet private var lastnameLabel: UILabel!

    private let disposeBag = DisposeBag()

    var viewModel: UserViewModel?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let viewModel = viewModel {
            bind(to: viewModel.outputs)

            viewModel.inputs.fetch()
        }
    }

    private func bind(to outputs: UserViewModelOutputs) {
        outputs.salutation
            .map { $0.capitalized }
            .drive(salutationLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.firstname
            .map { $0.capitalized }
            .drive(firstnameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.lastname
            .map { $0.capitalized }
            .drive(lastnameLabel.rx.text)
            .disposed(by: disposeBag)

        outputs.image
            .drive(userImageView.rx.image)
            .disposed(by: disposeBag)

        outputs.loading
            .drive(onNext: { [weak self] isLoading in
                guard let `self` = self else {
                    return
                }

                if isLoading {
                    MBProgressHUD.showAdded(to: self.view, animated: true)
                } else {
                    MBProgressHUD.hide(for: self.view, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }

    @IBAction func loadUser(_ sender: UIBarButtonItem) {
        viewModel?.inputs.fetch()
    }
}
