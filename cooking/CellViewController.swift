import UIKit

@available(iOS 13.0, *)
class CellViewController: UIViewController {
    
    @IBOutlet var category: UILabel!
    @IBOutlet var name: UILabel!
    @IBOutlet var amount: UITextField!
    @IBOutlet var unit: UILabel!
    @IBOutlet var price: UILabel!
    
    @IBOutlet var test: UILabel!
    var testnum:Float = 0
    var cellindex:Int = 0
    
    var namevalue:String = ""
    var categoryvalue:String = ""
    var amountvalue:String = ""
    var unitvalue:String = ""
    var pricevalue:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amount.delegate = self
        amount.resignFirstResponder()
        
        name.text = namevalue
        category.text = "カテゴリ：" + categoryvalue
        amount.text = amountvalue
        unit.text = unitvalue
        price.text = pricevalue + "円"
        testnum = Float(pricevalue)! / Float(amountvalue)!
        test.text = String(testnum)
    }
    
}

@available(iOS 13.0, *)
extension CellViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text ?? "kara")
        let inputnum = Float(textField.text ?? "0") ?? 0
        price.text = String(inputnum * testnum)
       
        var userinfo:[AnyHashable : Any] = [:]
        userinfo["price"] = price.text
        userinfo["amount"] = amount.text
        userinfo["cellindex"] = cellindex

        NotificationCenter.default.post(name: Notification.Name("change"), object: nil, userInfo: userinfo)
    }
    
}
//このUIってどうなん、シンプルすぎない？センスないわあ〜
