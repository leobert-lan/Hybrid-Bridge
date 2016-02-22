//
//  H5JSBridge
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//



//必须要，勿删
function setupJSBridge(callback) {
    //该部分确保android 调用js成功
    document.addEventListener('WebViewJavascriptBridgeReady', function() {
                              callback(WebViewJavascriptBridge)
                              }, false);
    
    if (window.WebViewJavascriptBridge) {
        return callback(WebViewJavascriptBridge);
    }
    
    if (window.WVJBCallbacks) {
        return window.WVJBCallbacks.push(callback);
    }
    
    window.WVJBCallbacks = [callback];
    var WVJBIframe = document.createElement('iframe');
    WVJBIframe.style.display = 'none';
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
    document.documentElement.appendChild(WVJBIframe);
    setTimeout(function() { document.documentElement.removeChild(WVJBIframe) }, 0)
}

//启动监听
setupJSBridge(function(bridge) {
              //初始化
              bridge.init(function(message, responseCallback) { });
              
              //验证
              bridge.registerHandler('authH5Handler', function(data, responseCallback) {
                                     //收到数据
//                                     log('authH5Handler', data)
                                     
                                     //回调原生，发送新数据
                                     var responseData = { 'authH5Handler call back to native':'authH5Handler' }
                                     responseCallback(responseData)
                                     })
              
              
              })





