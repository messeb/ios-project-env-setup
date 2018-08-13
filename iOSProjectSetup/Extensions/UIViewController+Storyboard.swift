import UIKit

extension UIViewController {
    public static func fromStoryboard<T: UIViewController>() -> T {
        let bundle = Bundle(for: self)
        let name = String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: bundle)

        guard let viewController = storyboard.instantiateInitialViewController() as? T else {
            fatalError("Could not instantiate ViewController")
        }
        return viewController
    }
}
