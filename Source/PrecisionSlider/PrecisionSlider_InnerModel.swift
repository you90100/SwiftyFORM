// MIT license. Copyright (c) 2016 SwiftyFORM. All rights reserved.
import Foundation

class PrecisionSlider_InnerModel: CustomDebugStringConvertible {
	var minimumValue: Double = 0.0
	var maximumValue: Double = 100.0
	
	var originalMaximumValue: Double = 0.0
	var originalMinimumValue: Double = 100.0
	
	var markers = 1
	
	func updateRange() {
		if scale > 800 {
			markers = 20
		} else {
			if scale > 250 {
				markers = 10
			} else {
				if scale > 100 {
					markers = 2
				} else {
					markers = 1
				}
			}
		}
		//		print("!!!!!!!! \(markers)  \(scale)")
		
		maximumValue = originalMaximumValue * Double(markers)
		minimumValue = originalMinimumValue * Double(markers)
		
		var count = Int(floor(maximumValue) - ceil(minimumValue)) + 1
		
		let sizeBefore = ceil(minimumValue) - minimumValue
		//print("size before: \(sizeBefore)    \(minimumValue)")
		if sizeBefore > 0.0000001 {
			//print("partial item before. size: \(sizeBefore)   minimumValue: \(minimumValue)")
			hasPartialItemBefore = true
			sizeOfPartialItemBefore = sizeBefore
			count -= 1
		} else {
			hasPartialItemBefore = false
			sizeOfPartialItemBefore = 0
		}
		
		let sizeAfter = maximumValue - floor(maximumValue)
		//print("size after: \(sizeAfter)    \(maximumValue)")
		if sizeAfter > 0.0000001 {
			//print("partial item after. size: \(sizeAfter)   minimumValue: \(maximumValue)")
			hasPartialItemAfter = true
			sizeOfPartialItemAfter = sizeAfter
			count -= 1
		} else {
			hasPartialItemAfter = false
			sizeOfPartialItemAfter = 0
		}
		
		// prevent negative number of items
		if count < 0 {
			// In this case use the "single_cell"
			//			print("maximumValue=\(maximumValue)  minimumValue=\(minimumValue)")
			numberOfFullItems = 0
			hasOnePartialItem = true
			sizeOfOnePartialItem = maximumValue - minimumValue
			hasPartialItemBefore = false
			sizeOfPartialItemBefore = 0
			hasPartialItemAfter = false
			sizeOfPartialItemAfter = 0
		} else {
			numberOfFullItems = count
			hasOnePartialItem = false
		}
		
		//		print("model: \(self)")
	}
	
	/*
	This is used when the range is tiny and doesn't cross any integer boundary.
	Example of such a range: from min=0.4 to max=0.6
	here the size of the range is 0.2, which is (max - min)
	*/
	var hasOnePartialItem = false
	var sizeOfOnePartialItem: Double = 0.0
	
	/*
	This is used when the range-start crosses an integer boundary.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a partial-item-before
	with the range from min=0.7 to max=1.0
	here the size of the range is 0.3  (max - min)
	*/
	var hasPartialItemBefore = false
	var sizeOfPartialItemBefore: Double = 0.0
	
	/*
	This is used when the range is crossing zero or more integer boundaries.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a full items will span from min=1.0 to max=3.0
	here the number of full items is 2  (max - min)
	The size of a full item is alway 1, since it's full.
	*/
	var numberOfFullItems = 100
	
	/*
	This is used when the range-end crosses an integer boundary.
	Example of such a range: from min=0.7 to max=3.3
	In this case there will be a partial-item-after
	with the range from min=3.0 to max=3.3
	here the size of the range is 0.3  (max - min)
	*/
	var hasPartialItemAfter = false
	var sizeOfPartialItemAfter: Double = 0.0
	
	var scale: Double = 60.0
	
	var lengthOfFullItem: Double {
		let result = ceil(scale / Double(markers))
		if result < 0.1 {
			return 0.1
		}
		return result
	}
	
	var lengthOfAllFullItems: Double {
		return Double(numberOfFullItems) * lengthOfFullItem
	}
	var lengthOfOnePartialItem: Double {
		return ceil(lengthOfFullItem * sizeOfOnePartialItem)
	}
	var lengthOfPartialItemBefore: Double {
		return ceil(lengthOfFullItem * sizeOfPartialItemBefore)
	}
	var remainingLengthOfPartialItemBefore: Double {
		return ceil(lengthOfFullItem * (1.0 - sizeOfPartialItemBefore))
	}
	var lengthOfPartialItemAfter: Double {
		return ceil(lengthOfFullItem * sizeOfPartialItemAfter)
	}
	var remainingLengthOfPartialItemAfter: Double {
		return ceil(lengthOfFullItem * (1.0 - sizeOfPartialItemAfter))
	}
	
	var lengthOfContent: Double {
		if hasOnePartialItem {
			return lengthOfOnePartialItem
		}
		var length: Double = 0
		if hasPartialItemBefore {
			length += lengthOfFullItem * 2
		}
		length += lengthOfAllFullItems
		if hasPartialItemAfter {
			length += lengthOfFullItem * 2
		}
		return length
	}
	
	static let height: CGFloat = 130
	
	
	func labelTextForIndexPath(indexPath: NSIndexPath) -> String? {
		var index = Int(floor(minimumValue)) + indexPath.row
		if hasPartialItemBefore {
			index += 1
		}
		if markers == 1 {
			let displayValue = index % 10
			return String(displayValue)
		}
		if markers == 2 {
			if index % 2 != 0 {
				return nil
			}
			let adjustedIndex = index / 2
			let displayValue = adjustedIndex % 10
			return String(displayValue)
		}
		if markers == 10 {
			if index % 10 != 0 {
				return nil
			}
			let adjustedIndex = index / 10
			let displayValue = adjustedIndex % 10
			return String(displayValue)
		}
		if markers == 20 {
			if index % 20 != 0 {
				return nil
			}
			let adjustedIndex = index / 20
			let displayValue = adjustedIndex % 10
			return String(displayValue)
		}
		return nil
	}
	
	func markColorForIndexPath(indexPath: NSIndexPath) -> UIColor? {
		var index = Int(floor(minimumValue)) + indexPath.row
		if hasPartialItemBefore {
			index += 1
		}
		if markers == 1 {
			return UIColor.blackColor()
		}
		if markers == 2 {
			if index % 2 == 0 {
				return UIColor.blackColor()
			} else {
				return UIColor(white: 0.7, alpha: 1.0)
			}
		}
		if markers == 10 {
			if index % 10 == 0 {
				return UIColor.blackColor()
			}
			if abs(index % 10) == 5 {
				return UIColor.blackColor()
			} else {
				return UIColor(white: 0.7, alpha: 1.0)
			}
		}
		if markers == 20 {
			if index % 2 == 0 {
				return UIColor.blackColor()
			} else {
				return UIColor(white: 0.7, alpha: 1.0)
			}
		}
		return nil
	}

	
	var debugDescription: String {
		var strings = [String]()
		strings.append("markers: \(markers)")
		strings.append(String(format: "scale: %.5f", scale))
		strings.append(String(format: "range: %.5f %.5f", minimumValue, maximumValue))
		if hasOnePartialItem {
			strings.append(String(format: "one-partial: %.5f", sizeOfOnePartialItem))
		}
		if hasPartialItemBefore {
			strings.append(String(format: "partial-before: %.5f", sizeOfPartialItemBefore))
		}
		strings.append("full: \(numberOfFullItems)")
		if hasPartialItemAfter {
			strings.append(String(format: "partial-after: %.5f", sizeOfPartialItemAfter))
		}
		return strings.joinWithSeparator(" , ")
	}
}
