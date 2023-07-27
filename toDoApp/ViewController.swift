//
//  ViewController.swift
//  toDoApp
//
//  Created by ulas özalp on 16.07.2023.
//  https://www.youtube.com/watch?v=E6Cw5WLDe-U&list=PLeZH1BMeQM3u3iE2eaP43-InUkpZRADm9

import UIKit
import UserNotifications


class ViewController: UIViewController {
    var models = [Reminder]()
    var badgeNumber  : NSNumber = 0
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        // show register view
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? AddViewController else {
            return
        }
        vc.title = "New To Do"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = {title, body, date in
            
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = Reminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.tableView.reloadData()
                }
            
            // Önce içerik oluştur
             let content = UNMutableNotificationContent ()
        //    UIApplication.shared.applicationIconBadgeNumber += 1
             content.title = title
             content.sound = .default
            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
             content.body = body
             // tetikleyeciyi ayarla
             
             // mevcut saatten 10 saniye sonrasını ayarlama
             let targetDate = date
             let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
             // talebi oluştur
            // burada identifier ile birden fazla bildirim yapma imkanı verirsin.
             let request = UNNotificationRequest(identifier: "id_\(title)", content: content, trigger: trigger)
           
             
             // Bildirim aracına ekle
             UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                 
                 if error != nil {
                     print("error occured \(error)")
                 }
             })
            }
             
        
        navigationController?.pushViewController(vc, animated: true)
    }
   
    @IBAction func didTapTest(_ sender: UIBarButtonItem) {
        // test
        
        // get permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound], completionHandler: { success, error in
            
            if success {
                // schedule test
                self.scheduleTest()
            }
            else if error != nil
            {
                print("error occured !!")
            }
            
            
            
        })
    }
    
   
    func scheduleTest() {
        
       // Önce içerik oluştur
        let content = UNMutableNotificationContent ()
        content.title = "Hello"
        content.sound = .default
        content.body = "Here is the long body.Here is the long body.Here is the long body."
        // tetikleyeciyi ayarla
        
        // mevcut saatten 10 saniye sonrasını ayarlama
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)
        // talebi oluştur
        let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
      
        
        // Bildirim aracına ekle
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            
            if error != nil {
                print("error occured \(error)")
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        let center = UNUserNotificationCenter.current()
     
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
       
        
        
        
    }


}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
extension ViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let date = models[indexPath.row].date
        let formatter = DateFormatter()
        formatter.dateFormat = "d/MM/YYYY hh:mm a"  // 16/07/2023 02:35 pm şeklinde gösterir
        
        cell.detailTextLabel?.text = formatter.string(from: date)
        return cell
    }
    
}
struct Reminder {
    let title : String
    let date : Date
    let identifier : String
}
