//
//  QRCodeReadController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/5.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire
import SwiftyJSON

//參考文章：http://www.appcoda.com.tw/qr-code-reader-swift/

// 實作AVCaptureMetadataOutputObjectsDelegate 協定
class QRCodeReadController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    //MARK:- @IBOutlet
    @IBOutlet weak var closeButon: UIButton!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var QRCodeMessageLabel: UILabel!
    @IBOutlet weak var successImageView: UIImageView!
    @IBOutlet weak var successLabel: UILabel!
    
    //MARK:- Variables
    //QRCode Reader需要這3個類別的變數
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    //MARK:- @IBAction
    @IBAction func close(_ sender: UIButton) {
        // 回到FrontView
        self.revealViewController().performSegue(withIdentifier: "sw_front", sender: nil)
    }
    
    //MARK:- self Funcs
    deinit {
        print("=====QRCodeReadController deinit=====")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            self.revealViewController().rightViewRevealWidth = 200
            
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        //隱藏backBarButtonItem：self.navigationItem.hideBackButton = true
        self.navigationItem.hidesBackButton = true
        
        // 修改導覽列文字的顏色，字型
        let textForegroundColor = UIColor(red: 124.0/255.0, green: 124.0/255.0, blue: 124.0/255.0, alpha: 1.0)
        //let textFont = UIFont.systemFont(ofSize: 30, weight: UIFontWeightSemibold)
        let textFont = UIFont(name: ".PingFangTC-Semibold", size: 30)
        let textArttribute = [NSForegroundColorAttributeName: textForegroundColor, NSFontAttributeName: textFont]
        self.navigationController?.navigationBar.titleTextAttributes = textArttribute

        // 實體化一個AVCaptureSession 物件加上輸入設定來讓AVCaptureDevice順利進行影像擷取
        // 1. 取得 AVCaptureDevice 類別的實體來初始化一個device物件，並提供video作為媒體型態參數
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        // 2. 使用前面的 device 物件取得 AVCaptureDeviceInput 類別的實體
        do {
            let input = try AVCaptureDeviceInput.init(device: captureDevice!)
            // 初始化 captureSession 物件
            captureSession = AVCaptureSession()
            // 在capture session 設定輸入裝置
            captureSession?.addInput(input)
        } catch let error as NSError{
            print("=====\(error.localizedDescription)=====")
        }
        
        // 3. 初始化 AVCaptureMetadataOutput 物件並將其設定作為擷取session的輸出裝置
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // 4. 設定代理並使用預設的調度佇列來執行回呼（call back)
        //    依照Apple的文件，此佇列必須是串列佇列（serial queue）。因此我們使用dispatch_get_main_queue()函數來取得預設的串列佇列。
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        // 5. 告訴App哪一種元資料是我們感興趣的
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        //6. 我們需要透過裝置的相機將擷取的影像顯示在畫面上。這可以使用AVCaptureVideoPreviewLayer 來完成，實際上它是 CALayer。
        //   你使用預覽層（preview layer）結合AV capture session 來顯示影像。這個預覽層被加入作為目前視圖的子層（sublayer）
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // 7. 開始影像擷取
        captureSession?.startRunning()
        
        // 將訊息標籤,按鈕移到最上層視圖
        view.bringSubview(toFront: QRCodeMessageLabel)
        view.bringSubview(toFront: closeButon)
        
        // 初始化 QR Code Frame 來突顯 QR code
        qrCodeFrameView = UIView()
        let myCustomColor = UIColor(red: 255.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)
        qrCodeFrameView?.layer.borderColor = myCustomColor.cgColor
        qrCodeFrameView?.layer.borderWidth = 3
        
        view.addSubview(qrCodeFrameView!)
        view.bringSubview(toFront: qrCodeFrameView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- AVCaptureMetadataOutputObjectsDelegate protocol
    // 當AVCaptureMetadataOutput 物件辨識一個QR Code時，以下AVCaptureMetadataOutputObjectsDelegate 的代理方法會被呼叫
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // 檢查 metadataObjects 陣列是否為非空值，它至少需包含一個物件
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            QRCodeMessageLabel.text = "請將 QRCode 置於畫面中央"
            return
        }
        
        // 取得元資料（metadata）物件
        let metaDataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metaDataObj.type == AVMetadataObjectTypeQRCode {
            // 倘若發現的原資料與 QR code 原資料相同，更新狀態標籤的文字並設定邊界
            let qrCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metaDataObj) as! AVMetadataMachineReadableCodeObject
            
            qrCodeFrameView?.frame = qrCodeObject.bounds
            
            if qrCodeObject.stringValue != nil {
                QRCodeMessageLabel.text = qrCodeObject.stringValue
                
                /* 呼叫API */
                //let qrCodeUrl = ""
                //let paras: Parameters = ["email": "", "name": ""]
                //let qrCodeRequest = request(qrCodeUrl, method: .post, parameters: paras, encoding: URLEncoding.default)
                //debugPrint(qrCodeRequest)
                //qrCodeRequest.responseJSON(completionHandler: { (response: DataResponse<Any>) in
                //    switch response.result {
                //    case .success(let value):
                //        let returnJSON = JSON(value)
                
                // 成功後
                // 將QRCode相關設置清除
                self.captureSession?.stopRunning()
                self.videoPreviewLayer?.removeFromSuperlayer()
                self.qrCodeFrameView?.removeFromSuperview()
                // 顯示成功資訊
                self.QRCodeMessageLabel.text = ""
                self.view.bringSubview(toFront: successImageView)
                self.view.bringSubview(toFront: successLabel)
                //    case .failure(let error):
                //        self.showAlertWithMessage(alertMessage: "傳送失敗，請再試一次～")
                //        print("=====\(error.localizedDescription)=====")
                          
                //    }
                //})
            }
        }
    }

    // MARK:- User Defined Method
    func showAlertWithMessage(alertMessage: String){
        let alert = UIAlertController(title: "Lunttery", message: "", preferredStyle: UIAlertControllerStyle.alert)
        
        // 自定義message font size etc.
        let textFont = UIFont(name: ".PingFangTC-Regular", size: 15)
        let attributedStr = NSAttributedString(string: alertMessage, attributes: [NSFontAttributeName: textFont!])
        
        alert.setValue(attributedStr, forKey: "attributedMessage")
        
        alert.addAction(UIAlertAction(title: "關閉", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
