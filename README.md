![Made with love by PGS](https://cloud.githubusercontent.com/assets/16896355/25438562/3c14f0f2-2a9a-11e7-82f1-53f49a48393e.png)
# MessagesView

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://swift.org/)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

View for displaying messages similarly to iOS Messages system app. This view when deployed within your application will handle incoming and outgoing messages display.

While using this module you don't need to handle messages view on your own. You're getting complete solution easy to configure and customize to your needs. If you think you can have more customisation, please tell us what you think via addess below.

![Messages View](https://cloud.githubusercontent.com/assets/16896355/25438510/0b81e86e-2a9a-11e7-9981-df9030cda73d.png)


## Getting started

In order to start using this framework you need to:
1. Embed this framework
2. Style your view
3. Communicate with view via ViewController



### 1. Embedding framework


#### 1.1 Using Carthage
In Cartfile put
`github "PGSSoft/MessagesView"`

In project root directory say:
> carthage update --no-use-binaries --platform iOS

This will fetch the project and compile it to library form. When using carthage, you have two options:

### a) Standard carthage module

![embedding carthage framework](https://cloud.githubusercontent.com/assets/16896355/24654187/f16728c6-1938-11e7-806b-5ea14b4c7284.gif)

Using standard cathage module requires you to go to Carthage/Build folder within your project and drag it into _**Embedded Binaries**_ section int your project **General settings**.
This solution no 1. is pretty standard. Unfortunately it doesn't work with storyboard as we intended and you will not be able to customize MessagesView from storyboard directly. It will be working but have to be customized from code. Considering all conditions above we recommend _Embedding into your project_. 

### b) Embedding sources into your project

![embedding source project](https://cloud.githubusercontent.com/assets/16896355/24654176/e46736a2-1938-11e7-9425-c856cc9de166.gif)

to embed this project as source code you need to:
1. Go to folder `Carthage/Checkouts/MessagesView` and drag `MessagesView.scodeproj` into your own project.
2. In MessagesView project find `Products/MessagesView.framework` and drag it into  `Embedded Frameworks` section in your project general settings

*NOTE: To be able to track changes from storyboard at design time, you need to embed framework in non-standard way as described in 1b.*


### 2. Styling your View

Let's design!

1. Go to storyboard
2. Set up a `UIView` with constraints of your choice
3. Change owner class from `UIView` to `MessagesView`. Don't forget to change module name underneath too into `MessagesView`. Xcode will now recompile source code necessary to show rendered MessagesView in Storyboard. Completely rendered messages view will appear in storyboard in seconds!

Now you are free to style your messages view as you wish!

Example: 
- change messages background color
- change button label caption
- change button background color
- change button background image
![styling input field background and text field rounding](https://cloud.githubusercontent.com/assets/16896355/24654216/10f95768-1939-11e7-9163-79acc0753d62.gif)
You can find full list of customizable properties in the Wiki. This will be prepared soon.

### 3. Communicating with View via ViewController

Create example ViewController From example below. ViewController has to conform protocols `MessagesViewDataSource` and `MessagesViewDelegate`.

In order to communicate with MessagesView, your ViewController should contain:
- `MessagesViewDelegate` to take action when user taps a button
- `MessagesViewDataSource` to feed the view
- `IBOutlet MessagesView` to read information from view

##### Don't forget do connect MessagesView to its `MessagesViewDataSource` and `MessagesViewDelegate`!

#### 3.1 MessagesViewDelegate


```swift
public protocol MessagesViewDelegate {
    func didTapLeftButton()
    func didTapRightButton()
}
```

Your viewController need to implement actions taken after user taps left or right button

#### 3.2 MessagesViewDataSource

To feed view with intormation, your datasource have to provide two sets of information: *peers* and *messages*

```swift
public protocol MessagesViewDataSource {
    var messages : [MessagesViewChatMessage] {get}
    var peers : [MessagesViewPeer] {get}
}
```

As you can see objects that carry messages have to conform to `MessagesViewChatMessage` protocol and objects that carry peers have to conform to `MessagesViewPeer`protocol. These are listed below:

```swift
public protocol MessagesViewChatMessage {
    var text : String {get}
    var sender: MessagesViewPeer {get}
    var onRight : Bool {get}
}

public protocol MessagesViewPeer {
    var id : String {get}
}
```

In the demo app we created extension to ViewController class that makes it compliant to `MessagesViewDataSource` protocol. In this case the limitation was that extension cannot contain stored properties so we decided to provide information via computed variables only but you can do as you wish in your own project. You need only to have object which is `MessagesViewDataSource` compliant. This is how we dealt with it in demo app:

```swift
extension ViewController: MessagesViewDataSource {
    struct Peer: MessagesViewPeer {
        var id: String
    }
    
    struct Message: MessagesViewChatMessage {
        var text: String
        var sender: MessagesViewPeer
        var onRight: Bool
    }

    var peers: [MessagesViewPeer] {
        return TestData.peerNames.map{ Peer(id: $0) }
    }
    
    var messages: [MessagesViewChatMessage] {
        return TestData.exampleMessageText.enumerated().map { (index, element) in
            let peer = self.peers[index % peers.count]
            return Message(text: element, sender: peer, onRight: index%2 == 0)
        }
    }
}
```

In this example, we have converted on the fly our stored `TestData` information into *Messages* and *Peers*. No other class in the project have to be aware of `MessagesView`. Only `ViewController` is interested.

#### 3.3 Create IBOutlet messagesView

Create IBOutlet in standard way
![creating IBOutlet for messagesView](https://cloud.githubusercontent.com/assets/16896355/24657607/2cff52f6-1947-11e7-8840-a6c2bb3d44fb.gif)

Having your ViewController know about messagesView presence enables it to use view's public API.

#### 3.4 Connecting delegate and data source

In our example it is when ViewController loads:

```swift
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messagesView.delegate = self
        messagesView.dataSource = self
    }
```

#### 3.5 Custom behaviours

Additional behaviours that may be useful to you.

- hiding buttons
```swift
leftButton(show: Bool, animated: Bool)
rightButton(show: Bool, animated: Bool)
```

This way you can show or hide button. Animated or not - as you wish.

### Stay in touch
If you have any ideas how this project can be developed - do not hesitate to contact us at:

dkanak@pgs-soft.com

mgocal@pgs-soft.com

bdudar@pgs-soft.com

kszwaba@pgs-soft.com

You are now fully aware of MessagesView capabilities. Good luck!

### Contributing to development
When contributing to MessagesView you may need to run it from within another project. Embedding this framework as described in paragraph  1.1b will help you work on opened source of this project.

Made with love in PGS &#9829;

__Please Use develop branch and fork from there!__

### License ###
MIT License

Copyright (c) 2016 PGS Software SA

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
