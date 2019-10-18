
import UIKit

class cookingViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var switchControll: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    navigationController?.delegate = self
    self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is ViewController {

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
    }
    @IBAction func switchTap(_ sender: Any) {
        
        
    }
    
}
