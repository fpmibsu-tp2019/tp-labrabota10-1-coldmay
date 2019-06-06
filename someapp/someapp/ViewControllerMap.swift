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
import MapKit

class ViewControllerMap: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapViewA: MKMapView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var timer: Timer!
    var counter: Int!
    var rectangle = GMSPolyline()
    var startCor: CLLocationCoordinate2D?
    var curCor:CLLocationCoordinate2D?
    var locationManager = CLLocationManager()
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
        mapViewA.delegate = self
        mapViewA.showsScale = true
        mapViewA.showsPointsOfInterest = true
        mapViewA.showsUserLocation = true
        
 
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        startCor = locationManager.location?.coordinate
        
    }
    
    @IBAction func startF(_ sender: Any) {
        flag=true
        
        print(startCor)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        startButton.isHidden=true
        stopButton.isHidden=false
        
    }
    
    @objc func timerUpdate() {
        counter+=1
        durationLabel.text = String(counter)
        curCor = locationManager.location?.coordinate
        let point1 = CLLocation(latitude: startCor!.latitude, longitude: startCor!.longitude)
        let point2 = CLLocation(latitude: curCor!.latitude, longitude: curCor!.longitude)
        var distance=point1.distance(from: point2)
        self.distanceLabel.text=String(distance)
        self.speedLabel.text=String(Double(distance)/(Double(counter)/3600.0))
        self.caloriesLabel.text=String((88*Double(distance)*Double(distance)/(Double(counter)/3600.0))/4184)
        
        
        
        let sourcePlacemark = MKPlacemark(coordinate: startCor!)
        let destPlacemark = MKPlacemark(coordinate: curCor!)
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response,error in
            guard let response = response else {
                if let error = error{
                    print("Something Went Wrong")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapViewA.addOverlay(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapViewA.setRegion(MKCoordinateRegion(rekt), animated: true)
        })
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolygonRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    @IBAction func stopF(_ sender: Any) {
        timer.invalidate()
        durationLabel.text = "0.0"
        distanceLabel.text = "0.0"
        speedLabel.text = "0.0"
        caloriesLabel.text = "0.0"
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

/*extension ViewControllerMap: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let locValue: CLLocationCoordinate2D = (manager.location?.coordinate)!
         print(locValue)
        if(flag==true){
            startCor = userLocation!
            flag=false
        }
        curCor = userLocation!
    }
}*/
