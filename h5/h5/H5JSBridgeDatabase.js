//
//  H5JSBridge
//  H5
//
//  Created by Qingyang on 16/2/5.
//  Copyright © 2016年 Qingyang. All rights reserved.
//


//该业务暂不适合调试，暂略

//启动监听
setupJSBridge(function(bridge) {
              
              
              
              })

//调原生
function toNativDB() {
    alert("调原生DB");
    setupJSBridge(function(bridge) {
                  bridge.callHandler('NATIVE_FUNCTION_DB', {'key1': 'Value1','key2': 'Value2'}, function(response) {
                                     //回传数据，实现方法
                                    log("response form native", responseData);
                                     })
                  
                  })
}

