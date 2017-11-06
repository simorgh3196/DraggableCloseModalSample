//
//  PushTransitionAnimator.swift
//  DraggableCloseModalSample
//
//  Created by Tomoya Hayakawa on 2017/10/19.
//  Copyright © 2017年 TomoyaHayakawa. All rights reserved.
//

import UIKit

class PushTransitionAnimator: NSObject {

    var interactor: PushTransitionInteractor?

    let pushTransitioning = PushTransitioning()
    let popTransitioning = PopTransitioning()
}

extension PushTransitionAnimator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return pushTransitioning
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return popTransitioning
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
}

// MARK: - Interactor

class PushTransitionInteractor: UIPercentDrivenInteractiveTransition {

    var percentThreshold: CGFloat
    weak var viewController: UIViewController?

    init(viewController: UIViewController, percentThreshold: CGFloat = 0.5) {
        self.viewController = viewController
        self.percentThreshold = percentThreshold
    }

    func addPanGesture() {
        viewController?.view.addGestureRecognizer(panGesture)
    }

    func addScreenEdgePanGesture() {
        viewController?.view.addGestureRecognizer(screenEdgePanGesture)
    }

    lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.maximumNumberOfTouches = 1
        gesture.delegate = self
        gesture.addTarget(self, action: #selector(handleGesture(gesture:)))
        return gesture
    }()

    lazy var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer()
        gesture.maximumNumberOfTouches = 1
        gesture.edges = .left
        gesture.delegate = self
        gesture.addTarget(self, action: #selector(handleGesture(gesture:)))
        return gesture
    }()

    override func cancel() {
        completionSpeed = percentComplete
        super.cancel()
    }

    override func finish() {
        completionSpeed = 1.0 - percentComplete
        super.finish()
    }

    @objc private func handleGesture(gesture: UIPanGestureRecognizer) {
        guard let viewController = viewController else { return }
        let transition = gesture.translation(in: viewController.view)
        let verticalMovement = transition.x / viewController.view.bounds.width
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)

        switch gesture.state {
        case .began:
            viewController.dismiss(animated: true)
        case .changed:
            update(progress)
        case .cancelled:
            cancel()
        case .ended:
            percentComplete > percentThreshold ? finish() : cancel()
        default:
            break
        }
    }
}

extension PushTransitionInteractor: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - PushTransitioning

class PushTransitioning: NSObject {

    let duration: TimeInterval
    let distance: CGFloat

    init(duration: TimeInterval = 0.4, distance: CGFloat = 70) {
        self.duration = duration
        self.distance = distance
    }
}

extension PushTransitioning: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else { return }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, aboveSubview: fromView)

        let finalFrameOfFromView = fromView.frame.offsetBy(dx: -distance, dy: 0)
        let startFrameOfToView = containerView.frame.offsetBy(dx: containerView.frame.width, dy: 0)
        let finalFrameOfToView = containerView.frame

        toView.frame = startFrameOfToView
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.05, options: .curveEaseInOut, animations: {
            fromView.frame = finalFrameOfFromView
            toView.frame = finalFrameOfToView
            fromView.alpha = 0.7
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}

// MARK: - PopTransitioning

class PopTransitioning: NSObject {

    let duration: TimeInterval
    let distance: CGFloat

    init(duration: TimeInterval = 0.4, distance: CGFloat = 70) {
        self.duration = duration
        self.distance = distance
    }
}

extension PopTransitioning: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromView = transitionContext.view(forKey: .from),
            let toView = transitionContext.view(forKey: .to)
            else { return }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView)

        let finalFrameOfFromView = containerView.frame.offsetBy(dx: containerView.frame.width, dy: 0)
        let startFrameOfToView = toView.frame
        let finalFrameOfToView = toView.frame.offsetBy(dx: distance, dy: 0)

        toView.frame = startFrameOfToView
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
            fromView.frame = finalFrameOfFromView
            toView.frame = finalFrameOfToView
            toView.alpha = 1.0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
