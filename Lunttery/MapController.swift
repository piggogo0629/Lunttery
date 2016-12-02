//
//  MapController.swift
//  Lunttery
//
//  Created by Ollie on 2016/11/16.
//  Copyright © 2016年 Ollie. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK:- Variable
    var dinnerData: JSON!
    let locationManager = CLLocationManager()
    var overlayView: UIView? = nil
    var directionrRequest = MKDirectionsRequest()
    //var currentLocation: CLLocation?
    
    //MARK:- @IBOutlet
    @IBOutlet weak var myMapView: MKMapView!
    @IBOutlet weak var dinnerName: UILabel!
    
    //MARK:- @IBAction
    @IBAction func close(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Self func
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(dinnerData)
        dinnerName.text = dinnerData["name"].stringValue
        
        myMapView.delegate = self
        //self.myMapView.showsScale = true // 顯示比例尺
        self.myMapView.showsCompass = true // 顯示指南針
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.notDetermined {
            // 還沒有詢問過用戶以獲得權限
            locationManager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied {
            // 用戶不同意
            self.showAlertWithMessage(alertMessage: "已拒絕啟用定位服務。請從設置程序中重新啟用。")
            self.dismiss(animated: true, completion: nil)
        } else if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            // 用戶已經同意
            locationManager.startUpdatingLocation()
            
            // request user's location only once
            //locationManager.requestLocation()
        }
        
//        var destinationLocation: CLLocationCoordinate2D?
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(dinnerData["address"].stringValue) { (placeMarks: [CLPlacemark]?, error: Error?) in
//            if error != nil {
//                if error != nil {
//                    print("\(error?.localizedDescription)")
//                    return
//                }
//            }
//            
//            if let placeMark = placeMarks?.first {
//                destinationLocation = placeMark.location?.coordinate
//                print("\(placeMark.location?.coordinate)")
//            }
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- CLLocationManagerDelegate protocol
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let currentLocation = locations.first {
            // 1.The ViewController is the delegate of the MKMapViewDelegate protocol
            // 2.Set the latitude and longtitude of the locations
            
            let sourceLocation = currentLocation.coordinate
            
            let destinationLocation = CLLocation(latitude: dinnerData["lat"].doubleValue, longitude: dinnerData["lng"].doubleValue).coordinate
            
            // 3.Create placemark objects containing the location's coordinates
            let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation)
            let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation)
            
            // 4.MKMapitems are used for routing. This class encapsulates information about a specific point on the map
            let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
            let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
            
            //5.Annotations are added which shows the name of the placemarks
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = "我的位置"
            sourceAnnotation.coordinate = sourcePlaceMark.coordinate
            
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = dinnerData["name"].stringValue
            //destinationAnnotation.subtitle = dinnerData["address"].stringValue
            destinationAnnotation.coordinate = destinationPlaceMark.coordinate
            
            // 6.The annotations are displayed on the map
            // 將標註顯示出來
            self.myMapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
            // 不需按下大頭針即顯示標注泡泡框(callout bubble)
            self.myMapView.selectAnnotation(destinationAnnotation, animated: true)

            // 7.The MKDirectionsRequest class is used to compute the route.
            let directionrRequest = MKDirectionsRequest()
            directionrRequest.source = sourceMapItem
            directionrRequest.destination = destinationMapItem
            directionrRequest.transportType = .walking
            // Calculate the direction
            let directions = MKDirections(request: directionrRequest)
           
            //8.The route will be drawn using a polyline as a overlay view on top of the map. The region is set so both locations will be visible
            directions.calculate(completionHandler: { (response: MKDirectionsResponse?, error: Error?) in
                if error != nil {
                    print("\(error?.localizedDescription)")
                    return
                }
                
                let route = response?.routes[0]
                self.myMapView.add((route?.polyline)!, level: MKOverlayLevel.aboveRoads)
                
                let rect = route?.polyline.boundingMapRect
                self.myMapView.setRegion(MKCoordinateRegionForMapRect(rect!), animated: true)
            })
            
            manager.stopUpdatingLocation()
            
            // 9.implement the delegate method mapView(rendererForrOverlay:). This method return the renderer object which will be used to draw the route on the map.
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    //MARK:- MKMapViewDelegate protocol
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3
        
        return renderer
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
