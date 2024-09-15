import UIKit
import Combine

///備忘錄模式
///每次儲存當前狀態進行，因此可以反覆調用
enum CardAction: Equatable, Codable {
    case add(Card)
    case renewCards([Card])
    case remove(Int)
    case update(index: Int, newTimeSlot: String)
}

///假設現在我們有一種資料結構，叫做Card
struct Card: Equatable, Codable {
    let cardID: String
    let userName: String
    let block: Bool
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.cardID == rhs.cardID
    }
}

///封裝資料
struct CardState: Codable {
    var cards: [Card]
    var blockedCard: [Card]
}

class CardMeMento {
    private var state: CardState
    private var previousAction: CardAction?
    
    init(state: CardState) {
        self.state = state
    }
    
    func getCards() -> [Card]{
        return state.cards
    }
    
    func renewCards(cards: [Card]) {
        state.cards = cards
    }
    
    func saveState(action: CardAction) {
        previousAction = action
    }
    
    func restorePreviousAction() {
        guard let action = previousAction else { return }
        switch action {
        case .add(let card):
            print("Add")
        case .remove(let int):
            print("Remove")
        case .update(let index, let newTimeSlot):
            print("Update")
        case .renewCards(_):
            print("Renew")
        }
        
        previousAction = nil
    }
}

class ChatManager {
    var currentState: [Card] = []
    
    var roomState: CardState = CardState(cards: [], blockedCard: [])
    
    var memeto: CardMeMento = CardMeMento(state: CardState(cards: [], blockedCard: []))
    
    ///假裝添加動作
    func add() {
        currentState = memeto.getCards()
    }
    
    /// 清空並ReloadData
    func loadAPI() {
        let newCards: [Card] = []
        memeto.saveState(action: .renewCards(newCards))
        memeto.renewCards(cards: newCards)
    }
}
