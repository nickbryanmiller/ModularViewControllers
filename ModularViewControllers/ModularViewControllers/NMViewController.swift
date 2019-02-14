//  Created by Nicholas Miller on 2/13/19.
//  Copyright © 2019 nickbryanmiller. All rights reserved.

import UIKit

/*
Thoughts & Concerns

1. default declaration to UIView so that people can just do SubclassViewController: NMViewController
instead of SubclassViewController: NMViewController<UIView>

2. allow only subclasses to use dynamicView to avoid developers breaking demeter
(it would also be great if could get Xcode to let you recast "view")

allow subclasses to not need to include "required init?(coder aDecoder: NSCoder)"

don't let other classes call "addChild(_ childController: UIViewController)"

Figuring out removing self / remove in custom deinit to avoid leaks
*/

class NMViewController<ViewType: UIView>: UIViewController {
	
	// MARK: - Variables
	
	var dynamicView: ViewType! {
		return view as? ViewType
	}

	// MARK: - Initializers
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	deinit {
		removeChildren()
	}
	
	// MARK: - Lifecycle
	
	@available(*, unavailable)
	override func loadView() {
		guard let customView = loadCustomView() else {
			super.loadView()
			return
		}
		view = customView
	}
	
	func loadCustomView() -> ViewType? {
		return nil
	}
	
	// MARK: - Adding Child ViewControllers
	
	func addChild<SubViewType>(
		_ child: NMViewController<SubViewType>,
		addRootViewBlock: @escaping ((SubViewType) -> Void))
	{
		super.addChild(child)
		addRootViewBlock(child.dynamicView)
		child.didMove(toParent: self)
	}
	
	@available(*, unavailable)
	override func addChild(_ childController: UIViewController) {
		super.addChild(childController)
	}
	
	// MARK: - Removing Child ViewControllers
	
	func removeChild<SubViewType>(
		_ child: NMViewController<SubViewType>,
		willRemoveRootViewBlock: ((SubViewType) -> Void)? = nil)
	{
		// remove child vc's if applicable
		child.removeChildren()
		
		// do the rest of the process
		child.removeFromParent(willRemoveRootViewBlock: { _ in
			willRemoveRootViewBlock?(child.dynamicView)
		})
	}
	
	func removeChildren() {
		children.forEach({ child in
			if let goodChild = child as? NMViewController<UIView> {
				goodChild.removeFromParent()
			} else {
				print("added a non NMViewController") // which should be impossible
			}
		})
	}
	
	// MARK: - Remove Self From Parent ViewController
	
	private func removeFromParent(willRemoveRootViewBlock: ((UIView) -> Void)? = nil) {
		// remove child vc's if applicable
		removeChildren()
		
		// do the rest of the process
		willMove(toParent: nil)
		willRemoveRootViewBlock?(view)
		view.removeFromSuperview()
		super.removeFromParent()
	}
	
	@available(*, unavailable)
	override func removeFromParent() {
		super.removeFromParent()
	}

}

