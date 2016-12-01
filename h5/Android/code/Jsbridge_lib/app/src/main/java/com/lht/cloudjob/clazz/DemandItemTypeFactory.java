package com.lht.cloudjob.clazz;

import com.lht.cloudjob.customview.DemandItemView;
import com.lht.cloudjob.mvp.model.bean.OrderedTaskResBean;
import com.lht.cloudjob.mvp.model.bean.TaskResBean;

/**
 * <p><b>Package</b> com.lht.cloudjob.clazz
 * <p><b>Project</b> Chuangyiyun
 * <p><b>Classname</b> DemandItemTypeFactory
 * <p><b>Description</b>: 暂未使用到该设计
 * <p> Create by Leobert on 2016/9/18
 */
@Deprecated
public class DemandItemTypeFactory {
    public static DemandItemView.Type newDemandItemType(OrderedTaskResBean bean) {
        if (bean.getModel() == TaskResBean.MODEL_REWARD) {
            return getRewardType(bean);
        } else if (bean.getModel() == TaskResBean.MODEL_BID) {
            return getTenderType(bean);
        } else {
            return DemandItemView.Type.SIMPLE;
        }
    }

    private static DemandItemView.Type getRewardType(OrderedTaskResBean bean) {

//        //单人悬赏-投稿中
//        REWARD_CONTRIBUTE_CONTRIBUTING_DEFAULT(1),
//                //单人悬赏-投稿中-备选
//                REWARD_CONTRIBUTE_CONTRIBUTING_OPTIONAL(2),
//                //单人悬赏-选稿中
//                REWARD_CONTRIBUTE_SELECT_DEFAULT(3),
//                //单人悬赏-选稿中-备选
//                REWARD_CONTRIBUTE_SELECT_OPTIONAL(4),

//                //已中标
//                //单人悬赏-公示中
//                REWARD_BID_SPECTACLE_DEFAULT(5),
//                //单人悬赏-签署协议
//                REWARD_BID_AGREEMENT_DEFAULT(6),
//                //单人悬赏-签署协议-等待甲方
//                REWARD_BID_AGREEMENT_WAITJIA(7),
//
//                //交付中
//                //单人悬赏-交付-上传资源
//                REWARD_LEAD_UPLOADSRC(8),
//                //单人悬赏-交付-等待甲方确认
//                REWARD_LEAD_WAITJIA(9),
//                //单人悬赏-交付-被拒绝
//                REWARD_LEAD_DENY(10),
//
//                //完成
//                //单人悬赏-完成-等待评价
//                REWARD_COMPLETE_EVALUATE_NONE(11),
//                //单人悬赏-完成-完成评价
//                REWARD_COMPLETE_EVALUATE_DOWN(12),
        return null;
    }

    private static DemandItemView.Type getTenderType(OrderedTaskResBean bean) {
        return null;
    }
}
