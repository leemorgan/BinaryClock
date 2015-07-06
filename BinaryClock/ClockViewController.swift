//
//  ClockViewController.swift
//  BinaryClock
//
//  Created by Lee Morgan on 7/5/15.
//  Copyright © 2015 Lee Morgan. All rights reserved.
//

import UIKit

class ClockViewController : UIViewController {
	
	@IBOutlet var hourColon : UILabel!
	@IBOutlet var minuteColon : UILabel!
	
	lazy var legendViews : [UIView] = {
		
		var views = [UIView]()
		
		for i in 200...209 {
			if let view = self.view.viewWithTag(i) {
				views.append(view)
			}
		}
		return views
	}()
	
	lazy var timeLabelViews : [UIView] = {
		
		var views = [UIView]()
		
		for i in 100...107 {
			if let view = self.view.viewWithTag(i) {
				views.append(view)
			}
		}
		return views
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		UIApplication.sharedApplication().idleTimerDisabled = true
		
		setVisibilityForViews(legendViews, visibility: true, animated: false)
		setVisibilityForViews(timeLabelViews, visibility: true, animated: false)
		
		setTimeToHours(0, minutes: 0, seconds: 0)
		
		NSTimer.scheduledTimerWithTimeInterval(1.0/1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
	}
	
	override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent?) {
		
		let legendVisible = legendViews[0].alpha == 1.0
		let timeLabelsVisible = timeLabelViews[0].alpha == 1.0
		
		switch (legendVisible, timeLabelsVisible) {
		case (false, false):
			setVisibilityForViews(timeLabelViews, visibility: false, animated: true)
		case (false, true):
			setVisibilityForViews(legendViews,    visibility: false, animated: true)
		case (true, true):
			setVisibilityForViews(timeLabelViews, visibility: true,  animated: true)
		case (true, false):
			setVisibilityForViews(legendViews,    visibility: true,  animated: true)
		default:
			break
		}
	}
	
	func setVisibilityForViews(views : [UIView], visibility: Bool, animated: Bool) {
		
		let setViewsVisibility:([UIView], Bool) -> Void = {
			views, hidden in
			for view in views {
				view.alpha = hidden ? 0.0 : 1.0
			}
		}
		
		if animated {
			UIView.animateWithDuration(0.33) {
				setViewsVisibility(views, visibility)
			}
		}
		else {
			setViewsVisibility(views, visibility)
		}
	}
	
	func ledForColumn(col : Int, row: Int) -> UIImageView {
		
		let tag = 1 + col + (row * 6)
		return self.view.viewWithTag(tag) as! UIImageView
	}
	
	func numberLabelForColumn(col: Int) -> UILabel {
		
		let tag = 100 + col
		return self.view.viewWithTag(tag) as! UILabel
	}
	
	func tick() {
		
		let now = NSDate()
		let calendar = NSCalendar.currentCalendar()
		let dateComponents = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: now)
		
		setTimeToHours(dateComponents.hour, minutes: dateComponents.minute, seconds: dateComponents.second)
	}
	
	func setTimeToHours(hours: Int, minutes: Int, seconds: Int) {
		
		setValue(hours / 10, forColumn: 0)
		setValue(hours % 10, forColumn: 1)
		
		setValue(minutes / 10, forColumn: 2)
		setValue(minutes % 10, forColumn: 3)
		
		setValue(seconds / 10, forColumn: 4)
		setValue(seconds % 10, forColumn: 5)
	}
	
	func setValue(value: Int, forColumn col: Int) {
		
		let onesState	= (value & 0b0001) == 0b0001
		let twosState	= (value & 0b0010) == 0b0010
		let foursState	= (value & 0b0100) == 0b0100
		let eightsState	= (value & 0b1000) == 0b1000
		
		setLEDon(onesState,		forColumn: col, row: 0)
		setLEDon(twosState,		forColumn: col, row: 1)
		setLEDon(foursState,	forColumn: col, row: 2)
		setLEDon(eightsState,	forColumn: col, row: 3)
		
		// Update the column's label
		numberLabelForColumn(col).text = "\(value)"
	}
	
	func setLEDon(on: Bool, forColumn col: Int, row: Int) {
		
		let ledView = ledForColumn(col, row: row)
		
		let imageName = on ? "ledOn" : "ledOff"
		
		ledView.image = UIImage(named: imageName)
	}
}
