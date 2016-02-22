//js API 实现及注册，这仅仅是一个demo，意在说明如何注册一个API供Native调用，以及需要注意的地方
//首先，JSHandlerRegisterBasicFunc.js必须先加载完成，因为存在js依赖关系，
//这里牵涉到异步加载啦、AMD规范啦什么的我们就不怎么懂了。。。（省略N个字）
//关键：bridge.registerHandler("API_Name",function(data,responseCallback))
//API_Name是实际注册的名称，Native会按照该值进行调用，而本js的名称与调用无关（注意API的维护）
connectWebViewJavascriptBridge(function(bridge) {
	bridge
			.registerHandler(
					"JF_DEMO",
					function(data, responseCallback) {
						//data 是native 发送的数据，此处实现该JsAPI业务，得到responseData 通过回调
						//将处理结果返回Native 注意定义好Bean
						
						//此处打log看一下数据是否收到，非必须
						log("data from Native:",data)
						
						//此处实现API逻辑
						//...
						
						//此处返回处理结果给native
						var responseData = {"key1":"i am result form js"};
						responseCallback(responseData);
					});
})