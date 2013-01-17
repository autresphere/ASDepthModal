## ASDepthModal
ASDepthModal is mostly inspired by a nice CSS work from http://lab.hakim.se/avgrund/ (although ASDepthModal does not provide any blur effect).

It gives a sense of depth between the current fullscreen view which is sent backward and a modal popup view which appears in front.

Works on iOS 5 and 6.

![](https://github.com/autresphere/ASDepthModal/raw/master/Screenshots/iPhoneVideo.gif)

## Try it
Download the whole project and run it under Xcode. You can choose either iPhone or iPad destination.
It supports all orientations change.

## Use it
Just copy ASDepthModalViewController.h and ASDepthModalViewController.m in your project and `#import "ASDepthModalViewController.h"` where you need it.

### Show
Once you have your popup view, here is how you would present it
``` objective-c
[ASDepthModalViewController presentView:yourPopupView];
```
    
### Hide
The popup view is automatically closed as soon as you tap outside of it.

If you need to close the popup view by code (you usually have a "close" button for this purpose)
``` objective-c
[ASDepthModalViewController dismiss];
```

### Configure
You can configure the background color as well as the effect applied on the popup when it appears ans disappears.

``` objective-c
[ASDepthModalViewController presentView:yourPopupView withBackgroundColor:color popupAnimationStyle:style];
```
Three styles are available : no effect, grow effect or shrink effect.

## ARC Support
This class requires ARC.
