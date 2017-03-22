# MessagesView
View for displaying messages similarly to iOS Messages system app

### Using Carthage
In Cartfile put
`github "pgs-dkanak/MessagesView"`

### Contributing development
When contributing to MessagesView you may need to run it from within another project. Following steps will help you setting your own project to use MessagesView as external framework:

1. Clone this repository
2. Launch test build
3. In **Build Phases** add _**Run Script - copy framework to project folder**_ with script text 

`cp -rf ${BUILD_DIR}/${CONFIGURATION}${EFFECTIVE_PLATFORM_NAME}/MessagesView.framework ${SRCROOT}`


4. _MessagesView.framework_ will be copied directly into _MessagesView project root directory_.
5. Link it into project you're actually working on.
6. In **Build Settings** update **Framework Search Paths** and add path to framework. By default it will be MessagesView project root directory.

__Please Use develop branch!__
