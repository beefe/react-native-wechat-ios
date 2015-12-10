/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 */
'use strict';

import React from 'react-native';
import WeChat from 'react-native-wechat-ios';

let {
    View, Text, StyleSheet,
    AlertIOS, TouchableHighlight,
    NativeAppEventEmitter
} = React;


function show(title, msg) {
    AlertIOS.alert(title+'', msg+'');
}

class Example extends React.Component {
    componentDidMount() {
        this.registerApp();

        NativeAppEventEmitter.addListener(
          'finishedAuth',
          (response) => AlertIOS.alert(JSON.stringify(response))
        );
    }

    registerApp() {
        WeChat.registerApp('wxd930ea5d5a258f4f', (res) => {
            show('registerApp', res);
        });
    }

    isWXAppInstalled() {
        WeChat.isWXAppInstalled((res) => {
            show('isWXAppInstalled', res);
        });
    }

    sendAuthRequest() {
        let state = 'wechat_sdk_test'; 
        let scope = 'snsapi_userinfo';
        WeChat.sendAuthRequest(state, scope, (res) => {
            show('sendAuthRequest', res);
        });
    }

    render() {
        return (
            <View style={styles.wrapper}>
                
                <Text style={styles.pageTitle}>WeChat SDK for React Native (iOS)</Text>

                <TouchableHighlight 
                    style={styles.button} underlayColor="#f38"
                    onPress={this.registerApp}>
                    <Text style={styles.buttonTitle}>registerApp</Text>
                </TouchableHighlight>
                
                <TouchableHighlight 
                    style={styles.button} underlayColor="#f38"
                    onPress={this.isWXAppInstalled}>
                    <Text style={styles.buttonTitle}>isWXAppInstalled</Text>
                </TouchableHighlight>

                <TouchableHighlight 
                    style={styles.button} underlayColor="#f38"
                    onPress={this.sendAuthRequest}>
                    <Text style={styles.buttonTitle}>sendAuthRequest</Text>
                </TouchableHighlight>

            </View>
        );
    }
}

let styles = StyleSheet.create({
    wrapper: {
        paddingTop: 70,
        alignItems: 'center',
    },
    pageTitle: {
        paddingBottom: 50
    },
    button: {
        width: 200,
        height: 40,
        marginBottom: 20,
        borderRadius: 6,
        backgroundColor: '#f38',
        alignItems: 'center',
        justifyContent: 'center',
    },
    buttonTitle: {
        fontSize: 16,
        color: '#fff'
    }
});

React.AppRegistry.registerComponent('Example', () => Example);




