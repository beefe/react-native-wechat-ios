# react-native-wechat-ios
微信第三方登录功能集成示例，之后将陆续包装其他功能。

## 如何安装

#### 1. 下载包文件
```
$ npm i react-native-wechat-ios
```

#### 2. 链接库文件到你的项目中
参考 https://facebook.github.io/react-native/docs/linking-libraries-ios.html#content

###### 给RCTWeChat添加头文件搜索路径：`$(SRCROOT)/../../react-native/React`，并选择`recursive`。

###### 因为需要在 AppDelegate.m 文件中导入 RCTWeChat.h，所以需要在你的项目中添加一个头文件搜索路径：
`$(SRCROOT)/../node_modules/react-native-wechat-ios/RCTWeChat`，并选择`recursive`。

###### 根据微信SDK要求需要添加以下库文件
  - [x] SystemConfiguration.framework	  
  - [x] libz.dylib
  - [x] libsqlite3.0.dylib
  - [x] libc++.dylib
  - [x] CoreTelephony.framework

> Xcode7 可能找不到*.dylib库，解决方法参考这里
http://www.jianshu.com/p/1f575e4d1033

## 如何使用

### 1. 重写AppDelegate的handleOpenURL和openURL方法：

需要导入`RCTWeChat.h`
```objective-c
#import "RCTWeChat.h"
```

```objective-c
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  return [[RCTWeChat shareInstance] handleOpenURL: url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  return [[RCTWeChat shareInstance] handleOpenURL: url];
  
}

```

### 2. 订阅`finishedAuth`事件获取授权结果
授权成功后由Native端触发该事件，通知React Native端。

```javascript
import {NativeAppEventEmitter} from 'react-native';

NativeAppEventEmitter.addListener(
  'finishedAuth',
  (response) => AlertIOS.alert(JSON.stringify(response))
);

```
###### 返回值(response):
* `response.code`
* `response.state`
* `response.errCode`

### 3. 发起授权
```javascript
import WeChat from 'react-native-wechat-ios';

let state = 1311231; 
WeChat.sendAuthRequest(state, (res) => {
});
```

## 已完成的方法
- registerApp 向微信注册应用ID
```javascript
// 向微信注册应用ID
WeChat.registerApp('你的微信应用ID', (res) => {
    alert(res); // true or false
});
```
- isWXAppInstalled 检测是否已经安装微信客户端
```javascript
WeChat.isWXAppInstalled((res) => {
    alert('isWXAppInstalled: '+res); // true or false
});
```
- sendAuthRequest 发起授权请求
```javascript
let state = 1311231; 
WeChat.sendAuthRequest(state, (res) => {
});
```

## Example 



