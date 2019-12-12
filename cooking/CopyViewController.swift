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
    var screenShotImage = UIImage()
    
    override func viewDidLoad() {
        
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
        
        SaveScreenShot()
        Arert()

    }
    
    func Arert(){
        
        
        let title = "画像を保存しました"
        let message = ""
        let okText = "ok"

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okayButton = UIAlertAction(title: okText, style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okayButton)

        present(alert, animated: true, completion: nil)
        
    }
    
    func ScreenShot1(){

        let width = CGFloat(UIScreen.main.bounds.size.width)
        let height = CGFloat(UIScreen.main.bounds.size.height - tableView.frame.height - navigationController!.navigationBar.frame.height)
        let size = CGSize(width: width, height: height)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        //viewを書き出す
        self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        // imageにコンテキストの内容を書き出す
        screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        //コンテキストを閉じる
        UIGraphicsEndImageContext()
        // imageをカメラロールに保存
        UIImageWriteToSavedPhotosAlbum(screenShotImage, nil, nil, nil)
        
    }
    func SaveScreenShot() {
        tableView.snapshot(scale: 1.0) { image in
            if let image = image {
                
                //１枚目の画像を書き出す
                let width = CGFloat(UIScreen.main.bounds.size.width)
                let height = CGFloat(UIScreen.main.bounds.size.height - self.tableView.frame.height - self.navigationController!.navigationBar.frame.height)
                let size = CGSize(width: width, height: height)

                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                //viewを書き出す
                self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
                // imageにコンテキストの内容を書き出す
                self.screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
                
                //コンテキストを閉じる
                UIGraphicsEndImageContext()

                
                //２枚目の画像を１枚目の高さの下から書き出す
                let height2 = image.size.height + self.screenShotImage.size.height
                UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height2), false, 0.0)
                
                //１枚目と２枚目を合わせて書き出す
                self.screenShotImage.draw(at: CGPoint(x: 0, y: 0))
                image.draw(at: CGPoint(x: 0, y: self.screenShotImage.size.height))
                
                let image2 = UIGraphicsGetImageFromCurrentImageContext()
                
                //コンテキストを閉じる
                UIGraphicsEndImageContext()

                
                if let image2 = image2 {
                    // imageをカメラロールに保存
                    UIImageWriteToSavedPhotosAlbum(image2, nil, nil, nil)
                }

                
            } else {
                // TODO: 画像の取得に失敗した事をユーザーに提示する
            }
//            self.ScreenShot1()
        }
    }
}
