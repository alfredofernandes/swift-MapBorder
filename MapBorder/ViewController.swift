//
//  ViewController.swift
//  MapBorder
//
//  Created by Alfredo Fernandes on 2017-06-29.
//  Copyright © 2017 Alfredo Fernandes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var mapObj: MKMapView!
    @IBOutlet weak var countryName1: UITextField!
    @IBOutlet weak var countryName2: UITextField!
    @IBOutlet weak var tableDistances: UITableView!
    
    var mapManager = CLLocationManager()
    var border : [Border] = []
    var annotations : [MKPointAnnotation] = []
    var distances: [[String:String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup after loading the view
        countryName1.delegate = self
        countryName2.delegate = self
        mapManager.delegate = self                            // ViewController is the "owner" of the map.
        mapManager.desiredAccuracy = kCLLocationAccuracyBest  // Define the best location possible to be used in app.
        mapManager.requestWhenInUseAuthorization()            // The feature will not run in background
        mapManager.startUpdatingLocation()                    // Continuously geo-position update
        mapObj.delegate = self
        
        loadData()
    }
    
    @IBAction func findBorder(_ sender: UIButton?) {
        
        mapObj.removeAnnotations(annotations)
        countryName1.resignFirstResponder()
        countryName2.resignFirstResponder()
        
        self.distances = []
        self.annotations = []
        
        let country1 = retrieveData(countryName: countryName1.text!)
        let country2 = retrieveData(countryName: countryName2.text!)
        
        if (country1 != nil || country2 != nil) && (countryName1.text! == countryName2.text!) {
            self.showAlert(message: "Please, enter with different countries!")
            
        } else if (country1 != nil && country2 != nil) {
            self.addAnnotation(country: country1!.country)
            self.addAnnotation(country: country2!.country)
            
            var sameBorder:[Country] = []

            // Compare borders
            for c1 in country1!.countryborder {
                for c2 in country2!.countryborder {
                    if c1.countryName == c2.countryName {
                        sameBorder.append(c1)
                    }
                }
            }

            // Add countries annotations
            for c in sameBorder {
                self.addAnnotation(country: c)
            }
            
            let zoom:MKCoordinateSpan = MKCoordinateSpanMake(70, 70)
            let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(country1!.country.latitude, country1!.country.longitude)
            let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, zoom)
            mapObj.setRegion(region, animated: true)
            
            // Distances
            let distanceC1C2 = ["from" : country1!.country.countryName,
                                "to" : country2!.country.countryName,
                                "distance" : findDistance(from: country1!.country, to: country2!.country)]
            
            distances.append(distanceC1C2)
            
            for c in sameBorder {
                let distance = ["from" : country1!.country.countryName,
                                "to" : c.countryName,
                                "distance" : findDistance(from: country1!.country, to: c)]
                
                distances.append(distance)
            }
            
            for c in sameBorder {
                let distance = ["from" : country2!.country.countryName,
                                "to" : c.countryName,
                                "distance" : findDistance(from: country2!.country, to: c)]
                
                distances.append(distance)
            }
            
            self.tableDistances.reloadData()
            
        } else {
            self.showAlert(message: "Please, enter with two valid countries!")
        }
    }
    
    func findDistance(from: Country, to: Country) -> String {
        let coordinate0 = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let coordinate1 = CLLocation(latitude: to.latitude, longitude: to.longitude)
        let distance = coordinate0.distance(from: coordinate1) / 1000
        return String(distance.rounded()) + " KM"
    }
    
    func addAnnotation(country: Country) {
        let userAnnotation = MKPointAnnotation()
        userAnnotation.coordinate = CLLocationCoordinate2DMake(country.latitude, country.longitude)
        mapObj.addAnnotation(userAnnotation)
        annotations.append(userAnnotation)
    }
    
    func retrieveData(countryName: String) -> Border? {
        if (countryName != "") {
            for b in border {
                if (b.country.countryName == countryName) {
                    return b
                }
            }
        }
        return nil
    }
    
    func loadData() {
        
        // List of Countries - South America
        let ar = Country(name: "Argentina", cap: "Buenos Aires", lat: -34.58333333, long: -58.666667)
        let bo = Country(name: "Bolivia", cap: "La Paz", lat: -16.5, long: -68.15)
        let br = Country(name: "Brazil", cap: "Brasilia", lat: -15.78333333, long: -47.916667)
        let cl = Country(name: "Chile", cap: "Santiago", lat: -33.45, long: -70.666667)
        let co = Country(name: "Colombia", cap: "Bogota", lat: 4.6, long: -74.083333)
        let ec = Country(name: "Ecuador", cap: "Quito", lat: -0.216666667, long: -78.5)
        let gy = Country(name: "Guyana", cap: "Georgetown", lat: 6.8, long: -58.15)
        let fg = Country(name: "French Guiana", cap: "Cayenne", lat: 3.9339, long: -53.1258)
        let pa = Country(name: "Panama", cap: "Panama City", lat: 8.966666667, long: -79.533333)
        let py = Country(name: "Paraguay", cap: "Asuncion", lat: -25.26666667, long: -57.666667)
        let pe = Country(name: "Peru", cap: "Lima", lat: -12.05, long: -77.05)
        let sr = Country(name: "Suriname", cap: "Paramaribo", lat: 5.833333333, long: -55.166667)
        let uy = Country(name: "Uruguay", cap: "Montevideo", lat: -34.85, long: -56.166667)
        let ve = Country(name: "Venezuela", cap: "Caracas", lat: 10.48333333, long: -66.866667)
        let cr = Country(name: "Costa Rica", cap: "San Jose", lat: 9.933333333, long: -84.083333)
        
        // Borders Venezuela
        let bVE = Border(country: ve)
        bVE.addBorder(country: co)
        bVE.addBorder(country: br)
        bVE.addBorder(country: gy)
        border.append(bVE)
        
        // Borders Uruguay
        let bUY = Border(country: uy)
        bUY.addBorder(country: br)
        bUY.addBorder(country: ar)
        border.append(bUY)
        
        // Borders Suriname
        let bSR = Border(country: sr)
        bSR.addBorder(country: fg)
        bSR.addBorder(country: br)
        bSR.addBorder(country: gy)
        border.append(bSR)
        
        // Borders Peru
        let bPE = Border(country: pe)
        bPE.addBorder(country: co)
        bPE.addBorder(country: ec)
        bPE.addBorder(country: br)
        bPE.addBorder(country: bo)
        bPE.addBorder(country: cl)
        border.append(bPE)
        
        // Borders Paraguay
        let bPY = Border(country: py)
        bPY.addBorder(country: bo)
        bPY.addBorder(country: ar)
        bPY.addBorder(country: br)
        border.append(bPY)
        
        // Borders Panama
        let bPA = Border(country: pa)
        bPA.addBorder(country: co)
        bPA.addBorder(country: cr)
        border.append(bPA)
        
        // Borders French Guiana
        let bFG = Border(country: fg)
        bFG.addBorder(country: sr)
        bFG.addBorder(country: br)
        border.append(bFG)
        
        // Borders Guyana
        let bGY = Border(country: gy)
        bGY.addBorder(country: sr)
        bGY.addBorder(country: br)
        bGY.addBorder(country: ve)
        border.append(bGY)
        
        // Borders Ecuador
        let bEC = Border(country: ec)
        bEC.addBorder(country: co)
        bEC.addBorder(country: pe)
        border.append(bEC)
        
        // Borders Colombia
        let bCO = Border(country: co)
        bCO.addBorder(country: ve)
        bCO.addBorder(country: ec)
        bCO.addBorder(country: pe)
        bCO.addBorder(country: br)
        bCO.addBorder(country: pa)
        border.append(bCO)
        
        // Borders Chile
        let bCL = Border(country: cl)
        bCL.addBorder(country: ar)
        bCL.addBorder(country: bo)
        bCL.addBorder(country: pe)
        border.append(bCL)
        
        // Borders Brazil
        let bBR = Border(country: br)
        bBR.addBorder(country: py)
        bBR.addBorder(country: uy)
        bBR.addBorder(country: ar)
        bBR.addBorder(country: bo)
        bBR.addBorder(country: pe)
        bBR.addBorder(country: co)
        bBR.addBorder(country: ve)
        bBR.addBorder(country: gy)
        bBR.addBorder(country: sr)
        bBR.addBorder(country: fg)
        border.append(bBR)
        
        // Borders Bolivia
        let bBO = Border(country: bo)
        bBO.addBorder(country: pe)
        bBO.addBorder(country: br)
        bBO.addBorder(country: py)
        bBO.addBorder(country: cl)
        bBO.addBorder(country: ar)
        border.append(bBO)
        
        // Borders Argentina
        let bAR = Border(country: ar)
        bAR.addBorder(country: cl)
        bAR.addBorder(country: py)
        bAR.addBorder(country: br)
        bAR.addBorder(country: bo)
        bAR.addBorder(country: uy)
        border.append(bAR)
    }
    
    // Drawing a red circle to pin on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 0.5
        return circleRenderer
    }
    
    //MARK: Table Delegate
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.distances.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DistanceTableViewCell {
            
            let distance = distances[indexPath.row]
            
            // Configure the cell...
            cell.lblFrom?.text = distance["from"]
            cell.lblTo?.text = distance["to"]
            cell.lblDistance?.text = distance["distance"]
            
            return cell
        } else {
            fatalError("The dequeued cell is not an instance of DistanceTableViewCell.")
        }
    }
    
    func showAlert(message:String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if (textField == countryName1) {
            countryName2.becomeFirstResponder()
        } else {
            self.findBorder(nil)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
