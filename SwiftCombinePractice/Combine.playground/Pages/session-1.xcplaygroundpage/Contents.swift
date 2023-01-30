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




//Subscription
// -> イベント処理を指定すること「subscribe」という
// subscribeしたときの戻り値を「subscription」という
// ->今までやってきたことを見るとsinkメソッドが「subscribe」の一つ
// ->storeメソッドがsubscriptionを保存するメソッド
//    ->これがないとsubscribeで指定した処理が破棄されてしまう



let subject1 = PassthroughSubject<String, Never>()
let subject2 = PassthroughSubject<Int, Never>()

final class Receiver4 {
    // subscriptionを格納する箱
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        subject1
            .sink { value in
                print("ReceivedValue[1]:", value)
            }
            .store(in: &subscriptions)
        subject2
            .sink { value in
                print("ReceivedValue[2]", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver4 = Receiver4()
subject1.send("a")
subject2.send(1)
subject1.send("i")
subject2.send(2)

// 異なるSubscriptionを同じsubscriptionsとして格納することはOK


// イベントについて
//-> Combineで扱うイベントには値を渡すだけでなく、イベントの完了とエラーがある

// 例④: .finished

let subject3 = PassthroughSubject<String, Never>()


final class Receiver5 {
    private var subscription = Set<AnyCancellable>()
    
    init() {
        subject3
            .sink { completion in
                print("Received Completion:", completion)
            } receiveValue: { value in
                print("ReceivedValue:", value)
            }
            .store(in: &subscription)
    }

}

let receiver5 = Receiver5()
subject3.send("a")
subject3.send("i")
subject3.send(completion: .finished)
subject3.send("u")
// finishedはイベントの送受信の完了を示す


// 例⑤: .failure

enum MyError: Error {
    case failed
}

// genericsにMyError型を継承する
let subject4 = PassthroughSubject<String, MyError>()

final class Receiver6 {
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        subject4
            .sink { completion in
                print("ReceivedCompletion:", completion)
            } receiveValue: { value in
                print("ReceivedValue:", value)
            }
            .store(in: &subscriptions)
    }
}

let receiver6 = Receiver6()
subject4.send("a")
subject4.send("i")
subject4.send(completion: .failure(.failed))
subject4.send("u")

//.failureもイベントの送受信終了を意味する


