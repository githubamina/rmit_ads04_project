//
//  DeliveryTableViewController.swift
//  ADS104 Project
//
//  Created by Amina on 13/6/18.
//  Copyright © 2018 Amina Qureshi. All rights reserved.
//

import UIKit

class DeliveryTableViewController: UITableViewController {
    
    //array to store delivery objects to be displayed in list
    var deliveries = [Delivery]()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add edit button
        navigationItem.leftBarButtonItem = editButtonItem

        //check if delivery data can be loaded from disk. if so, load data from disk and if not, load sample data
        if let savedDeliveries = Delivery.loadDeliveries() {
            deliveries = savedDeliveries
        } else {
            deliveries = Delivery.loadSampleDeliveries()
        }
    }

  

    

    //get the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveries.count
    }
    
    
    //dequeue cell, assign appropriate data to it
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DeliveryCellIdentifier") else {
            fatalError("Could not dequeue a cell")
        }
        
        let delivery = deliveries[indexPath.row]
        
        
        //set recipient name, address, and status to cell text labels
        cell.textLabel?.text = delivery.recipientName
        cell.detailTextLabel?.text = delivery.deliveryAddress + " | " + delivery.status
        
        return cell
    }
    
    
    //specify that all rows in this table view can be edited by returning true
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //functionality to delete item when swiped and save the deletion to the disk
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deliveries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Delivery.saveDeliveries(deliveries)
        }
    }
    
    //when save is tapped in DeliveryViewController, use indexpath to check if the item already exists. if so, update the details, and if not, create a new entry. save data to disk in any case.
    @IBAction func unwindToDeliveryList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let sourceViewController = segue.source as! DeliveryViewController
        
        if let delivery = sourceViewController.delivery {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                deliveries[selectedIndexPath.row] = delivery
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: deliveries.count, section: 0)
                
                deliveries.append(delivery)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
        }
        Delivery.saveDeliveries(deliveries)
        
    }
    
    
    //when a delivery item is tapped, send the details to the DeliveryViewController so they can be displayed and edited
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            let deliveryViewController = segue.destination as! DeliveryViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedDelivery = deliveries[indexPath.row]
            deliveryViewController.delivery = selectedDelivery
        }
    }

    

}
