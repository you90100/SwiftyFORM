// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import UIKit

open class OptionCell: UITableViewCell, SelectRowDelegate {
	let innerDidSelectOption: (Void) -> Void
	
	public init(model: OptionRowFormItem, didSelectOption: @escaping (Void) -> Void) {
		self.innerDidSelectOption = didSelectOption
		super.init(style: .default, reuseIdentifier: nil)
		loadWithModel(model)
	}
	
	public required init(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	open func loadWithModel(_ model: OptionRowFormItem) {
		textLabel?.text = model.title
		if model.selected {
			accessoryType = .checkmark
		} else {
			accessoryType = .none
		}
	}

	open func form_didSelectRow(_ indexPath: IndexPath, tableView: UITableView) {
		SwiftyFormLog("will invoke")
		accessoryType = .checkmark
		
		tableView.deselectRow(at: indexPath, animated: true)

		innerDidSelectOption()
		SwiftyFormLog("did invoke")
	}
}
