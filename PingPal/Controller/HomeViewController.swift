//
//  HomeViewController.swift
//  PingPal
//
//  Created by DJ on 4/8/18.
//  Copyright © 2018 DJ Rose. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let db = Firestore.firestore()
    var pingArray = [Ping]()
    
    @IBOutlet var pingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pingTableView.delegate = self
        pingTableView.dataSource = self
        
        pingTableView.register(UINib(nibName: "PingCell", bundle: nil), forCellReuseIdentifier: "customPingCell")
        
        configureTableView()
        retrievePings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out. Please try again")
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customPingCell", for: indexPath) as! CustomPingCell
        
        cell.dateLabel.text = formatDate(date: pingArray[indexPath.row].date)
        cell.dayOfWeekLabel.text = DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: pingArray[indexPath.row].date)]
        cell.senderLabel.text = pingArray[indexPath.row].sender
        cell.avatarImageView.image = UIImage(named: "avatar")
        cell.titleLabel.text = pingArray[indexPath.row].title
        cell.statusImageView.image = UIImage(named: "tentative")

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pingArray.count
    }
    
    func loadPingsToModel(fieldName: String) {
        let currentUser = Auth.auth().currentUser!.email!
        let pingsRef = db.collection("pings").whereField(fieldName, isEqualTo: currentUser)
        
        pingsRef.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let snapshotValue = document.data()
                    
                    let date = self.convertToDate(date: snapshotValue["date"] as! String)
                    let sender = snapshotValue["sender"] as! String
                    let title = snapshotValue["title"] as! String
                    let invitee = snapshotValue["invitee"] as! String
                    
                    let ping = Ping()
                    
                    ping.date = date
                    ping.sender = sender
                    ping.title = title
                    ping.invitee = invitee
                    
                    self.pingArray.append(ping)
                    self.pingTableView.reloadData()
                    self.configureTableView()
                }
            }
        }
    }
    
    func retrievePings() {
        loadPingsToModel(fieldName: "sender")
        loadPingsToModel(fieldName: "invitee")
            
        self.pingTableView.reloadData()
    }
    
    func configureTableView () {
        pingTableView.rowHeight = UITableViewAutomaticDimension
        pingTableView.estimatedRowHeight = 100.0
    }
    
    func convertToDate(date: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "MM-dd-yyyy HH:mm a"
        return f.date(from: date)!
    }
    
    func formatDate(date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "dd MMM"
        return f.string(from: date)
    }

}
