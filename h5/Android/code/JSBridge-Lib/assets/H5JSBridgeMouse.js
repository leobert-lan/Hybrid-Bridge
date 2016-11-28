//document illustration:...

//注册方法：关闭虚拟应用会话
setupJSBridge(function(bridge) {
	bridge.registerHandler("JS_FUNCTION_MOUSEDOWN", function(data,
			responseCallback) {

		// initMouseEvent( 'type', bubbles, cancelable, windowObject, detail,
		// screenX, screenY,
		// clientX, clientY, ctrlKey, altKey, shiftKey, metaKey, button,
		// relatedTarget )
		data.screenX

		var evObj = document.createEvent('MouseEvents');
		evObj.initMouseEvent('mousedown', true, true, window, 1, 12, 345, 7,
				220, false, false, true, false, 0, null);
		fireOnThis.dispatchEvent(evObj);

		// responseCallback(responseData);
	});
});

// 注册方法：拖拽模式切换，打开时模拟点击左键拖拽，
// 关闭时要求移动端App表现为网页局部位置移动（一般网页端不做额外事件定义、消费时均表现出该特性）
setupJSBridge(function(bridge) {
	bridge.registerHandler("JS_FUNCTION_MOUSEUP", function(data,
			responseCallback) {

		// responseCallback(responseData);
	});
})
