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
	} else {
		//该部分确保android 调用js成功
		document.addEventListener('WebViewJavascriptBridgeReady', function() {
			callback(WebViewJavascriptBridge)
		}, false);
	}
	
	//以下内容确保iOS 调用js成功
	if (window.WVJBCallbacks) {
		return window.WVJBCallbacks.push(callback);
	}
	window.WVJBCallbacks = [ callback ];
	var WVJBIframe = document.createElement('iframe');
	WVJBIframe.style.display = 'none';
	WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__';
	document.documentElement.appendChild(WVJBIframe);
	setTimeout(function() {
		document.documentElement.removeChild(WVJBIframe)
	}, 0);
	
	
}

//启动监听
setupJSBridge(function(bridge) {

	var uniqueId = 1
	function log(message, data) {
		var log = document.getElementById('log')
		var el = document.createElement('div')
		el.className = 'logLine'
		el.innerHTML = uniqueId++ + '. ' + message + ':<br/>'
				+ JSON.stringify(data)
		if (log.children.length) {
			log.insertBefore(el, log.children[0])
		} else {
			log.appendChild(el)
		}
	}

	//初始化
	bridge.init(function(message, responseCallback) {
	})

	bridge.registerHandler('testJavascriptHandler', function(data,
			responseCallback) {
		//收到数据，在页面打印
		log('原生调H5', data)

		//回调原生，发送新数据
		var responseData = {
			'call back to native' : 'recu data!'
		}
		responseCallback(responseData)

	})

})

setupJSBridge(function(bridge) {
	bridge
			.registerHandler(
					"test2",
					function(data, responseCallback) {
						//data 是native 发送的数据，此处实现该JsAPI业务，得到responseData 通过回调
						//将处理结果返回Native 注意定义好Bean
						document.getElementById("show").innerHTML = ("data from Java: = " + data);
						var responseData = "Javascript 确定被调用成功";
						responseCallback(responseData);
					});
})

//调原生GPS定位信息
function toNativGPS() {
//	alert("调原生GPS定位信息");
	
//	 window.WebViewJavascriptBridge
//     .callHandler(
//     'CN_OPENGPS',
//     {
//         'key1' : 'Value1',
//         'key2' : 'Value2'
//     },
//     function(responseData) {
//         document.getElementById("show").innerHTML = "send get responseData from java, data = "
//         + responseData
//     });
	
	
	setupJSBridge(function(bridge) {
		bridge.callHandler('CN_OPENGPS', {
			'key1' : 'Value1',
			'key2' : 'Value2'
		},function(responseData) {
	         document.getElementById("show").innerHTML = "send get responseData from java, data = "
	         + responseData
	     })

	})
}
