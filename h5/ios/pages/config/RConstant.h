//
//  RConstant.h
//  resource
//
//  Created by Yan Qingyang on 15/10/21.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#ifndef RConstant_h
#define RConstant_h

#define kZhugeKey @"b35e64c922d741348247c79917d77d08"
#define kTalkingDataKey @"BF123EB8668F3769C0AFFBD77FB95C3C"
#define kUMengKey @"569c5b3f67e58ea4060016ca"

#define kPageSize 20

#define kCornerRadius 4.2
#define kAdviseSize 500

//常用语
#define Msg_NoTrans @"你还没有传输纪录哦!"
#define Msg_NoResult @"抱歉，没有搜索到您想要的信息"
//#define Msg_NoHistory @"抱歉，没有搜索到您想要的信息"
//umeng key
///页面的统计 [MobClick beginLogPageView:@"OnePage"]; [MobClick endLogPageView:@"OnePage"];

///普通事件 [MobClick event:@"Forward"];

///计数事件 [MobClick event:(NSString *)eventId attributes:(NSDictionary *)attributes];
///////////[MobClick event:@"purchase" attributes:@{@"type" : @"book", @"quantity" : @"3"}];

///属性内容 [MobClick event:@"Mac_Category" label:cell.textLabel.text];
///////////[MobClick event:@"pay" attributes:@{@"book" : @"Swift Fundamentals"} counter:110];

///社交统计
#define cb_qd_show @"cb_qd_show"
#define cb_qd_skip @"cb_qd_skip"
#define cb_bg @"cb_bg"
#define cb_quit @"cb_quit"
#define cb_token_fail @"cb_token_fail"
#define cb_login_show @"cb_login_show"
#define cb_login_login @"cb_login_login"
#define cb_login_success @"cb_login_success"
#define cb_login_fail @"cb_login_fail"
#define cb_box @"cb_box"
#define cb_share @"cb_share"
#define cb_trans @"cb_trans"
#define cb_mine @"cb_mine"
#define cb_search @"cb_search"
#define cb_search_cloud @"cb_search_cloud"
#define cb_searchuser @"cb_searchuser"
#define cb_search_user @"cb_search_user"
#define cb_type @"cb_type"
#define cb_add_show @"cb_add_show"
#define cb_add_photos @"cb_add_photos"
#define cb_add_videos @"cb_add_videos"
#define cb_add_folder @"cb_add_folder"
#define cb_upload @"cb_upload"
#define cb_download @"cb_download"
#define cb_del @"cb_del"
#define cb_move @"cb_move"
#define cb_rename @"cb_rename"
#define cb_open_video @"cb_open_video"
#define cb_open_audio @"cb_open_audio"
#define cb_open_image @"cb_open_image"
#define cb_open_doc @"cb_open_doc"
#define cb_open_image_url @"cb_open_image_url"
#define cb_open_image_album @"cb_open_image_album"
#define cb_Foreground @"cb_Foreground"
#define cb_Terminate @"cb_Terminate"
#define cb_share_public @"cb_share_public"
#define cb_share_private @"cb_share_private"
#define cb_share_users @"cb_share_users"
#define cb_share_send @"cb_share_send"
#define cb_share_got @"cb_share_got"
#define cb_share_ignoreSend @"cb_share_ignoreSend"
#define cb_share_ignoreGot @"cb_share_ignoreGot"
#define cb_share_download @"cb_share_download"
#define cb_share_cloudbox @"cb_share_cloudbox"
#define cb_share_copylink @"cb_share_copylink"
#define cb_share_pwdmodify @"cb_share_pwdmodify"
#define cb_share_lookusers @"cb_share_lookusers"
#endif /* RConstant_h */
