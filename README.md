ASDepthModal is mostly inspired by some CSS work from http://lab.hakim.se/avgrund/ (although it does not provide any blur).
It gives a sense of depth between the current fullscreen view and a modal popup view.

![](https://github.com/autresphere/ASDepthModal/raw/master/Screenshots/iPhone0.png)
![](https://github.com/autresphere/ASDepthModal/raw/master/Screenshots/iPhone1.png)

## Try it
Download the whole project and run it under xcode. You can choose either iPhone or iPad destination.
It supports all orientations change.

## Use it
Just copy ASDepthModalViewController.h and ASDepthModalViewController.m in your project and `#import "ASDepthModalViewController.h"` where you need it.

Once you have your popup view, it can be shown like that. 
``` objective-c
    [ASDepthModalViewController presentView:yourPopupView];
```

You can configure also the background color as well as how the popup view appears.

``` objective-c
    [ASDepthModalViewController presentView:yourPopupView withBackgroundColor:color popupAnimationStyle:style];
```
Three styles are available : no effect, grow effect or shrink effect. 
    
If you need to close the popup by code (you usually have a "close" button), just call
``` objective-c
    [ASDepthModalViewController dismiss];
```