//
//  ViewControllerMap.swift
//  someapp
//
//  Created by Maksim Dvoryakov on 05/06/2019.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewControllerMap: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var gMapViev: GMSMapView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var timer: Timer!
    var counter: Int!
    
    var locationManager = CLLocationManager()
    lazy var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.isHidden=false
        stopButton.isHidden=true
        durationLabel.text="0.0"
        distanceLabel.text="0.0"
        speedLabel.text="0.0"
        caloriesLabel.text="0.0"
        counter=0
        let camera = GMSCameraPosition.camera(withLatitude: 53.939550, longitude: 27.464190, zoom: 10)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        gMapViev = mapView
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        gMapViev = mapView
        
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func startF(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        startButton.isHidden=true
        stopButton.isHidden=false
        
    }
    
    @objc func timerUpdate() {
        
        counter+=1
        durationLabel.text = String(counter)

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
