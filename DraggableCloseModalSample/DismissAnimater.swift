//
//  DismissAnimater.swift
//  DraggableCloseModalSample
//
//  Created by Tomoya Hayakawa on 2017/10/19.
//  Copyright © 2017年 TomoyaHayakawa. All rights reserved.
//

import UIKit

class DismissAnimater: NSObject {
}

extension DismissAnimater: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 1. 遷移元・遷移先のViewControllerを取得
        guard let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
            else { return }

        // 2. 遷移中に表示するContainerを取得する（遷移元のViewControllerが入っている）
        let containerView = transitionContext.containerView

        // 3. 遷移元のViewControllerの下に遷移先のViewControllerを挿入
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

        // 4. 遷移元ViewControllerの遷移終了時のframeをアニメーションをつけて設定する
        let screenBounds = UIScreen.main.bounds
        let finalOrigin = CGPoint(x: 0, y: screenBounds.height)
//        let finalOrigin = CGPoint(x: -screenBounds.width, y: 0)
        let finalFrameOfFromVC = CGRect(origin: finalOrigin, size: screenBounds.size)

        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFrameOfFromVC
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
