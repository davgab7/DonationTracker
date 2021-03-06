//
//  ProfileVC.swift
//  DonationTracker
//
//  Created by Gabe Wilson on 10/25/18.
//  Copyright © 2018 Gabe Wilson. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func profileUnwind(segue: UIStoryboardSegue) {
        if segue.identifier == "profileUnwindFromRegisterEmployee" {
            print("from registered")
            //add pending request to Employee
            items.insert("Employee Status Pending...", at: 3)
            tableView.reloadData()
        } else if segue.identifier == "profileUnwindFromRegisterAdmin" {
            print("from admin ")
            items.insert("Admin Status Pending...", at: 3)
            tableView.reloadData()
        }
    }
    
    var employees = [PFUser]()
    var requests = [PFUser]()
    var items = ["Places", "Invite Contacts", "Subscriptions", "More", "Log Out"]
    var userLocations = [Location]()
    
    override func viewDidLoad() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        print(DataModel.employeeStatus, "this is the status")
        if DataModel.employeeStatus == "Requested" {
            items.insert("Employee Status Pending...", at: 3)
        } else if DataModel.employeeStatus == "Registered" {
            items.insert("Employee Account", at: 3)
        }
        
        print(DataModel.adminStatus, "this is the admin stat")
        if DataModel.adminStatus == "Requested" {
            items.insert("Admin Status Pending...", at: 3)
        } else if DataModel.adminStatus == "Registered" {
            items.insert("Employees", at: 3)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func showSubscriptions() {
        print("showing subscriptions")
        self.performSegue(withIdentifier: "showSubscriptions", sender: nil)
    }
    
    func showInviteContacts() {
        self.performSegue(withIdentifier: "showInviteContacts", sender: nil)
    }
    
    func showMore() {
        self.performSegue(withIdentifier: "showMore", sender: nil)
    }
    
    func showLogout() {
        let refreshAlert = UIAlertController(title: "Notice", message: "Are you sure you want to log out?", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (action: UIAlertAction!) in
            PFUser.logOut()
            print("logging out")
            self.performSegue(withIdentifier: "registrationUnwind", sender: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("this is the first item",items[0])
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        profileCell.selectionStyle = .none
        profileCell.iconImageView.image = UIImage(named: "ProfileIcon\(items[indexPath.row])")
        profileCell.titleLabel.text = items[indexPath.row]
        return profileCell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if items[indexPath.row] == "Places" {
            if let locations = DataModel.locations {
                self.userLocations = locations
                self.performSegue(withIdentifier: "showPlaces", sender: nil)
            } else {
                print("show alert view")
            }
            
        } else if items[indexPath.row] == "Invite Contacts" {
            showInviteContacts()
        } else if items[indexPath.row] == "Subscriptions" {
            showSubscriptions()
        } else if items[indexPath.row] == "More" {
            showMore()
        } else if items[indexPath.row] == "Log Out" {
            showLogout()
        } else if items[indexPath.row] == "Employee Status Pending..." {
            let verificationAlert = UIAlertController(title: "Notice", message: "Your employee request is currently being reviewed.", preferredStyle: UIAlertControllerStyle.alert)
            //textField.p
            verificationAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            }))
            present(verificationAlert, animated: true, completion: nil)
        } else if items[indexPath.row] == "Admin Status Pending..." {
            let verificationAlert = UIAlertController(title: "Notice", message: "Your admin request is currently being reviewed. This may take up to 3 business days.", preferredStyle: UIAlertControllerStyle.alert)
            verificationAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            }))
            present(verificationAlert, animated: true, completion: nil)
        } else if items[indexPath.row] == "Employees" {
            self.performSegue(withIdentifier: "showEmployees", sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPlaces" {
            let targetVC = segue.destination as! PlacesVC
            targetVC.locations = self.userLocations
        } else if segue.identifier == "showEmployees" {
            let targetVC = segue.destination as! EmployeesVC
        }
        
    }
    
}

