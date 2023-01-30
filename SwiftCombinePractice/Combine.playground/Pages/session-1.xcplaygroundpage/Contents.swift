// Combineとは
// -> オブジェクトからオブジェクトに※イベントを伝える仕組みを提供する
// ※イベント == ここでいうイベントとは※GUIの操作やネットワーク通信などApp内で発生した何かしらの変化を伝える

// 例①: 文字列の値を渡すイベント

import Combine

// 決して失敗しないことをNeverで表している
// イベントを送信するオブジェクト
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
