# iStatusView

[![Version](https://img.shields.io/cocoapods/v/iStatusView.svg?style=flat)](http://cocoapods.org/pods/iStatusView)
[![License](https://img.shields.io/cocoapods/l/iStatusView.svg?style=flat)](http://cocoapods.org/pods/iStatusView)
[![Platform](https://img.shields.io/cocoapods/p/iStatusView.svg?style=flat)](http://cocoapods.org/pods/iStatusView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

iStatusView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'iStatusView'
```

![Loading Screen Shot](/images/loading.png)
![Error Screen Shot](/images/error.png)

## Integration

### Step 1: Style the StatusView, using appearance proxy
```
StatusView.appearance().titleLabelTextColor = UIColor.black
StatusView.appearance().titleLabelFont = UIFont.boldSystemFont(ofSize: 18)

StatusView.appearance().messageLabelTextColor = UIColor(white: 0.2, alpha: 1.0)
StatusView.appearance().messageLabelFont = UIFont.systemFont(ofSize: 16)
StatusView.appearance().backgroundColor = UIColor.white
```

### Step 2: Construct a loading view to display

Feel free to add in any loading indicator you fancy

An example using the UIActivityIndicator
```
let loadingView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
loadingView.color = UIColor.black
loadingView.startAnimating()
loadingView.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
```

### Step 3: Create the StatusView

Use the convenient create function, you must pass a loading view (even if its just a blank UIView, else nothing will work)
```
self.statusView = StatusView.create(with: loadingView, addTo: self.view)
```

Set the size, in this case we are using SnapKit to set the AutoLayout constraints to fill the whole view.
Can also use AutoResizingMasks, StoryBoard or other declarative AutoLayout code  
```
self.statusView.snp.makeConstraints { (make) in
    make.edges.equalToSuperview()
}
```

### Step 4 (Optional): Listen to button presses.
A button appears when a button image is set when setting the state
Useful for a retry button, or cancel loading button
```
self.statusView.button.addTarget(self, action: #selector(statusViewButtonPressed), for: .touchUpInside)
```

### Step 5: Show a state
`state`: what state the status view is in. `loading` will show the loading indicator, `message` will hide the loading indicator, `hidden` will hide the whole status view.
`title`: optional; is the main title of the status.
`message`: optional; is the more detailed message to be displayed.
`statusImage`: optional; shows an image to be displayed
`buttonImage`: optional; when an image is set, it will show as a pressable button


```
try? self.statusView.changeTo(
        state: .loading,
        title: "Title of status",
        message: "More info on the status",
        statusImage: nil,
        buttonImage: nil,
        animate: false)
```

From here set the state to .hidden or to .message depending on the state of loading the content

## License

iStatusView is available under the Apache license. See the LICENSE file for more info.
