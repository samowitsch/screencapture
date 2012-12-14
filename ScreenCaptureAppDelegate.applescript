--
--  ScreenCaptureAppDelegate.applescript
--  ScreenCapture
--
--  Created by Christian Sonntag on 12.11.10.
--  Copyright 2010 __MyCompanyName__. All rights reserved.
--
property NSImage : class "NSImage" of current application
property NSBitmapImageRep : class "NSBitmapImageRep" of current application
--property NSCompositeSourceOver : 2

--custom ObjectiveC class
property MyNSEvent : class "MyNSEvent"

script ScreenCaptureAppDelegate
	property parent : class "NSObject"
	property pNotificationCenter : class "NSNotificationCenter" of current application
	property myScreen : class "NSScreen" of current application
	property myEvent : class "NSEvent" of current application
	
	
	--outlets
	property theWindow : missing value
	property thePanel : missing value
	property frompage : missing value
	property pages : missing value
	property filepath : missing value
	property _top : missing value
	property _left : missing value
	property _width : missing value
	property _height : missing value
	property clickpositionx : missing value
	property clickpositiony : missing value
	
	property srcView : missing value
	property destView : missing value
	
	--misc
	property thepath : missing value
	property imageWidth : missing value
	property imageHeight : missing value
	
	on applicationWillFinishLaunching_(aNotification)
		-- Insert code here to initialize your application before any files are opened 
		
		tell current application's class "NSNotificationCenter"
			its defaultCenter's addObserver_selector_name_object_(me, "windowChanged:", "NSWindowDidResizeNotification", missing value)
			its defaultCenter's addObserver_selector_name_object_(me, "windowChanged:", "NSWindowDidMoveNotification", missing value)
		end tell
		
		
	end applicationWillFinishLaunching_
	
	on applicationShouldTerminate_(sender)
		-- Insert code here to do any housekeeping before your application quits 
		return current application's NSTerminateNow
	end applicationShouldTerminate_
	
	
	on doSomeThing_(sender)
		
		repeat with i from frompage's stringValue() to pages's stringValue() as integer
			theWindow's displayIfNeeded()
			set p to i
			if (i is greater than 9) and (i is less than 100) then
				set p to "0" & i
			else if i is less than 10 then
				set p to "00" & i
			end if
			
			tell application "Safari"
				activate
			end tell
			
			--screencapture
			set picPath to ((POSIX path of thepath) & "/Picture_" & p & ".png") as string
			do shell script "screencapture " & quoted form of picPath
			delay 1
			
			--klick ausführen
			MyNSEvent's clickAtLocation_({x:clickpositionx's stringValue() as string as integer, y:clickpositiony's stringValue() as string as integer})
			
			--Cocoa crop
			set srcImage to NSImage's alloc()'s initWithContentsOfFile_(picPath)
			srcView's setImage_(srcImage)
			
			set w to _width's stringValue() as string as number
			set h to _height's stringValue() as string as number
			set t to _top's stringValue() as string as number
			set l to _left's stringValue() as string as number
			
			set destImage to NSImage's alloc()'s initWithSize_({|width|:w, height:h})
			
			set destRect to {|size|:{w, h}, origin:{0, 0}}
			set srcRect to {|size|:{w, h}, origin:{l, t}}
			
			destImage's lockFocus()
			srcImage's drawInRect_fromRect_operation_fraction_(destRect, srcRect, current application's NSCompositeSourceOver, 1.0)
			destImage's unlockFocus()
			
			destView's setImage_(destImage)
			
			--save as png
			set theData to destImage's TIFFRepresentation()
			set myNsBitmapImageRepObj to NSBitmapImageRep's imageRepWithData_(theData)
			set myNewImageData to (myNsBitmapImageRepObj's representationUsingType_properties_(current application's NSPNGFileType, missing value))
			if not (myNewImageData's writeToFile_atomically_(picPath, true)) as boolean then
				set messageText to "There was an error writing to file"
				display dialog messageText buttons {"Ok"}
			end if
			
			delay 3
			
		end repeat
		beep
	end doSomeThing_
	
	
	on panelOpen_(sender)
		--fenster anzeigen
		thePanel's makeKeyAndOrderFront_(me)
	end panelOpen_
	
	on closePanel_(sender)
		--fenster ausblenden
		thePanel's orderOut_(me)
		--bounds des fensters auslesen
		my setCropValues()
	end closePanel_
	
	
	on windowChanged_(notification)
		set x to object of item 1 of (notification as list)
		--nur bei Cropassistent werte aktualisieren
		if (x's title as string) is "Cropassistent" then
			--bounds des fensters auslesen
			my setCropValues()
		end if
	end windowChanged_
	
	on setCropValues()
		--bounds des fensters auslesen
		set rect to thePanel's frame as list
		set {x, y} to origin of item 1 of rect as list
		set {w, h} to |size| of item 1 of rect as list
		
		_top's setStringValue_(y)
		_left's setStringValue_(x)
		_width's setStringValue_(w)
		_height's setStringValue_(h)
	end setCropValues
	
	on mouseLocationButton_(sender)
		
		--mouse position
		set mouseloc to myEvent's mouseLocation as list
		set {mox, moy} to {x of item 1 of mouseloc, y of item 1 of mouseloc}
		
		--screen resolution
		set screen to item 1 of myScreen's screens
		set res to screen's frame as list
		set {screenw, screenh} to {|width| of |size| of item 1 of res, height of |size| of item 1 of res}
		
		--update textfields
		clickpositionx's setStringValue_(mox)
		clickpositiony's setStringValue_(screenh - moy)
	end mouseLocationButton_
	
	on getPath_(sender)
		set thepath to text 1 thru -2 of ((choose folder with prompt "Choose the default folder location." with showing package contents) as alias as string) --Prevent an extra / on the end.
		filepath's |setURL_|(POSIX path of thepath)
		
		set thepath to POSIX path of thepath
		
	end getPath_
end script