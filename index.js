'use strict';

import React from 'react-native';

let RCTWeChat = React.NativeModules.WeChat;

function isFunction(fn) {
	return typeof fn === 'function';
}

function safeCallback(callback) {
	return isFunction(callback) ? callback : function() {};
}

export default {
	registerApp(appid, appdesc, callback) {
		if (isFunction(appdesc)) {
			callback = appdesc;
			appdesc = null;
		}

		if (!isFunction(callback)) {
			callback = function() {};
		}

		if (!appdesc) {
			RCTWeChat.registerApp(appid, callback);
		} else {
			RCTWeChat.registerAppWithDesc(appid, appdesc, callback);
		}
	},

	isWXAppInstalled(callback) {
		RCTWeChat.isWXAppInstalled(safeCallback(callback));
	},

    getWXAppInstallUrl(callback) {
        RCTWeChat.getWXAppInstallUrl(safeCallback(callback));
    },

    isWXAppSupportApi(callback) {
        RCTWeChat.isWXAppSupportApi(safeCallback(callback));
    },

    getApiVersion(callback) {
        RCTWeChat.getApiVersion(safeCallback(callback));
    },

    openWXApp(callback) {
        RCTWeChat.openWXApp(safeCallback(callback));
    },

    sendAuthReq(scope, state, callback) {
        RCTWeChat.sendAuthReq(scope, state, safeCallback(callback));
    },
    weChatPay(dict,callback) {
			RCTWeChat.wechatPay(dict,safeCallback(callback));
	},
    /**
     * [sendLinkURL 向微信发送链接内容]
     * @param scene 0:聊天界面 1:朋友圈 2:收藏
     */
    sendLinkURL(options, callback) {
    	RCTWeChat.sendLinkURL(
			options.link,
		    options.tagName,
		    options.title,
		    options.desc,
		    options.thumbImage,
		    options.scene,
		    safeCallback(callback)
		);
	},

		/**
		 * [sendImage 本地图片分享]
		 * @param scene 0:聊天界面 1:朋友圈 2:收藏
		 */
		sendImage(options, callback){
				RCTWeChat.sendImage(
					options.path,
					options.tagName,
					options.title,
					options.desc,
					options.scene,
					safeCallback(callback)
				);
			}
};
