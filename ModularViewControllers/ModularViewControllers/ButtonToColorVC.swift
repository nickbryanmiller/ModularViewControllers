//  Created by Nicholas Miller on 2/13/19.
//  Copyright © 2019 nickbryanmiller. All rights reserved.

import UIKit

class ButtonToColorVC: NMViewController<UIButton> {
	
	// MARK: - Variables
	
	private let colorName: String
	private let color: UIColor
	
	// MARK: - Initializers
	
	init(colorName: String, color: UIColor) {
		self.colorName = colorName
		self.color = color
		super.init()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Lifecycle
	
	override func loadCustomView() -> UIButton? {
		let button = UIButton(frame: .zero)
		button.setTitle("to color \(colorName)", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .black
		button.addTarget(self, action: #selector(moveToColorVC), for: .touchUpInside)
		return button
	}
	
	// MARK: - Actions
	
	@objc private func moveToColorVC() {
		let vc = NMViewController<UIView>()
		vc.view.backgroundColor = color
		navigationController?.pushViewController(vc, animated: true)
	}
}
