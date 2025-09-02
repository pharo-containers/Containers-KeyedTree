# Containers-KeyedTree
A hierarchical data structure that provides path-based access to nested elements with dictionary-like functionality. Perfect for configuration management, file system structures & hierarchical data organization.

![Pharo Version](https://img.shields.io/badge/Pharo-10+-blue)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## What is a KeyedTree?
A KeyedTree is a specialized dictionary that allows nested structures where values can be accessed through path-based keys. Each node can contain both direct values and subtrees, enabling hierarchical data organization similar to file systems or nested configurations.

## Loading 
The following script installs Containers-KeyedTree in Pharo.

```smalltalk
Metacello new
  baseline: 'ContainersKeyedTree';
  repository: 'github://pharo-containers/Containers-KeyedTree/src';
  load.
```

## If you want to depend on it 
Add the following code to your Metacello baseline or configuration:

```smalltalk
spec 
   baseline: 'ContainersKeyedTree' 
   with: [ spec repository: 'github://pharo-containers/Containers-KeyedTree/src' ].
```

## Why use Containers-KeyedTree?

KeyedTrees solve the problem of **organizing hierarchical data with efficient path-based access**. Perfect for configuration files, menu systems, and any data that naturally forms a tree structure.

### Key Benefits
- **Hierarchical Organization**: Natural tree structure for nested data
- **Path-based Access**: Access deep elements with simple path arrays
- **Flexible Values**: Store any object type at any level
- **Merge Capability**: Combine trees intelligently
- **Dictionary Compatibility**: Inherits from Dictionary for familiar API

## Basic Usage

```smalltalk
"Create a hierarchical structure"
tree := CTKeyedTree new.

"Add simple values"
tree at: #name put: 'MyApp'.
tree at: #version put: '1.0.0'.

"Create nested structures"
config := CTKeyedTree new.
config at: #host put: 'localhost'.
config at: #port put: 8080.
tree at: #server put: config.

"Access with paths"
tree atPath: #(server host). "=> 'localhost'"
tree atPath: #(server port). "=> 8080"
tree atPath: #(version).     "=> '1.0.0'"
```

## Real-World Use Cases

```smalltalk
"Build a hierarchical menu structure for GUI Applications"
mainMenu := CTKeyedTree new.

"File menu"
fileMenu := CTKeyedTree new
    at: #new put: 'Create New Document';
    at: #open put: 'Open Document';
    at: #recent put: (CTKeyedTree new
        at: #doc1 put: '/path/to/recent1.txt';
        at: #doc2 put: '/path/to/recent2.txt';
        yourself);
    at: #save put: 'Save Document';
    at: #exit put: 'Exit Application';
    yourself.

"Edit menu"
editMenu := CTKeyedTree new
    at: #undo put: 'Undo Last Action';
    at: #redo put: 'Redo Last Action';
    at: #copy put: 'Copy Selection';
    at: #paste put: 'Paste Content';
    yourself.

"Tools menu with nested submenus"
toolsMenu := CTKeyedTree new
    at: #preferences put: (CTKeyedTree new
        at: #general put: 'General Settings';
        at: #appearance put: 'Theme & UI';
        at: #shortcuts put: 'Keyboard Shortcuts';
        yourself);
    at: #plugins put: 'Manage Plugins';
    yourself.

mainMenu 
    at: #file put: fileMenu;
    at: #edit put: editMenu;
    at: #tools put: toolsMenu.

"Access menu items by path"
newAction := mainMenu atPath: #(file new).          "=> 'Create New Document'"
recentDoc := mainMenu atPath: #(file recent doc1).  "=> '/path/to/recent1.txt'"
themeSettings := mainMenu atPath: #(tools preferences appearance). "=> 'Theme & UI'"
```

## Contributing
This is part of the Pharo Containers project. Feel free to contribute by implementing additional methods, improving tests, or enhancing documentation.