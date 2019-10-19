import UIKit

@available(iOS 13.0, *)
class recipeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    //tableview作成
    var tableview:UITableView = UITableView()
    var textArray:[String] = []
    var baikaArray:[String] = []
    var genkaArray:[String] = []
    var riekiArray:[String] = []
    var totalArray:[String] = []
    var tapArray:[[Int]] = []
    
    var celltapped:Int = 0
    var searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        //searchController.searchResultsUpdater = (self as! UISearchResultsUpdating)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.sizeToFit()
        tableview.tableHeaderView = searchController.searchBar

        tableview.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        tableview.delegate = self
        tableview.dataSource = self
        self.view.addSubview(tableview)

        }
    
    override func viewWillAppear(_ animated: Bool) {
        
        textArray = UserDefaults.standard.array(forKey: "alert") as? [String] ?? []
        baikaArray = UserDefaults.standard.array(forKey: "baikaB") as? [String] ?? []
        genkaArray = UserDefaults.standard.array(forKey: "genkaB") as? [String] ?? []
        riekiArray = UserDefaults.standard.array(forKey: "riekiB") as? [String] ?? []
        totalArray = UserDefaults.standard.array(forKey: "totalB") as? [String] ?? []
        tapArray = UserDefaults.standard.array(forKey: "tap") as? [[Int]] ?? []
        
        tableview.reloadData()
        
        print(textArray)
        print(riekiArray)
        print(baikaArray)
        print(genkaArray)
        print(totalArray)
        print(tapArray)
    }
    
    //    // 文字が入力される度に呼ばれる
    //    func updateSearchResults(for searchController: UISearchController) {
    //        self.searchResults = recipedata.filter{
    //            // 大文字と小文字を区別せずに検索
    //            $0.lowercased().contains(searchController.searchBar.text!.lowercased())
    //        }
    //        self.tableView.reloadData()
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = textArray[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            textArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaults.standard.set(textArray, forKey: "alert")
//            UserDefaults.standard.synchronize()

            riekiArray.remove(at: indexPath.row)
            UserDefaults.standard.set(riekiArray, forKey: "riekiB")
//            UserDefaults.standard.synchronize()

            baikaArray.remove(at: indexPath.row)
            UserDefaults.standard.set(baikaArray, forKey: "baikaB")
//            UserDefaults.standard.synchronize()

            genkaArray.remove(at: indexPath.row)
            UserDefaults.standard.set(genkaArray, forKey: "genkaB")
//            UserDefaults.standard.synchronize()

            totalArray.remove(at: indexPath.row)
            UserDefaults.standard.set(totalArray, forKey: "totalB")
            

            tapArray.remove(at: indexPath.row)
            UserDefaults.standard.set(tapArray, forKey: "tap")
            UserDefaults.standard.synchronize()

            tableview.reloadData()

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          celltapped = indexPath.row
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
            
            print(textArray[celltapped])
            print(riekiArray[celltapped])
            print(baikaArray[celltapped])
            print(genkaArray[celltapped])
            print(totalArray[celltapped])
            print(tapArray[celltapped])
        }
    }
}
//検索窓をスクロールしないようにしたい😡
//検索結果が出てこない😡
//検索窓の枠線消したいよね、わかる
