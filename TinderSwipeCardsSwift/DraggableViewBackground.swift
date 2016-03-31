//
//  DraggableViewBackground.swift
//  TinderSwipeCardsSwift
//
//  Created by Gao Chao on 4/30/15.
//  Copyright (c) 2015 gcweb. All rights reserved.
//

import Foundation
import UIKit

class DraggableViewBackground: UIView, DraggableViewDelegate {
    var exampleCardLabels: [String]!
    var allCards: [DraggableView]!

    let MAX_BUFFER_SIZE = 5
    let CARD_HEIGHT: CGFloat = 400
    let CARD_WIDTH: CGFloat = 290

    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var checkButton: UIButton!
    var xButton: UIButton!
    var reloadButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        exampleCardLabels = ["first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "nineth", "tenth", "eleventh", "last"]
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        self.loadCards()
    }

    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.52, green: 0.33, blue: 0.95, alpha: 1)

        xButton = UIButton(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2 + 35, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        xButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        xButton.addTarget(self, action: #selector(DraggableViewBackground.swipeLeft), forControlEvents: UIControlEvents.TouchUpInside)
        
        reloadButton = UIButton(frame: CGRectMake(self.frame.size.width/2 - 25, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 60, 60))
        reloadButton.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        reloadButton.setImage(UIImage(named: "circular-arrow"), forState: UIControlState.Normal)
        reloadButton.addTarget(self, action: #selector(DraggableViewBackground.reloadCards), forControlEvents: UIControlEvents.TouchUpInside)
        reloadButton.layer.borderColor = UIColor.whiteColor().CGColor
        reloadButton.layer.borderWidth = 2.0
        reloadButton.layer.cornerRadius = 30

        checkButton = UIButton(frame: CGRectMake(self.frame.size.width/2 + CARD_WIDTH/2 - 85, self.frame.size.height/2 + CARD_HEIGHT/2 + 10, 59, 59))
        checkButton.setImage(UIImage(named: "checkButton"), forState: UIControlState.Normal)
        checkButton.addTarget(self, action: #selector(DraggableViewBackground.swipeRight), forControlEvents: UIControlEvents.TouchUpInside)

        self.addSubview(xButton)
        self.addSubview(checkButton)
        self.addSubview(reloadButton)
    }

    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        let pos = index < MAX_BUFFER_SIZE ? index : (MAX_BUFFER_SIZE - 1)
//        let cardView = CardView(frame: CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT))
//        cardView.label.text = exampleCardLabels[index]
        let draggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2 - (CGFloat(pos) * 10), CARD_WIDTH, CARD_HEIGHT))
        draggableView.information.text = exampleCardLabels[index]
        draggableView.delegate = self
        return draggableView
    }

    func loadCards() -> Void {
        if exampleCardLabels.count > 0 {
            let numLoadedCardsCap = exampleCardLabels.count > MAX_BUFFER_SIZE ? MAX_BUFFER_SIZE : exampleCardLabels.count
            for i in 0 ..< exampleCardLabels.count {
                let newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }

            for i in 0 ..< loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i - 1])
                } else {
                    self.addSubview(loadedCards[i])
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }

    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        for i in 0 ..< loadedCards.count {
            let card = loadedCards[i];
            UIView.animateWithDuration(0.2, animations: {
                card.frame = CGRectOffset(card.frame, 0, 10);
            })
        }
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            let card = loadedCards[MAX_BUFFER_SIZE - 1], earlierCard = loadedCards[MAX_BUFFER_SIZE - 2]
            let originalFrame = card.frame
            card.frame = CGRectOffset(originalFrame, 0, -1 * (self.frame.size.height + CARD_HEIGHT)/2)
            self.insertSubview(card, belowSubview: earlierCard)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
                card.frame = originalFrame
                }, completion: { (foo) in
                    
            })
        }
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        for i in 0 ..< loadedCards.count {
            let card = loadedCards[i];
            UIView.animateWithDuration(0.2, animations: {
                card.frame = CGRectOffset(card.frame, 0, 10);
            })
        }
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex = cardsLoadedIndex + 1
            let card = loadedCards[MAX_BUFFER_SIZE - 1], earlierCard = loadedCards[MAX_BUFFER_SIZE - 2]
            let originalFrame = card.frame
            card.frame = CGRectOffset(originalFrame, 0, -1 * (self.frame.size.height + CARD_HEIGHT)/2)
            card.alpha = 0.5
            self.insertSubview(card, belowSubview: earlierCard)
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {
                card.frame = originalFrame
                card.alpha = 1.0
                }, completion: { (foo) in
                    
            })
        }
    }

    func reloadCards() {
        for i in 0 ..< loadedCards.count {
            loadedCards[i].removeFromSuperview()
        }
        allCards = []
        loadedCards = []
        cardsLoadedIndex = 0
        self.loadCards()
    }
    
    func swipeRight() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }

    func swipeLeft() -> Void {
        if loadedCards.count <= 0 {
            return
        }
        let dragView: DraggableView = loadedCards[0]
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
}