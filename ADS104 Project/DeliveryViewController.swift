//
//  DeliveryViewController.swift
//  ADS104 Project
//
//  Created by Amina on 13/6/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import UIKit

class DeliveryViewController: UITableViewController {
    
    //property to store current delivery item
    var delivery: Delivery?

    //outlets to views
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var recipientNameTextField: UITextField!
    @IBOutlet weak var recipientAddressTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var statusLastUpdatedLabel: UILabel!
    @IBOutlet weak var statusLastUpdatedDatePicker: UIDatePicker!
    @IBOutlet weak var trackingNumberTextField: UITextField!
    @IBOutlet weak var dateDeliveredLabel: UILabel!
    @IBOutlet weak var dateDeliveredDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    //constant cell index paths of large sized cells
    let statusLastUpdatedDPCellIndexPath = IndexPath(row: 0, section: 3)
    let dateDeliveredDPCellIndexPath = IndexPath(row: 0, section: 5)
    let notesCellIndexPath = IndexPath(row: 0 , section: 6)
    
    
    //variables to store whether or not the date pickers are being shown
    var isStatusLastUpdatedDatePickerShown: Bool = false {
        didSet {
            statusLastUpdatedDatePicker.isHidden = !isStatusLastUpdatedDatePickerShown
        }
    }
    
    var isDateDeliveredDatePickerShown: Bool = false {
        didSet {
            dateDeliveredDatePicker.isHidden = !isDateDeliveredDatePickerShown
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checks for delivery item and updates views accordingly
        if let delivery = delivery {
            navigationItem.title = "Delivery"
            recipientNameTextField.text = delivery.recipientName
            recipientAddressTextField.text = delivery.deliveryAddress
            statusTextField.text = delivery.status
            trackingNumberTextField.text = delivery.parcelTrackingNumber
            dateDeliveredDatePicker.date = delivery.delivered
            statusLastUpdatedDatePicker.date = delivery.lastUpdated
            notesTextView.text = delivery.notes
        }

        //call methods to update UI
        updateDateViews()
        updateSaveButtonState()
        
    }

    
    //method to only allow save button to be enabled if all text fields have text in them
    func updateSaveButtonState() {
        let name = recipientNameTextField.text ?? ""
        let address = recipientAddressTextField.text ?? ""
        let status = statusTextField.text ?? ""
        let tracking = trackingNumberTextField.text ?? ""
        
        saveButton.isEnabled = !name.isEmpty && !address.isEmpty && !status.isEmpty && !tracking.isEmpty
    }
    
    //when editing occurs in any of the text fields, call updateSaveButtonState()
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    @IBAction func returnPressed(_ sender: UITextField) {
        switch(sender) {
        case recipientNameTextField:
            recipientNameTextField.resignFirstResponder()
        case recipientAddressTextField:
            recipientAddressTextField.resignFirstResponder()
        case trackingNumberTextField:
            trackingNumberTextField.resignFirstResponder()
        case statusTextField:
            statusTextField.resignFirstResponder()
        default:
            break
        }
    }
    
    //update the date labels with currently selected dates
    func updateDateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        statusLastUpdatedLabel.text = dateFormatter.string(from: statusLastUpdatedDatePicker.date)
        dateDeliveredLabel.text = dateFormatter.string(from: dateDeliveredDatePicker.date)
    }
    
    //call updateDateViews whenever the date pickers have had their current selection changed
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    //determine appropriate heights for different cells- mainly to adjust the height of date picker cells when they are selected/not-selected
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (statusLastUpdatedDPCellIndexPath.section, statusLastUpdatedDPCellIndexPath.row):
            if isStatusLastUpdatedDatePickerShown {
                return 200.0
            } else {
                return 44.0
            }
        case(dateDeliveredDPCellIndexPath.section, dateDeliveredDPCellIndexPath.row):
            if isDateDeliveredDatePickerShown {
                return 200.0
            } else {
                return 44.0
            }
        case (notesCellIndexPath.section, notesCellIndexPath.row):
            return 200.0
        default:
            return 44.0
        }
    }
    
    //update the 'shown' status of each date picker cell depending on if they are selected or not
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch(indexPath.section, indexPath.row) {
        case(statusLastUpdatedDPCellIndexPath.section, statusLastUpdatedDPCellIndexPath.row):
            if isStatusLastUpdatedDatePickerShown {
                isStatusLastUpdatedDatePickerShown = false
            } else if isDateDeliveredDatePickerShown {
                isDateDeliveredDatePickerShown = false
                isStatusLastUpdatedDatePickerShown = true
            } else {
                isStatusLastUpdatedDatePickerShown = true
            }
            
            statusLastUpdatedLabel.textColor = isStatusLastUpdatedDatePickerShown ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case(dateDeliveredDPCellIndexPath.section, dateDeliveredDPCellIndexPath.row):
            if isDateDeliveredDatePickerShown {
                isDateDeliveredDatePickerShown = false
            } else if isStatusLastUpdatedDatePickerShown {
                isStatusLastUpdatedDatePickerShown = false
                isDateDeliveredDatePickerShown = true
            } else {
                isDateDeliveredDatePickerShown = true
            }
            
            dateDeliveredLabel.textColor = isDateDeliveredDatePickerShown ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
    
    
    //stores data from static table view in delivery object to be sent to DeliveryTableViewController and saved to disk
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let recipientName = recipientNameTextField.text!
        let recipientAddress = recipientAddressTextField.text!
        let status = statusTextField.text!
        let trackingNumber = trackingNumberTextField.text!
        let notes = notesTextView.text
        let statusLastUpdated = statusLastUpdatedDatePicker.date
        let dateDelivered = dateDeliveredDatePicker.date
    
    
        delivery = Delivery(recipientName: recipientName, deliveryAddress: recipientAddress, status: status, parcelTrackingNumber: trackingNumber, lastUpdated: statusLastUpdated, delivered: dateDelivered, notes: notes)
    }
}
