//
//  BLEManager.swift
//  BikeVision
//
//  Created by Siamak Ashrafi on 2/23/25.
//
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var bikePeripheral: CBPeripheral?

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            // Start scanning for peripherals with a specific service UUID (replace with your bike's UUID)
            centralManager.scanForPeripherals(withServices: [CBUUID(string: "YOUR_SERVICE_UUID")], options: nil)
        } else {
            print("Bluetooth is not available.")
        }
    }

    // Called when a peripheral is discovered
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "Unknown Device")")
        bikePeripheral = peripheral
        centralManager.stopScan()
        bikePeripheral?.delegate = self
        centralManager.connect(bikePeripheral!, options: nil)
    }

    // Called when the connection is successful
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to bike!")
        // Discover services offered by the bike
        peripheral.discoverServices([CBUUID(string: "YOUR_SERVICE_UUID")])
    }

    // Discover characteristics for each service
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }

    // Handle discovered characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                print("Characteristic: \(characteristic.uuid)")
                // For readable characteristics
                if characteristic.properties.contains(.read) {
                    peripheral.readValue(for: characteristic)
                }
                // For characteristics that send notifications
                if characteristic.properties.contains(.notify) {
                    peripheral.setNotifyValue(true, for: characteristic)
                }
            }
        }
    }

    // Handle updates to characteristic values
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let value = characteristic.value {
            print("Received value: \(value)")
            // Process the data (e.g., decode sensor readings)
        }
    }
}

