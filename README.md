# MessagesView
View for displaying messages similarly to iOS Messages system app. This view when deployed within your application will handle incoming and outgoing messages display.

While using this module you don't need to handle messages view on your own. You're getting complete solution easy to configure and customize to your needs. If you think you can have more customisation, please tell us what you think via addess below.


## Getting started

In order to start using this framework you need to:
1. Embed this framework into your project using carthage
2. Create example ViewController From example below. ViewController has to conform protocols `MessagesViewDataSource` and `MessagesViewDelegate`.

### 1. Embedding framework


#### 1.1 Using Carthage
In Cartfile put
`github "pgs-dkanak/MessagesView"`

In project root directory say:
> carthage update --no-use-binaries --platform iOS

This will fetch the project and compile it to library form. When using carthage, you have two options:
1. Use as you would use standard carthage module
2. Embedding sources into your project

### a) Standard carthage module

Using standard cathage module requires you to go to Carthage/Build folder within your project and drag it into _**Embedded Binaries**_ section int your project **General settings**.
This solution no 1. is pretty standard. Unfortunately it doesn't work with storyboard as we intended and you will not be able to customize MessagesView from storyboard directly. It will be working but have to be customized from code. Considering all conditions above we recommend _Embedding into your project_. 

### b) Embedding sources into your project

to embed this project as source code you need to:
1. Go to folder `Carthage/Checkouts/MessagesView` and drag `MessagesView.scodeproj` into your own project.
2. In MessagesView project find `Products/MessagesView.framework` and drag it into  `Embedded Frameworks` section in your project general settings

*NOTE: To be able to track changes from storyboard at design time, you need to embed framework in non-standard way as described in 1b.*


### 2. Using framework

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
You can find full list of customizable properties in the Wiki. This will be prepared soon.



### Contributing development
When contributing to MessagesView you may need to run it from within another project. Embedding this framework as described in paragraph  1.1b will help you work on opened source of this project.


__Please Use develop branch and fork from there!__
