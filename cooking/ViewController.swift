import Alamofire
import UIKit
import SwiftyJSON

@available(iOS 13.0, *)
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        LoadingProxy.set(v: self); //表示する親をセット
        LoadingProxy.on()//ローディング表示。非表示にする場合はoff
        
        //Navigationbarの設定
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "wood"), for: .default)
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white]
        
        getData()
        
    }
    func getData(){
        let text = "https://script.google.com/macros/s/AKfycbzPwqMxXBfsxTrmvvProfELlvf-79QssWd0eAXZ6z5qFnBA4ao/exec" //取得したいURL
        let url = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            AF.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
                switch response.result{
                case .success:
                      // 通信成功時
                    LoadingProxy.off()
                    guard response.data != nil else {
                          return
                      }

                      do {
                          // googleDataはGoogleDataの配列( [GoogleData] )になります。
                          let googleData = try JSONDecoder().decode([GoogleData].self, from: response.data!)

                          // 前のforEachとやっていることは同じです。
                          googleData.forEach { item in
                              recipedata.shared.nameArray.append(item.name)
                              recipedata.shared.amountArray.append("\(item.amount)")
                              recipedata.shared.taniArray.append(item.unit)
                              recipedata.shared.priceArray.append("\(item.price)")
                              recipedata.shared.categoryArray.append("\(item.category)")
                          }
                      } catch let error {
                          // JSON -> GoogleData にデコード失敗
                          print(error)
                      }
                case .failure(let error):
                      // 通信の失敗
                      print(error)
                }
            }
      
    
    }


}
