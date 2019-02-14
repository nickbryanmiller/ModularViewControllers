//  Created by Nicholas Miller on 2/13/19.
//  Copyright © 2019 nickbryanmiller. All rights reserved.

import UIKit

// Makes swapping views easy
protocol MyCustomRootViewDelegate: class {
	func someDelegateMethodThatIsCommonToAllViewVariations()
}

class MyCustomRootView: UIView {
	
	// MARK: - Variables
	
	weak var delegate: MyCustomRootViewDelegate? = nil
	private let button = UIButton(frame: .zero)
	
	// MARK: - Initializers
	
	init() {
		super.init(frame: .zero)
		setUpViews()
		setUpConstraints()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	// MARK: - Custom View Adding Methods
	
	func addGreenButtonVCRootView(_ view: UIView) {
		view.frame = CGRect(x: 50, y: 75, width: 150, height: 50)
		addSubview(view)
	}
	
	func addBrownButtonVCRootView(_ view: UIView) {
		view.frame = CGRect(x: 50, y: 175, width: 150, height: 50)
		addSubview(view)
	}
	
	// MARK: - Actions
	
	@objc private func didTapButton() {
		delegate?.someDelegateMethodThatIsCommonToAllViewVariations()
	}
	
	// MARK: - SetUp and Constraint Methods
	
	private func setUpViews() {
		backgroundColor = .red
		
		button.translatesAutoresizingMaskIntoConstraints = false
		button.setTitle("hello", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.backgroundColor = .black
		button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
		addSubview(button)
	}
	
	private func setUpConstraints() {
		button.widthAnchor.constraint(equalToConstant: 100).isActive = true
		button.heightAnchor.constraint(equalToConstant: 50).isActive = true
		button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true
		button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
	}
	
}
