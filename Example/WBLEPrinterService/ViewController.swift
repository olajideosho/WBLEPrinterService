//
//  ViewController.swift
//  WBLEPrinterService
//
//  Created by Olajide Osho on 01/06/2024.
//  Copyright (c) 2024 Olajide Osho. All rights reserved.
//

import UIKit
import WBLEPrinterService

class ViewController: UIViewController {
    var walureBluetooth: WalureBluetoothPrinterService?
    var deviceList: [String: BluetoothDevice] = [:]
    var tableData: [BluetoothDevice] = []

    var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Walure Bluetooth Test"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    var scanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Scan", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()

    var stopScanButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop Scan", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()

    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    var disconnectButton: UIButton = {
        let button = UIButton()
        button.setTitle("Disconnect", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()

    var testPrintButton: UIButton = {
        let button = UIButton()
        button.setTitle("Test Print", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .brown
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        tableview.delegate = self
        tableview.dataSource = self

        walureBluetooth = WalureBluetoothPrinterService(delegate: self)

        view.addSubview(infoLabel)
        view.addSubview(scanButton)
        view.addSubview(stopScanButton)
        view.addSubview(tableview)
        view.addSubview(disconnectButton)
        view.addSubview(testPrintButton)

        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true

        scanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scanButton.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20).isActive = true
        scanButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        scanButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        scanButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapScanButton(_:))))

        stopScanButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stopScanButton.topAnchor.constraint(equalTo: scanButton.bottomAnchor, constant: 20).isActive = true
        stopScanButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        stopScanButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stopScanButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStopScanButton(_:))))

        tableview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tableview.topAnchor.constraint(equalTo: stopScanButton.bottomAnchor, constant: 20).isActive = true
        tableview.widthAnchor.constraint(equalToConstant: 240).isActive = true
        tableview.heightAnchor.constraint(equalToConstant: 120).isActive = true

        disconnectButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        disconnectButton.topAnchor.constraint(equalTo: tableview.bottomAnchor, constant: 20).isActive = true
        disconnectButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        disconnectButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        disconnectButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapDisconnectButton(_:))))

        testPrintButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testPrintButton.topAnchor.constraint(equalTo: disconnectButton.bottomAnchor, constant: 20).isActive = true
        testPrintButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        testPrintButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        testPrintButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapPrintButton(_:))))
    }

    override func viewDidAppear(_ animated: Bool) {
        view.layoutSubviews()
    }

    @objc func didTapScanButton(_ sender: UITapGestureRecognizer) {
        guard let wb = walureBluetooth else { return }
        wb.startScanning()
    }

    @objc func didTapStopScanButton(_ sender: UITapGestureRecognizer) {
        guard let wb = walureBluetooth else { return }
        wb.stopScanning()
    }

    @objc func didTapDisconnectButton(_ sender: UITapGestureRecognizer) {
        guard let wb = walureBluetooth else { return }

        wb.disconnect()
    }

    @objc func didTapPrintButton(_ sender: UITapGestureRecognizer) {
        // MARK: - Test Functions
        guard let wb = walureBluetooth else { return }
        wb.setLineSpacing(numberOfDots: 0)
        if let logo = UIImage(named: "testLogo") {
            wb.printImage(image: logo, printHead: .mm58)
        } else {
            wb.setPrintJustification(justification: .center)
            wb.printLine(line: "Hello")
        }
        wb.setPrintJustification(justification: .center)
        wb.printLine(line: "-----------------")
        wb.printLine(line: "Hello")
    }
}

extension ViewController:  UITableViewDelegate,  UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = tableData[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = tableData[indexPath.row]

        guard let wb = walureBluetooth
        else { return }

        wb.connect(toDevice: device.id)
    }
}

extension ViewController: BluetoothPrinterDelegate {
    func didStartScanning() {
        infoLabel.text = "Scanning Started"
    }

    func didStopScanning() {
        infoLabel.text = "Scanning Stopped"
    }

    func didErrorOccur(error: PrinterError) {
        switch error {
        case .ConnectError(let deviceId):
            infoLabel.text = "Could not connect to device: \(deviceId)"
        case .DeviceNotFound:
            infoLabel.text = "Bluetooth Device Not Found"
        case .DisconnectError(let deviceId):
            infoLabel.text = "Could Not Disconnect from Bluetooth Device: \(deviceId)"
        case .NoPrintFunction:
            infoLabel.text = "Connected Printer has no Print Functionality"
        case .ServiceError:
            infoLabel.text = "Printer Service Error"
        case .StartScanError:
            infoLabel.text = "Could not start scanning process"
        case .StopScanError:
            infoLabel.text = "Could not stop scanning process"
        case .PrintError(let message):
            infoLabel.text = message
        }
    }

    func bluetoothStateDidChange(state: BluetoothState) {
        switch state {
        case .poweredOn:
            infoLabel.text = "Bluetooth is Enabled"
        case .poweredOff:
            infoLabel.text = "Bluetooth is Disabled"
        default:
            break
        }
    }

    func didDiscoverBluetoothDevice(device: BluetoothDevice, isConnectable: Bool) {
        if isConnectable {
            if deviceList[device.id] != nil {
                deviceList[device.id] = nil
            }
            deviceList[device.id] = device
            tableData = deviceList.map({ $0.value })
            tableData = tableData.sorted(by: {$0.name > $1.name})
            infoLabel.text = "\(deviceList.count) Devices Found"
            tableview.reloadData()
        }
    }

    func didConnectToDevice(device: BluetoothDevice) {
        infoLabel.text = "Connected to Device - Name: \(device.name) ID: \(device.id)"
    }

    func didDisconnectFromDevice(deviceId: String) {
        infoLabel.text = "Disconnected from printer ID: \(deviceId)"
    }

    func printFunctionDidBecomeReady() {
        infoLabel.text = "Print Function Ready"
    }
}



