ASDepthModal is mostly inspired by some CSS work from http://lab.hakim.se/avgrund/ (although ASDepthModal does not provide any blur effect).

It gives a sense of depth between the current fullscreen view and a modal popup view.

![](https://github.com/autresphere/ASDepthModal/raw/master/Screenshots/iPhone1.png)

## Try it
Download the whole project and run it under xcode. You can choose either iPhone or iPad destination.
It supports all orientations change.

## Use it
Just copy ASDepthModalViewController.h and ASDepthModalViewController.m in your project and `#import "ASDepthModalViewController.h"` where you need it.

### Show
Once you have your popup view, here how you would present it. 
``` objective-c
[ASDepthModalViewController presentView:yourPopupView];
```

### Configure
You can also configure the background color as well as how the popup view appears.

``` objective-c
[ASDepthModalViewController presentView:yourPopupView withBackgroundColor:color popupAnimationStyle:style];
```
Three styles are available : no effect, grow effect or shrink effect. 
    
### Hide
If you need to close the popup by code (you usually have a "close" button for this purpose), just call
``` objective-c
[ASDepthModalViewController dismiss];
```