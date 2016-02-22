//
//  H5JSBridge
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//



//必须要，勿删
function setupJSBridge(callback) {
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
                                     
                                     //回调原生，发送新数据
                                     var responseData = { 'call back to native':'recu data!' }
                                     responseCallback(responseData)
                                     })
              
              
              })

//调原生GPS定位信息
function toNativGPS() {
    alert("调原生GPS定位信息");
    setupJSBridge(function(bridge) {
                  bridge.callHandler('GPSCallback', {'key1': 'Value1','key2': 'Value2'}, function(response) {
                                     //回传GPS数据，实现方法
                                     
                                     })
                  
                  })
}


//function toNativOnclick() {
//    alert("点击触发");
//    setupJSBridge(function(bridge) {
//                  bridge.callHandler('testObjcCallback', {'key1': 'Value1','key2': 'Value2'}, function(response) {
//                                     log('JS got response', response)
//                                     })
//                  
//                  })
//}


