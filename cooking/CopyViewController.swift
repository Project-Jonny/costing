import UIKit
import Photos

class CopyViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate {
        
    @IBOutlet var baika: UILabel!
    @IBOutlet var genkaritsu: UILabel!
    @IBOutlet var rieki: UILabel!
    @IBOutlet var genkaTotal: UILabel!
    @IBOutlet var tableViewContainer: UIView!
    
    var tableView:UITableView = UITableView()
    var baikavalue:String = ""
    var recipevalue:String = ""
    var genkavalue:String = ""
    var riekivalue:String = ""
    var totalvalue:String = ""
    var tapvalue:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.frame = tableViewContainer.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableViewContainer.addSubview(tableView)
        
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
    @IBAction func camera(_ sender: Any) {
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch(status){
            case .authorized:
                print("許可されています。")
                
            case .denied:
                print("拒否されました。")
                
            case .notDetermined:
                print("notDetermined")
                
            case .restricted:
                print("restricted")
            @unknown default: break
            }
        }
        
        
        
        
    }
}
