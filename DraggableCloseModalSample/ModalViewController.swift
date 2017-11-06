//
//  ModalViewController.swift
//  DraggableCloseModalSample
//
//  Created by Tomoya Hayakawa on 2017/10/19.
//  Copyright © 2017年 TomoyaHayakawa. All rights reserved.
//

import UIKit

class ModelViewController: UIViewController {

    let button = UIButton()
    let panGesture = UIPanGestureRecognizer()
    let pushTransitionAnimator = PushTransitionAnimator()

    init() {
        super.init(nibName: nil, bundle: nil)
        let interactor = PushTransitionInteractor(viewController: self)
//        interacter.addPanGesture()
//        interacter.addScreenEdgePanGesture()
        pushTransitionAnimator.interactor = interactor
        transitioningDelegate = pushTransitionAnimator
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        pushTransitionAnimator.interactor?.addScreenEdgePanGesture()
//        pushTransitionAnimator.interactor?.addPanGesture()

        setupButton()
    }

    func setupButton() {
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            ])
    }

    @objc func didTapButton(sender: UIButton) {
        dismiss(animated: true)
    }
}
