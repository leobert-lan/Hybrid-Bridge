//为了减少js调用NativeAPI出错的机率，定义这样一个可以免去频繁输入方法名
//但是会增加加载内容，该部分如何设计由H5人员把控
function callNativeOpenGPSAndResponseLocation(onNativeResponseCallback) {

	connectWebViewJavascriptBridge(function(bridge) {
		bridge.callHandler('NF_OPENGPS', {
			'key1' : 'this is test data,this native api do not need data'
		}, onNativeResponseCallback)
	})

};

function callErrorFunc() {

	connectWebViewJavascriptBridge(function(bridge) {
		bridge.callHandler('wtf', {
			'key1' : 'test data'
		}, null)
	})

};

function callDemo(data,callback) {
	connectWebViewJavascriptBridge(function(bridge) {
		bridge.callHandler('NF_DEMO',data,callback);
	})
}

function callLongTimeDemo(data,callback) {
	connectWebViewJavascriptBridge(function(bridge) {
		bridge.callHandler('NF_LTDEMO',data,callback);
	})
}