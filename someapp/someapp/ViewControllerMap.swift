//
//  ViewControllerMap.swift
//  someapp
//
//  Created by Maksim Dvoryakov on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class ViewControllerMap: UIViewController {
    
    @IBOutlet weak var gMapViev: GMSMapView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var timer: Timer!
    var counter: Int!
    var rectangle = GMSPolyline()
    var startCor = CLLocation()
    var curCor = CLLocation()
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    var flag = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden=false
        stopButton.isHidden=true
        durationLabel.text="0.0"
        distanceLabel.text="0.0"
        speedLabel.text="0.0"
        caloriesLabel.text="0.0"
        counter=0
        flag=false
        let camera = GMSCameraPosition.camera(withLatitude: 53.939550, longitude: 27.464190, zoom: 10)
        //mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        gMapViev.animate(to: camera)
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
 
        /*locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }*/
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    
    
    @IBAction func startF(_ sender: Any) {
        flag=true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        startButton.isHidden=true
        stopButton.isHidden=false
        
    }
    
    @objc func timerUpdate() {
        counter+=1
        durationLabel.text = String(counter)
        
        var distance=startCor.distance(from: curCor)
        self.distanceLabel.text=String(distance)
        self.speedLabel.text=String(Double(distance)/(Double(counter)/3600.0))
        self.caloriesLabel.text=String((88*Double(distance)*Double(distance)/(Double(counter)/3600.0))/4184)
    }
    
    @IBAction func stopF(_ sender: Any) {
        timer.invalidate()
        durationLabel.text = "0.0"
        counter=0
        startButton.isHidden=false
        stopButton.isHidden=true
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ViewControllerMap: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        print(userLocation)
        if(flag==true){
            startCor = userLocation!
            flag=false
        }
        curCor = userLocation!
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        gMapViev.animate(to: camera)
        mapView.isMyLocationEnabled = true
        
        locationManager.stopUpdatingLocation()
        /*let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
         print(locValue)*/
    }
}
