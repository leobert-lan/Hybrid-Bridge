//本JS  是H5端的桥，配合Native端的桥搭起底层，请不要修改任何内容
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

setupJSBridge(function(bridge) {
	bridge.init(function(message, responseCallback) {
		//该方法体实现内容无所谓，关键是需要init
//		console.log('JS got a message', message);
//		var data = {
//			'Javascript Responds' : 'hehehe'
//		};
//		console.log('JS responding with', data);
//		responseCallback(data);
	});
})

function Log(message) {
	var data = {'title':"DEBUG",'message':message,'positiveContent':'ok','debug':true};
	alert(JSON.stringify(data));
}

function Log2(hint,message) {
	var data =[hint+'========', message];
	Log(data);
}