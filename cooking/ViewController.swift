import Alamofire
import UIKit
import SwiftyJSON

@available(iOS 13.0, *)
class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,UISearchResultsUpdating {
    
    //tableview作成
    @IBOutlet var tableview: UITableView!
    var textArray:[String] = []
    var baikaArray:[String] = []
    var genkaArray:[String] = []
    var riekiArray:[String] = []
    var totalArray:[String] = []
    var tapArray:[[Int]] = []
    
    var celltapped:Int = 0
    var searchController = UISearchController()
    var searchResults:[Int] = []

       override func viewDidLoad() {
           super.viewDidLoad()

           LoadingProxy.set(v: self); //表示する親をセット
           LoadingProxy.on()//ローディング表示。非表示にする場合はoff
           
           //Navigationbarの設定
           self.navigationController?.navigationBar.barStyle = .black
           self.navigationController?.navigationBar.tintColor = .white
           self.navigationController?.navigationBar.titleTextAttributes = [
               .foregroundColor: UIColor.white]
           
           getData()
           
           searchController = UISearchController(searchResultsController: nil)
           // Setup the Search Controller
           searchController.searchBar.backgroundColor = .white
           searchController.searchBar.isTranslucent = false
           searchController.searchResultsUpdater = self
           searchController.hidesNavigationBarDuringPresentation = false
           searchController.obscuresBackgroundDuringPresentation = false
           searchController.searchBar.placeholder = "Search"
           searchController.searchBar.tintColor = .systemBlue
           definesPresentationContext = true

           // Implement Search Controller
           navigationItem.searchController = searchController
           navigationItem.hidesSearchBarWhenScrolling = false
           navigationController?.navigationBar.setBackgroundImage(UIImage(named: "wood"), for: .default)


           tableview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
           tableview.delegate = self
           tableview.dataSource = self

           textArray = UserDefaults.standard.array(forKey: "alert") as? [String] ?? []
           baikaArray = UserDefaults.standard.array(forKey: "baikaB") as? [String] ?? []
           genkaArray = UserDefaults.standard.array(forKey: "genkaB") as? [String] ?? []
           riekiArray = UserDefaults.standard.array(forKey: "riekiB") as? [String] ?? []
           totalArray = UserDefaults.standard.array(forKey: "totalB") as? [String] ?? []
           tapArray = UserDefaults.standard.array(forKey: "tap") as? [[Int]] ?? []
    
           searchResults = textArray.enumerated().map { $0.0 }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        textArray = UserDefaults.standard.array(forKey: "alert") as? [String] ?? []
        baikaArray = UserDefaults.standard.array(forKey: "baikaB") as? [String] ?? []
        genkaArray = UserDefaults.standard.array(forKey: "genkaB") as? [String] ?? []
        riekiArray = UserDefaults.standard.array(forKey: "riekiB") as? [String] ?? []
        totalArray = UserDefaults.standard.array(forKey: "totalB") as? [String] ?? []
        tapArray = UserDefaults.standard.array(forKey: "tap") as? [[Int]] ?? []
        
        searchResults = textArray.enumerated().map { $0.0 }
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
         //文字が入力される度に呼ばれる
        func updateSearchResults(for searchController: UISearchController) {
            
            if searchController.searchBar.text! == ""{
                searchResults = textArray.enumerated().map { $0.0 }
            }else{
                self.searchResults = textArray.enumerated().filter({
                // 大文字と小文字を区別せずに検索
                    $0.1.lowercased().contains(searchController.searchBar.text!.lowercased())
                }).map({ $0.0 })
                
            }
            self.view.endEditing(true)
            self.tableview.reloadData()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            
            let textArrayIndex = searchResults[indexPath.row]
            cell.textLabel?.text = textArray[textArrayIndex] // = textArray[searchResults[indexPath.row]]
            
            return cell
        }
        
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                textArray.remove(at: indexPath.row)
                UserDefaults.standard.set(textArray, forKey: "alert")

                riekiArray.remove(at: indexPath.row)
                UserDefaults.standard.set(riekiArray, forKey: "riekiB")

                baikaArray.remove(at: indexPath.row)
                UserDefaults.standard.set(baikaArray, forKey: "baikaB")

                genkaArray.remove(at: indexPath.row)
                UserDefaults.standard.set(genkaArray, forKey: "genkaB")

                totalArray.remove(at: indexPath.row)
                UserDefaults.standard.set(totalArray, forKey: "totalB")
                

                tapArray.remove(at: indexPath.row)
                UserDefaults.standard.set(tapArray, forKey: "tap")
                UserDefaults.standard.synchronize()
                
                searchResults = textArray.enumerated().map { $0.0 }

                tableview.reloadData()

            }
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
              celltapped = searchResults[indexPath.row]
              performSegue(withIdentifier: "detail", sender: nil)
            }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "detail" {
                
                let nextVC = segue.destination as! CopyViewController
                nextVC.recipevalue = textArray[celltapped]
                nextVC.riekivalue = riekiArray[celltapped]
                nextVC.baikavalue = baikaArray[celltapped]
                nextVC.genkavalue = genkaArray[celltapped]
                nextVC.totalvalue = totalArray[celltapped]
                nextVC.tapvalue = tapArray[celltapped]

            }
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
//数値途中で変えると押してた形跡が消える
