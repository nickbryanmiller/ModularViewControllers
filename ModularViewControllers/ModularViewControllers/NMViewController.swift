//  Created by Nicholas Miller on 2/13/19.
//  Copyright © 2019 nickbryanmiller. All rights reserved.

import UIKit

/*
Thoughts & Concerns

default declaration to UIView so that people can just do SubclassViewController: NMViewController
instead of SubclassViewController: NMViewController<UIView>

allow only subclasses to use dynamicView to avoid developers breaking demeter
(it would also be great if could get Xcode to let you recast "view")
*/

class NMViewController<ViewType: UIView>: UIViewController {
	
	// MARK: - Variables
	
	// the view casted as the type of custom view the developer has defined
	var dynamicView: ViewType! {
		return view as? ViewType
	}

	// MARK: - Initializers
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	// remove access to this so that subclasses don't need to implement
	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// clean up child ViewControllers so that there are no memory leaks
	deinit {
		removeChildren()
	}
	
	// MARK: - Lifecycle
	
	// remove access to loadView so that there is no confusion on how to load a custom view
	@available(*, unavailable)
	override func loadView() {
		guard let customView = loadCustomView() else {
			super.loadView()
			return
		}
		view = customView
	}
	
	// replaces the loadView method so that there is only one way to make a custom root view
	func loadCustomView() -> ViewType? {
		return nil
	}
	
	// MARK: - Adding Child ViewControllers
	
	// replaces the addChild method so that there is only one way to add a child ViewController
	func addChild<SubViewType>(
		_ child: NMViewController<SubViewType>,
		addRootViewBlock: @escaping ((SubViewType) -> Void))
	{
		super.addChild(child)
		addRootViewBlock(child.dynamicView)
		child.didMove(toParent: self)
	}
	
	// remove access to default addChild so that there is only one way to add a child ViewController
	@available(*, unavailable)
	override func addChild(_ childController: UIViewController) {
		super.addChild(childController)
	}
	
	// MARK: - Removing Child ViewControllers
	
	// helper method to create a way to remove a child ViewController
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
	
	// helper method to remove all child ViewControllers
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
	
	// made private so that the developer can only remove child ViewControllers from the top downward
	private func removeFromParent(willRemoveRootViewBlock: ((UIView) -> Void)? = nil) {
		// remove child vc's if applicable
		removeChildren()
		
		// do the rest of the process
		willMove(toParent: nil)
		willRemoveRootViewBlock?(view)
		view.removeFromSuperview()
		super.removeFromParent()
	}
	
	// remove access to removeParent so that there is only one way to remove child ViewControllers
	@available(*, unavailable)
	override func removeFromParent() {
		super.removeFromParent()
	}

}

