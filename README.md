# react-native-wechat-ios
微信第三方登录功能集成示例，之后将陆续包装其他功能。

## 安装
```
$ npm i react-native-wechat-ios
```

## 链接库文件到你的项目中
参考 https://facebook.github.io/react-native/docs/linking-libraries-ios.html#content

## 如何使用

###1. 重写AppDelegate的handleOpenURL和openURL方法：

需要导入`RCTWeChatIOS.h`
```objective-c
#import "RCTWeChatIOS.h"
```

```objective-c
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
  return [[RCTWeChat2 shareInstance] handleOpenURL: url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  
  return [[RCTWeChat2 shareInstance] handleOpenURL: url];
  
}

```

###2. 订阅`finishedAuth`事件获取授权结果
授权成功后由Native端触发该事件，通知React Native端。

```javascript
import {DeviceEventEmitter} from 'react-native';

DeviceEventEmitter.addListener(
  'finishedAuth',
  (response) => AlertIOS.alert(JSON.stringify(response))
);

```
######返回值(response):
* `response.code`
* `response.state`
* `response.errCode`

###3. 发起授权
```javascript
import WeChatIOS from 'react-native-wechat-ios';

let state = 1311231; 
WeChatIOS.sendAuthRequest(state, (res) => {
});
```

### 已完成的方法
- registerApp 向微信注册应用ID
```javascript
// 向微信注册应用ID
WeChatIOS.registerApp('你的微信应用ID', (res) => {
    alert(res); // true or false
});
```
- isWXAppInstalled 检测是否已经安装微信客户端
```javascript
WeChatIOS.isWXAppInstalled((res) => {
    alert('isWXAppInstalled: '+res); // true or false
});
```
- sendAuthRequest 发起授权请求
```javascript
let state = 1311231; 
WeChatIOS.sendAuthRequest(state, (res) => {
});
```





