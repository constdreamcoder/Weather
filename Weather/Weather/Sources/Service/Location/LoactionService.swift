//
//  LoactionService.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/26/24.
//

import CoreLocation
import Combine

protocol LocationServiceProtocol: CLLocationManagerDelegate {
    var subject: CurrentValueSubject<CLLocationCoordinate2D?, Error> { get }
    func checkDeviceLocationAuthorization()
}

final class LocationService: NSObject, LocationServiceProtocol{
    
    private let locationManager = CLLocationManager()
    let subject = CurrentValueSubject<CLLocationCoordinate2D?, Error>(CLLocationCoordinate2D())
    
    override init() {
        super.init()
        
        locationManager.delegate = self        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            subject.send(coordinate)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        subject.send(completion: .failure(error))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
    
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            if CLLocationManager.locationServicesEnabled() {
                let authorizationStatus: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorizationStatus = locationManager.authorizationStatus
                } else {
                    authorizationStatus = CLLocationManager.authorizationStatus()
                }
                
                checkCurrentLocationAuthorization(status: authorizationStatus)
            } else {
                print("위치 서비스가 꺼져 있어서, 위치 권한 요청을 할 수 없습니다.")
            }
        }
    }
    
    private func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            showLocationSettingAlert()
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        case .authorized:
            print("authorized")
        @unknown default:
            print("Error")
        }
    }
    
    private func showLocationSettingAlert() {
        print("Location access denied. Please enable location services in settings.")
        subject.send(nil)
    }
}
