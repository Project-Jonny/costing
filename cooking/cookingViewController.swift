import Alamofire
import UIKit
import SwiftyJSON

@available(iOS 13.0, *)
class cookingViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var total: Float = 0
    var kotei: String = "baika"
    var selectedrecipe:[Int] = []
    
    //taniはGoogleData上でunitになってる
    @IBOutlet var baika: UITextField!
    @IBOutlet var genkaritsu: UITextField!
    @IBOutlet var rieki: UITextField!
    @IBOutlet var genkaTotal: UITextField!
    
    @IBOutlet var Kotei1: UIButton!
    @IBOutlet var Kotei2: UIButton!
    @IBOutlet var tableViewContainer: UIView!
    
    var celltaped:Int = 0
    var tableView:UITableView = UITableView()
    var searchController = UISearchController()
    var refreshControll = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControll.attributedTitle = NSAttributedString(string: "更新")
        refreshControll.addTarget(self, action: #selector(refresh), for: .valueChanged)

        tableView.addSubview(refreshControll)
        
        searchController = UISearchController(searchResultsController: nil)
//        searchController.searchResultsUpdater = (self as! UISearchResultsUpdating)
        // searchBarの位置を固定する
        searchController.hidesNavigationBarDuringPresentation = false
        // searchBarのプレースホルダー
        searchController.searchBar.placeholder = "search"
        // searchBarフォーカス時に背景色を暗くするか？
        searchController.obscuresBackgroundDuringPresentation = true
        // searchbarのサイズを調整
        searchController.searchBar.sizeToFit()
        // tableViewのヘッダーにセット
        tableView.tableHeaderView = searchController.searchBar
        
        tableView.frame = tableViewContainer.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        tableViewContainer.addSubview(tableView)
        
        LoadingProxy.set(v: self) //表示する親をセット
        LoadingProxy.on() //ローディング表示。非表示にする場合はoff
        
        baika.layer.borderWidth = 1
        genkaritsu.layer.borderWidth = 1
        rieki.layer.borderWidth = 1
        genkaTotal.layer.borderWidth = 1
        baika.layer.borderColor = UIColor.lightGray.cgColor
        genkaritsu.layer.borderColor = UIColor.lightGray.cgColor
        rieki.layer.borderColor = UIColor.lightGray.cgColor
        genkaTotal.layer.borderColor = UIColor.lightGray.cgColor
        
        Kotei1.layer.borderWidth = 1
        Kotei1.layer.borderColor = UIColor.lightGray.cgColor
        Kotei1.layer.cornerRadius = 10
        Kotei2.layer.borderWidth = 1
        Kotei2.layer.borderColor = UIColor.lightGray.cgColor
        Kotei2.layer.cornerRadius = 10
        
        getData()
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            LoadingProxy.off();
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(cookingViewController.receivechange(_:)), name: Notification.Name("change"), object: nil)
                
    }
    
    @objc func receivechange(_ notification: NSNotification) {
        let amountget = notification.userInfo!["amount"] as! String
        let priceget = notification.userInfo!["price"] as! String
        let cellget = notification.userInfo!["cellindex"] as! Int
        recipedata.shared.amountArray[cellget] = amountget
        recipedata.shared.priceArray[cellget] = priceget
        
        tableView.reloadData()
    }
    
    //画面をタップした時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //キーボードを閉じる
        baika.resignFirstResponder()
        genkaritsu.resignFirstResponder()

    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        celltaped = indexPath.row
        performSegue(withIdentifier: "edit", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipedata.shared.nameArray.count
        //Idの数だけやるからどのIdArrayのcountでも良さげ
    }
//    // 文字が入力される度に呼ばれる
//    func updateSearchResults(for searchController: UISearchController) {
//        self.searchResults = recipedata.filter{
//            // 大文字と小文字を区別せずに検索
//            $0.lowercased().contains(searchController.searchBar.text!.lowercased())
//        }
//        self.tableView.reloadData()
//    }
      
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        cell.selectionStyle = .blue
        cell.textLabel?.text = recipedata.shared.nameArray[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.numberOfLines = 1
        cell.detailTextLabel?.text = recipedata.shared.amountArray[indexPath.row] + recipedata.shared.taniArray[indexPath.row] + "  " + recipedata.shared.priceArray[indexPath.row] + "円"
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.numberOfLines = 1
        cell.accessoryType = .detailButton
        
        if cell.isSelected == true{
            cell.backgroundColor = .systemYellow
            
            }else{
            cell.backgroundColor = nil
        }
          
        return cell

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
                        
                        recipedata.shared.nameArray = []
                        recipedata.shared.amountArray = []
                        recipedata.shared.taniArray = []
                        recipedata.shared.priceArray = []
                        recipedata.shared.categoryArray = []

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
            self.tableView.reloadData()
        }
      
    
    }

      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
                  print("select - \(indexPath)")
        
            cell?.isSelected = true
        
            //totalに入れる
            self.total += Float(recipedata.shared.priceArray[indexPath.row]) ?? 0
            genkaTotal.text = String(self.total)
            //totalをラベルに反映させる
        
            selectedrecipe.append(indexPath.row)
        
            if kotei == "baika" {
                    BaikaKotei()
        
                }else{
                    GenkaKotei()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "edit" {
            
          let nextVC = segue.destination as! CellViewController
              nextVC.namevalue = recipedata.shared.nameArray[celltaped]
              nextVC.categoryvalue = recipedata.shared.categoryArray[celltaped]
              nextVC.unitvalue = recipedata.shared.taniArray[celltaped]
              nextVC.amountvalue = recipedata.shared.amountArray[celltaped]
              nextVC.pricevalue = recipedata.shared.priceArray[celltaped]
              nextVC.cellindex = celltaped
            
        }
    }
    
        @objc func refresh(){

            getData()
            refreshControll.endRefreshing()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                LoadingProxy.on();
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    LoadingProxy.off();
                }
            }

        }
    
    func GenkaKotei(){

          let Genkaritsu = Float(genkaritsu.text!) ?? 0
          let Sale  = self.total * Genkaritsu
              rieki.text = String(Sale - self.total)
              baika.text = String(Sale)
    }

    func BaikaKotei() {

          //売価を固定
          let Sale  = Float(baika.text!) ?? 0
          guard Sale > 0 else { return }

              genkaritsu.text = String(Int(Float(self.total) / Float(Sale) * 100))
              rieki.text = String(Sale - self.total)

    }

    //2回目の選択時
      func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            print("deselect - \(indexPath)")

            let cell = tableView.cellForRow(at:indexPath)
                cell?.isSelected = false

            self.total -= Float(recipedata.shared.priceArray[indexPath.row]) ?? 0
                genkaTotal.text = String(self.total)
            if let deselect = selectedrecipe.firstIndex(of: indexPath.row){
                selectedrecipe.remove(at: deselect)
                }

            if kotei == "baika" {
                    BaikaKotei()

            }else{
                    GenkaKotei()

            }

      }
    
    @IBAction func kotei1(_ sender: Any) {
        
            Kotei1.backgroundColor = UIColor.systemBlue
            Kotei1.layer.borderColor = UIColor.systemBlue.cgColor
            Kotei2.backgroundColor = UIColor.lightGray
            Kotei2.layer.borderColor = UIColor.lightGray.cgColor
        
            baika.layer.borderColor = UIColor.red.cgColor
            genkaritsu.layer.borderColor = UIColor.lightGray.cgColor
        
            kotei = "baika"
        
    }
    
    @IBAction func kotei2(_ sender: Any) {
        
            Kotei2.backgroundColor = UIColor.systemBlue
            Kotei2.layer.borderColor = UIColor.systemBlue.cgColor
            Kotei1.backgroundColor = UIColor.lightGray
            Kotei1.layer.borderColor = UIColor.lightGray.cgColor
        
            genkaritsu.layer.borderColor = UIColor.red.cgColor
            baika.layer.borderColor = UIColor.lightGray.cgColor

            kotei = "genkaritsu"

    }
    
    @IBAction func save(_ sender: Any) {
        
            var alertTextField: UITextField?

            let alert = UIAlertController(
                title: "レシピ名",
                message: "名前をつけて保存",
                preferredStyle: UIAlertController.Style.alert)
                    alert.addTextField(
                        configurationHandler: {(textField: UITextField!) in
                        alertTextField = textField
                    })
                    alert.addAction(
                        UIAlertAction(
                            title: "Cancel",
                            style: UIAlertAction.Style.cancel,
                            handler: nil))
                    alert.addAction(
                        UIAlertAction(
                            title: "OK",
                            style: UIAlertAction.Style.default) { _ in
                            if let text = alertTextField?.text {
                            
                var saver: [String] = UserDefaults.standard.array(forKey: "alert") as? [String] ?? []
                saver.append(text)
                UserDefaults.standard.set(saver, forKey: "alert")
                            
                var baikabox: [String] = UserDefaults.standard.array(forKey: "baikaB") as? [String] ?? []
                baikabox.append(self.baika.text!)
                UserDefaults.standard.set(baikabox, forKey: "baikaB")
                            
                var genkabox: [String] = UserDefaults.standard.array(forKey: "genkaB") as? [String] ?? []
                genkabox.append(self.genkaritsu.text!)
                UserDefaults.standard.set(genkabox, forKey: "genkaB")
                            
                var riekibox: [String] = UserDefaults.standard.array(forKey: "riekiB") as? [String] ?? []
                riekibox.append(self.rieki.text!)
                UserDefaults.standard.set(riekibox, forKey: "riekiB")
                            
                var totalbox: [String] = UserDefaults.standard.array(forKey: "totalB") as? [String] ?? []
                totalbox.append(self.genkaTotal.text!)
                UserDefaults.standard.set(totalbox, forKey: "totalB")
                            
                var tap: [[Int]] = UserDefaults.standard.array(forKey: "tap") as? [[Int]] ?? []
                tap.append(self.selectedrecipe)
                UserDefaults.standard.set(tap, forKey: "tap")
            
                    }
                }
            )

        self.present(alert, animated: true, completion: nil)

    }

}
//検索窓をスクロールしないようにしたい😡
//検索結果が出てこない😡
//検索窓の枠線消したいなあ〜
//カテゴリつけたい。どっかでカウントしてセクションの数に入れる？
//更新した時のIndicatorをもっとスマートにしたいな、更新完了したらスクロール戻すとか。
//利益額と原価計はラベルにしちゃってもいいかなあ、どうしよかなあ
