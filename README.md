# ToDoListExample
ToDo List uygulaması yaparken local notifiications örneği
Bu uygulama esas olarak Local Notifications kullanımı hedef alınmıştır.
kaynak olarak https://www.youtube.com/watch?v=E6Cw5WLDe-U&list=PLeZH1BMeQM3u3iE2eaP43-InUkpZRADm9 kullanılmıştır.

önemli :
bildirim bir struct olarak tanımlanıyor. Daha sonra bu obje asenkron olarak yazdırılıyor.

LOCAL NOTİFİVCATİONS DETAYLARI :

Local notifications da aynı uygulamada birden fazla bildirim vermek istiyorsan, request kısmındaki identifieri her bir bildirim için ayrı ayrı vermen lazım. 


Standart bir bildirim için aşağıdaki adımları izle

İçerik oluşturma : Burada content oluşturduktan sonra her bir bildirim geldiğinde ikonun yanınaa numara çıksın istersen .badge =  UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
Demek lazım.

     // Önce içerik oluştur
             let content = UNMutableNotificationContent ()
        //    UIApplication.shared.applicationIconBadgeNumber += 1
             content.title = title
             content.sound = .default
            content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
             content.body = body


2. Trigger ayarlamak
             // tetikleyeciyi ayarla
             
             // mevcut saatten 10 saniye sonrasını ayarlama
             let targetDate = date
             let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: targetDate), repeats: false)


3. Talep oluşturmak
             // talebi oluştur
            // burada identifier ile birden fazla bildirim yapma imkanı verirsin.
             let request = UNNotificationRequest(identifier: "id_\(title)", content: content, trigger: trigger)
           
   

4. Bildim merkezine yazmak.           
             // Bildirim aracına ekle
             UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                 
                 if error != nil {
                     print("error occured \(error)")
                 }
             })
            }
             


Ayrıca kalan bildirimleri silmek istersen ,

  let center = UNUserNotificationCenter.current()
     
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
       

Ama burada dikkat, sıradaki bildirimleride silebilirsin.
