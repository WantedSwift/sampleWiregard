//
//  ViewController.swift
//  sampleWiregard
//
//  Created by wanted on 5/24/23.
//

import UIKit
import WireGuardKit
import MobileCoreServices
import WireGuardKitGo
import WireGuardKitC

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}



class ViewController: UIViewController, TunnelsManagerActivationDelegate, TunnelsManagerListDelegate {
    
    @IBOutlet weak var image_power: UIImageView!
    @IBOutlet weak var connectview2: UIView!
    
    @IBOutlet weak var status_label: UILabel!
    
    
    @IBOutlet weak var view_connect1: UIView!
    @IBOutlet weak var view_center: UIView!
    
    
    func tunnelAdded(at index: Int) {
        
    }
    
    func tunnelModified(at index: Int) {
        
    }
    
    func tunnelMoved(from oldIndex: Int, to newIndex: Int) {
        
    }
    
    func tunnelRemoved(at index: Int, tunnel: TunnelContainer) {
        
    }
    
    func tunnelActivationAttemptFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationAttemptError) {
        
    }

    
    func tunnelActivationAttemptSucceeded(tunnel: TunnelContainer) {
        self.connected()
    }
    
    func tunnelActivationFailed(tunnel: TunnelContainer, error: TunnelsManagerActivationError) {
        
    }
    
    func tunnelActivationSucceeded(tunnel: TunnelContainer) {
        self.connected()
    }
    
    
    func connected(){
        status_label.text = "connected"
        connectview2.layer.borderColor = UIColor.green.cgColor
        view_center.layer.borderColor = UIColor.green.cgColor
        self.image_power.tintColor = UIColor.green
    }
    
    func connecting(){
        status_label.text = "connecting..."
        connectview2.layer.borderColor = UIColor(named: "blue")!.cgColor
        view_center.layer.borderColor = UIColor(named: "blue")!.cgColor
        self.image_power.tintColor = UIColor.white
    }
    
    func disconnect(){
        status_label.text = "disconnect"
        connectview2.layer.borderColor = UIColor.gray.cgColor
        self.image_power.tintColor = UIColor.white
        view_center.layer.borderColor = UIColor.white.cgColor
    }
    
    func fail(){
        status_label.text = "not available"
        connectview2.layer.borderColor = UIColor.gray.cgColor
        self.image_power.tintColor = UIColor.red
        view_center.layer.borderColor = UIColor.white.cgColor
    }
    
    var tunnelsManager: TunnelsManager?
    var onTunnelsManagerReady: ((TunnelsManager) -> Void)?
    
    let tunnelNames = [
        "demo",
        "edgesecurity",
        "home",
        "office",
        "infra-fr",
        "infra-us",
        "krantz",
        "metheny",
        "frisell"
    ]
    
    
    
    
    let address = "10.7.0.2/24"
    let address2 = "fddd:2c4:2c4:2c4::2/64"
    let dnsServers = ["4.2.2.4", "8.8.4.4"]
    let endpoint = "95.81.84.250:51820"
    let allowedIPs = "0.0.0.0/0"
    let allowedIPs2 = "::/0"
//::/0
    @IBOutlet weak var connect_bt: UIButton!
    var is_connected = false
    
    @IBAction func connect_ac(_ sender: Any) {
        if let tunnel = self.tunnelsManager!.tunnel(named: "Wanted") {
            if  tunnel.status == .active {
                self.tunnelsManager!.startDeactivation(of: tunnel)
                self.disconnect()
                return
            }
        }
       
        self.connecting()
        let str = "W0ludGVyZmFjZV0KQWRkcmVzcyA9IDEwLjcuMC4yLzI0LCBmZGRkOjJjNDoyYzQ6MmM0OjoyLzY0CkROUyA9IDQuMi4yLjQsIDguOC40LjQKUHJpdmF0ZUtleSA9IG9KSDVKQkw5WlBXMDhaeGo1dU1ua2UzRGhMYXJMb3dMOUNaNXN2aldUR0E9CgpbUGVlcl0KUHVibGljS2V5ID0gZTlNVmxqaEh3UlFvcERQbTFKQ01abkVoamU2T3Q3UlRsU2VyQTBKTGtTcz0KUHJlc2hhcmVkS2V5ID0gckVmMnQxVUFaZVZhUFBYS2V6N1NuaUhYdW5hdUZSbjRxT3hnZDVNakJJcz0KQWxsb3dlZElQcyA9IDAuMC4wLjAvMCwgOjovMApFbmRwb2ludCA9IDk1LjgxLjg0LjI1MDo1MTgyMApQZXJzaXN0ZW50S2VlcGFsaXZlID0gMjUK"
        let decode = str.base64Decoded()
        print("Decoded is =>",decode!)
        
        let scannedTunnelConfiguration = try? TunnelConfiguration(fromWgQuickConfig: decode!, called: "Scanned")
        var tunnelConfiguration = scannedTunnelConfiguration
        tunnelConfiguration!.name = "Wanted"
        
        var interface = InterfaceConfiguration(privateKey: PrivateKey(base64Key: "oJH5JBL9ZPW08Zxj5uMnke3DhLarLowL9CZ5svjWTGA=")!)
        interface.addresses = [IPAddressRange(from: String(format: address, Int.random(in: 1 ... 10), Int.random(in: 1 ... 254)))!,IPAddressRange(from: String(format: address2, Int.random(in: 1 ... 10), Int.random(in: 1 ... 254)))!]
        interface.dns = dnsServers.map { DNSServer(from: $0)! }

        var peer = PeerConfiguration(publicKey: PublicKey(base64Key: "e9MVljhHwRQopDPm1JCMZnEhje6Ot7RTlSerA0JLkSs=")!)
        peer.endpoint = Endpoint(from: endpoint)
        peer.allowedIPs = [IPAddressRange(from: allowedIPs)!,IPAddressRange(from: allowedIPs2)!]
        peer.persistentKeepAlive = 25
        peer.preSharedKey = PreSharedKey(base64Key: "rEf2t1UAZeVaPPXKez7SniHXunauFRn4qOxgd5MjBIs=")

        tunnelConfiguration = scannedTunnelConfiguration//TunnelConfiguration(name: "wanted_ir", interface: interface, peers: [peer])
        

        tunnelsManager?.add(tunnelConfiguration: tunnelConfiguration!) { result in
            switch result {
            case .failure(let error):
                print("errror is=",error.alertText.title)
                if error.alertText.title == "alertTunnelAlreadyExistsWithThatNameTitle" {
                    let tunnel = self.tunnelsManager!.tunnel(named: "Wanted")
                    self.tunnelsManager!.startActivation(of: tunnel!)
                }
               // ErrorPresenter.showErrorAlert(error: error, from: qrScanViewController, onDismissal: completionHandler)
            case .success:
                print("added sucses")
                let tunnel = self.tunnelsManager!.tunnel(named: "Wanted")
                self.tunnelsManager!.startActivation(of: tunnel!)
     //           completionHandler?()
                
            }
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view_center.layer.cornerRadius = self.view_center.frame.height / 2
        self.view_center.layer.borderWidth = 1
        self.view_center.layer.borderColor = UIColor(named: "blue")!.cgColor
        self.view_center.layer.masksToBounds = true
        
        connect_bt.layer.cornerRadius = 12
        connect_bt.layer.masksToBounds = true
        
        connectview2.layer.borderWidth = 1
        connectview2.layer.borderColor = UIColor(named: "blue")!.cgColor
        connectview2.layer.cornerRadius = 12
        connectview2.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        TunnelsManager.create { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .failure(let error):
                print("errror is2=",error)
            case .success(let tunnelsManager):
                self.tunnelsManager = tunnelsManager
                self.setTunnelsManager(tunnelsManager: tunnelsManager)

                tunnelsManager.activationDelegate = self

                self.onTunnelsManagerReady?(tunnelsManager)
                self.onTunnelsManagerReady = nil
            }
        }
        
        
    }
    
    func setTunnelsManager(tunnelsManager: TunnelsManager) {
        self.tunnelsManager = tunnelsManager
        tunnelsManager.tunnelsListDelegate = self

  
    }
    
    func scanDidEncounterError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "actionOK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        })
        present(alertController, animated: true)
    
    }


}

