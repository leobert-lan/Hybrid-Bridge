//
//  H5JSBridge
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//



//启动监听
setupJSBridge(function(bridge) {
              
              
              var uniqueId = 1
              function log(message, data) {
                var log = document.getElementById('log')
                var el = document.createElement('div')
                el.className = 'logLine'
                el.innerHTML = uniqueId++ + '. ' + message + ':<br/>' + JSON.stringify(data)
                if (log.children.length) {
                    log.insertBefore(el, log.children[0])
                }
                else {
                    log.appendChild(el)
                }
              }
              
              //初始化
              bridge.init(function(message, responseCallback) { })
              
              bridge.registerHandler('testJavascriptHandler', function(data, responseCallback) {
                                     //收到数据，在页面打印
                                     log('原生调H5', data)
                                     
                                     //回调原生，发送新数据
                                     var responseData = { 'testJavascriptHandler call back to native':'recu data!' }
                                     responseCallback(responseData)
                                     
                                     })
              
              
              })

//调原生
function toNativCamera() {
    alert("调原生camera");
    setupJSBridge(function(bridge) {
                  bridge.callHandler('GPSCallback', {'key1': 'Value1','key2': 'Value2'}, function(response) {
                                     //回传数据，实现方法
                                    log("response form native", responseData);
                                     })
                  
                  })
}

