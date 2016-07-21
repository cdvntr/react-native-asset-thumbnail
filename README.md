# react-native-asset-thumbnail [![npm version](https://badge.fury.io/js/react-native-asset-thumbnail.svg)](http://badge.fury.io/js/react-native-asset-thumbnail)
Native module for generating thumbnails with asset uri (IOS Only)

*NOTE: This module was built when we weren't able to show video thumbnails which we fetched from the cameraRoll, and with the asset uri returned from the great [react-native-camera](https://github.com/lwansbrough/react-native-camera) module when we recorderd videos.

### Installation

1. `npm install react-native-asset-thumbnail --save`
2. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
3. Go to `node_modules` ➜ `react-native-asset-thumbnail` and add `RNAssetThumbnail.xcodeproj`
4. In XCode, in the project navigator, select your project. Add `libRNAssetThumbnail.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
5. Run your project (`Cmd+R`)

## Usage

```javascript
import React, {Component} from 'react';
import {
  AppRegistry,
  StyleSheet,
  View,
  ScrollView,
  Image,
  CameraRoll
} from 'react-native';
import RNAssetThumbnail from  'react-native-asset-thumbnail';

class Example extends Component {

  constructor(props, context, ...args) {
    super(props, context, ...args);
    this.state = {thumbnails: []};
  }

  componentDidMount() {
    let promiseArr = [];

    CameraRoll.getPhotos({assetType: 'Videos', first: 10}).then((data) => {
      assets = data.edges;
      assets.map((asset, index) => { 
        let media = asset.node.image;
        promiseArr.push(RNAssetThumbnail.generateThumbnail(media.uri, 70, 70));
      });
      Promise.all(promiseArr).then(thumbnails => { 
        this.setState({thumbnails});
      });
    });
  }

  renderThumbnails(thumbnail, index) {
    return <Image key={index} style={styles.imageStyle} source={{uri:thumbnail}}/>
  }

  render() {
    let {thumbnails} = this.state;
    return (
      <ScrollView style={styles.container}>
        {thumbnails.map(this.renderThumbnails.bind(this))}
      </ScrollView>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    paddingTop: 35,
    paddingHorizontal: 20,
    backgroundColor: '#F5FCFF',
  },
  imageStyle: {
    width: 70,
    height: 70,
    marginTop: 10,
    backgroundColor: 'gray'
  }
});

AppRegistry.registerComponent('Example', () => Example);
```
