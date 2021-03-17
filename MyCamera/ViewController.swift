//
//  ViewController.swift
//  MyCamera
//
//  Created by 中村智史 on 2021/03/10.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var pictureImage: UIImageView!
    
    @IBAction func cameraButtonAction(_ sender: Any) {
        //カメラかフォトライブラリどちらから画像を取得するか選択
        let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
        
        //カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            //カメラを起動するための選択肢を定義
            let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: { (action:UIAlertAction) in
                //カメラを起動
                let imagePickerController = UIImagePickerController()
                imagePickerController.sourceType = .camera
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(cameraAction)
        }
        
        //フォトライブラリが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            //フォトライブラリを起動するための選択肢を定義
            let photolibraryAction = UIAlertAction(title: "フォトライブラリ", style: .default, handler: { (action:UIAlertAction) in
                
                //フォトライブラリを起動
                let imagePickerController = UIImagePickerController()
                
                imagePickerController.delegate = self
                self.present(imagePickerController, animated: true, completion: nil)
            })
            alertController.addAction(photolibraryAction)
        }
        
        //キャンセルの選択肢を定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //ipad で落ちてしまう対策
        alertController.popoverPresentationController?.sourceView = view
        
        //選択肢を画像に表示
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        //表示画像をアンラップしてシェア画像を取り出す
        if let shareImage = pictureImage.image {
            //UIactivitycontrollerに渡す配列を作成
            let shareItems = [shareImage]
            //UIactivityviewcontrollerにシェア画像を渡す
            let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            // ipadで落ちてしまう対策
            controller.popoverPresentationController?.sourceView = view
            //UIActivityviewcontrollerを表示
            present(controller, animated: true, completion: nil)
        }
    }
    
    //撮影が終わったときに呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //撮影した画像を配置したcaptureimageに渡す
        captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        //モーダルビューを閉じる
        dismiss(animated: true, completion: {
            //エフェクト画面に遷移
            self.performSegue(withIdentifier: "showEffectView", sender: nil)
        })
    }
    //次の画像遷移するときに渡す画像を格納する場所
    var captureImage : UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //次の画面のインスタンスを格納
        if let nextViewController = segue.destination as? EffectViewController {
            
            //次の画面のインスタンスに取得した画像を渡す
            nextViewController.originalImage = captureImage
        }
    }

}

