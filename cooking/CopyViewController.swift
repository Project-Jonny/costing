import UIKit

class CopyViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
        
    @IBOutlet var baika: UILabel!
    @IBOutlet var genkaritsu: UILabel!
    @IBOutlet var rieki: UILabel!
    @IBOutlet var genkaTotal: UILabel!
    
    var tableView:UITableView = UITableView()
    var baikavalue:String = ""
    var recipevalue:String = ""
    var genkavalue:String = ""
    var riekivalue:String = ""
    var totalvalue:String = ""
    var tapvalue:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = CGRect(x: 0, y: (self.view.bounds.height - view.frame.height/2), width: view.frame.width, height: view.frame.height/2)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        self.navigationItem.title = recipevalue
                
        baika.text = baikavalue
        genkaritsu.text = genkavalue
        rieki.text = riekivalue
        genkaTotal.text = totalvalue
        
        print(tapvalue)
        tapvalue.forEach { (tap) in
            print(recipedata.shared.amountArray[tap])
            print(recipedata.shared.nameArray[tap])
            print(recipedata.shared.priceArray[tap])
            print(recipedata.shared.taniArray[tap])
            print(baikavalue)

        }
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tapvalue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
                  let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        
        let tap = tapvalue[indexPath.row]

                  cell.textLabel?.text = recipedata.shared.nameArray[tap]
                  cell.textLabel?.adjustsFontSizeToFitWidth = true
                  cell.textLabel?.numberOfLines = 1
        //        　セルに値段などを表示↓
                cell.detailTextLabel?.text = recipedata.shared.amountArray[tap] + recipedata.shared.taniArray[tap] + "  " + recipedata.shared.priceArray[tap] + "円"
                  cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
                  cell.detailTextLabel?.numberOfLines = 1
                  cell.selectionStyle = .none
                  
                  return cell

    }
}

//スクショ機能つけたら親切だね〜〜〜
