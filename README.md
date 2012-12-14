ScreenCapture is a little tool written in AppleScriptObjC.

I have written it a while ago. But it seems that it compiles in Xcode 4.5.2 without problems.

The tool itself is a screencapture utility. It is possible to define a region of the screen to capture.
The amount of pages to capture and the click position so it is possible to click automaticaly thru what 
ever you want and make screenshots of it.
All the screenshot are saved into a specified folder with ascending filenames.

As mentioned above it is written in AppleScriptObjC and maybe you can learn something of the source code.
The screenshot itself is made over a do shell script with the screencapture terminal tool, image cropping
is done with an NSImage object and written to file over a NSBitmapImageRep object.

The gui uses a lot of bindings of the Interface Builder between code and gui elements.