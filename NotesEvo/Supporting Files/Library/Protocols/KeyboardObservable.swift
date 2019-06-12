//
//  KeyboardObservable.swift
//  NotesEvo
//
//  Created by Andrew Boychuk on 6/12/19.
//  Copyright © 2019 Andrew Boychuk. All rights reserved.
//

import UIKit

protocol KeyboardObservable {
    func subscribeForKeyboardWillShowNotification(completion: ((CGRect, Double) -> ())?)
    func subscribeForKeyboardWillHideNotification(completion: ((Double) -> ())?)
    func unsubscribeForKeyboardNotifications()
}

extension KeyboardObservable {
    
    func subscribeForKeyboardWillShowNotification(completion: ((CGRect, Double) -> ())? = nil) {
        NotificationCenter.default.addObserver(forName: UIWindow.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            guard let info = notification.userInfo else { return }
            guard let keyBoardSize = (info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else { return }
            guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            completion?(keyBoardSize, animationDuration)
        }
    }
    
    func subscribeForKeyboardWillHideNotification(completion: ((Double) -> ())? = nil) {
        NotificationCenter.default.addObserver(forName: UIWindow.keyboardDidShowNotification, object: nil, queue: .main) { notification in
            guard let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            completion?(animationDuration)
        }
    }
    
    func unsubscribeForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
