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
    }
};








