//  Created by Nicholas Miller on 2/13/19.
//  Copyright © 2019 nickbryanmiller. All rights reserved.

import UIKit

class MyCustomViewController: NMViewController<MyCustomRootView>, MyCustomRootViewDelegate {
	
	// MARK: - Variables
	
	let greenButtonVC = ButtonToColorVC(colorName: "Green", color: .green)
	let brownButtonVC = ButtonToColorVC(colorName: "Brown", color: .brown)
	
	// MARK: - Lifecycle
	
	override func loadCustomView() -> MyCustomRootView? {
		// Can use this for all the variations of the view.
		// The view itself can have a custom "Organizer" depending on version desired
		// that will do all the layout of the subviews
		let customView = MyCustomRootView()
		customView.delegate = self
		return customView
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add the vc's
		addChild(greenButtonVC, addRootViewBlock: dynamicView.addGreenButtonVCRootView(_:))
		addChild(brownButtonVC, addRootViewBlock: dynamicView.addBrownButtonVCRootView(_:))
	}
	
	// MARK: - CustomViewDelegate Methods
	
	func someDelegateMethodThatIsCommonToAllViewVariations() {
		print("hello")
	}
	
}
