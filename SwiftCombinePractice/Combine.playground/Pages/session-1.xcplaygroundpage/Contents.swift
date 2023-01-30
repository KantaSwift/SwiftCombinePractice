// Combineとは
// -> オブジェクトからオブジェクトに※イベントを伝える仕組みを提供する
// ※イベント == ここでいうイベントとは※GUIの操作やネットワーク通信などApp内で発生した何かしらの変化を伝える

// 例①: 文字列の値を渡すイベント

import Combine
import Foundation

// 決して失敗しないことをNeverで表している
// イベントを送信するオブジェクト(※Publisherという)
let subject = PassthroughSubject<String, Never>()

final class Receiver {
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        subject
            .sink { value in // sinkメソッド -> イベントを受信した時の処理を指定
                print("ReceivedValue:", value)
            }
            .store(in: &subscriptions)
    }
}

// イベントを受信するオブジェクト
let receiver = Receiver()
subject.send("a")
subject.send("i")

//Publisher
// ->上記でいうPassthroughSubjectはPublisherの一つ
// 標準フレームワークでPublisherを生成するものが他にもある

// 例②: NotificationCenter

let myNotification = Notification.Name("MyNotification")
let publisher = NotificationCenter.default.publisher(for: myNotification)

final class Receiver2 {
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        publisher.sink { value in
            print("Received Value:", value)
        }
        .store(in: &subscriptions)
    }
}

let receiver2 = Receiver2()
NotificationCenter.default.post(Notification(name: myNotification))
// NotificationCenterはpostされるとイベントが発生される

// 例③: Timer

let publisher2 = Timer.publish(every: 1, on: .main, in: .common)

final class Receiver3 {
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        publisher2
            .sink { value in
                print("ReceivedValue:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver3 = Receiver3()
// Timerは一定期間ごとにconnetctメソッドを呼び出すことで、Publishをする
// ※autoConnectでもOK
//publisher2.connect()

// Publisherはこれ以外にもURLSessionやSuquenceにも用意されている。またPublisherを自分で作ることもできる

