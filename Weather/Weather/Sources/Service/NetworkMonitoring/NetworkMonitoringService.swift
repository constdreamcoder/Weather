//
//  NetworkMonitor.swift
//  Weather
//
//  Created by SUCHAN CHANG on 9/28/24.
//

import Foundation
import Network
import Combine

protocol NetworkMonitoringServiceProtocol {
    var isConnected: CurrentValueSubject<Bool, Never> { get }
}

/// 네트워크 모니터링 서비스
final class NetworkMonitoringService: NetworkMonitoringServiceProtocol {
    
    var isConnected = CurrentValueSubject<Bool, Never>(true)
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitoringQueue", qos: .background)
    
    init() {
        monitor.pathUpdateHandler = {  path in
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                isConnected.send(path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
