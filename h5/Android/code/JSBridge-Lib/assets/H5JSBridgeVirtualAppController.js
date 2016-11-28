//document illustration:...

//注册方法：关闭虚拟应用会话
setupJSBridge(function(bridge) {
	bridge.registerHandler("JS_FUNCTION_VIRTUAL_CLOSE", function(data,
			responseCallback) {
		// 无参，暂不依赖回调

		// TODO 实现虚拟应用会话关闭
		log("js func called:", "关闭虚拟应用");

		// 不依赖回调，联调存在资源占用等问题时建立回调依赖，按照回调关闭移动端App的页面
		// responseCallback(responseData);
	});
});

// 注册方法：拖拽模式切换，打开时模拟点击左键拖拽，
// 关闭时要求移动端App表现为网页局部位置移动（一般网页端不做额外事件定义、消费时均表现出该特性）
setupJSBridge(function(bridge) {
	bridge.registerHandler("JS_FUNCTION_VIRTUAL_TOUCHDRAG_MODESWITCH",
			function(data, responseCallback) {
				// data 说明：
				// {"mode": 值}，值可选：0（关闭点击拖拽），1（打开点击拖拽）

				// 传值的话最好log check一下
				log("js func called:", "模式切换");
				log("data from Native:", data)

				// TODO此处实现模式切换
				// ...

				// 不依赖回调
				// var responseData = {"key1":"i am result form js"};
				// responseCallback(responseData);
			});
})
