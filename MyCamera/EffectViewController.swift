//
//  EffectViewController.swift
//  MyCamera
//
//  Created by 中村智史 on 2021/03/13.
//

import UIKit

class EffectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //画面遷移時に元の画像を表示
        effectImage.image = originalImage
       
    }
    
    //エフェクト画像
    //前の画像より画像を設定
    var originalImage : UIImage?
    
    @IBOutlet weak var effectImage: UIImageView!
    
    let filterArray = ["CIPhotoEffectMono", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CIPhotoEffectTone"]
    
        //選択中のエフェクト
    var filterSelectNumber = 0
    
    @IBAction func effectButtonAction(_ sender: Any) {
        //エフェクト前画像をアンラップしてエフェクト用画像として取り出す
        if let image = originalImage {
            //フィルタ名を指定
            let filterName = filterArray[filterSelectNumber]
            
            //次の選択するエフェクト添字に更新
            filterSelectNumber += 1
            //添字が配列の数と同じか？チェック
            if filterSelectNumber == filterArray.count {
                //同じ場合は最後まで選択されたので先頭に戻す
                filterSelectNumber = 0
                
            }
            //元々の画像の回転角度を取得
            let rotate = image.imageOrientation
            //UIimage形式の画像をCIImage形式に変換
            let inputImage = CIImage(image: image)
            //フィルターの種別を引数で指定された種類を指定してCIFilterのインスタンスを取得
            guard let effectFilter = CIFilter(name: filterName) else {
                return
            }
            
            //エフェクトのパラメータを初期化
            effectFilter.setDefaults()
            //インスタンスにエフェクトする元画像を指定
            effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
            //エフェクト後のciimage形式の画像を取り出す
            guard let outputImage = effectFilter.outputImage else {
                return
            }
            //CIContextのインスタンスを取得
            let ciContext = CIContext(options: nil)
            //エフェクト後の画像をCIcontext上の描写し、結果をcigmageとしてCGimage形式の画像を取得
            guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
                return
            }
            
            //エフェクト後の画像をCGImage形式からUIimage形式に変更。その後顔移転角度を指定。そしてimaggeviewに表示
            effectImage.image = UIImage(cgImage: cgImage, scale: 1.0, orientation: rotate)
        }
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        //表示画像をアンラップしてシェア画像を取り出す
        if let shareImage = effectImage.image {
            //UIActivityviewcontrollerに渡す配列を作成
            let shareItems = [shareImage]
            //UIactivityviewcontrollerにシェア画像を渡す
            let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
            //ipadで落ちてしまう対策
            controller.popoverPresentationController?.sourceView = view
            //UIactivityviewcontrollerを表示
            present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        //画面を閉じて前の画面に戻る
        dismiss(animated: true, completion: nil)
    }
    
}
