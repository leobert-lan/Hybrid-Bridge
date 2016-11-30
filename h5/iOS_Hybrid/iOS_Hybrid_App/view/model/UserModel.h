//
//  UserModel.h
//  Chuangyiyun
//
//  Created by zhchen on 16/6/29.
//  Copyright © 2016年 QY. All rights reserved.
//

#import "BaseModel.h"
@interface AuthModel : BaseModel
//@property (nonatomic,retain) NSString<Optional> *access_id;//auth_username
//@property (nonatomic,retain) NSString<Optional> *access_token;//auth_token
@property (nonatomic,retain) NSString *username;
@property (nonatomic,retain) NSString<Optional> *loginID;
@property (nonatomic,assign) NSInteger isnewpwd;
@property (nonatomic,retain) NSString<Optional> *email;
@property (nonatomic,retain) NSString<Optional> *userid;
@property (nonatomic,retain) NSString<Optional> *logined;
@property (nonatomic,retain) NSString<Optional> *mobile;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *password;
@property (nonatomic,retain) NSString<Optional> *status;
@property (nonatomic,retain) NSString<Optional> *uid;
@property (nonatomic,retain) NSString<Optional> *vso_token;
@property (nonatomic,retain) NSString<Optional> *avatar;
@end
@interface UserModel : BasePrivateModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *sex;
@property (nonatomic,retain) NSString<Optional> *indus_pid;
@property (nonatomic,retain) NSString<Optional> *indus_name;
@property (nonatomic,retain) NSString<Optional> *avatar;
@property (nonatomic,retain) NSString<Optional> *lable;
@property (nonatomic,retain) NSString<Optional> *mobile;
@property (nonatomic,retain) NSString<Optional> *enterprise_auth_status;
@property (nonatomic,retain) NSString<Optional> *realname_auth_status;
@property (nonatomic,retain) NSString<Optional> *mobile_auth_status;
@end
@interface PersonalInfoModel : BaseModel

@end
@interface GuideModel : BaseModel
@property(nonatomic,copy)NSString *version;
@property(nonatomic,assign)BOOL firstOpen;

@end

@interface MyConcernModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *obj_name;
@property (nonatomic,retain) NSString<Optional> *on_date;
@property (nonatomic,retain) NSString<Optional> *nickname;
@property (nonatomic,retain) NSString<Optional> *avatar;
@property (nonatomic,retain) NSString<Optional> *indus_name;
@property (nonatomic,retain) NSString<Optional> *already_favor;
@property (nonatomic,retain) NSString<Optional> *user_type;
@property (nonatomic,retain) NSString<Optional> *user_type_str;
@end
@interface IndusModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *indus_pid;
@property (nonatomic,retain) NSString<Optional> *indus_name;

@end
@interface RealNameModelDB : BasePrivateModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *id_card;
@property (nonatomic,retain) NSString<Optional> *id_pic;
@property (nonatomic,retain) NSString<Optional> *id_pic_2;
@property (nonatomic,retain) NSString<Optional> *id_pic_3;
@property (nonatomic,retain) NSString<Optional> *realname;
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *start_time;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *validity_s_time;
@property (nonatomic,retain) NSString<Optional> *validity_e_time;
@property (nonatomic,retain) NSString<Optional> *s_time;
@property (nonatomic,retain) NSString<Optional> *e_time;
@property (nonatomic,retain) NSString<Optional> *authH;
@property (nonatomic,retain) NSNumber<Optional> *isEdit;
@end

@interface RealNameModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *id_card;
@property (nonatomic,retain) NSString<Optional> *id_pic;
@property (nonatomic,retain) NSString<Optional> *id_pic_2;
@property (nonatomic,retain) NSString<Optional> *id_pic_3;
@property (nonatomic,retain) NSString<Optional> *realname;
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *start_time;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *validity_s_time;
@property (nonatomic,retain) NSString<Optional> *validity_e_time;
@property (nonatomic,retain) NSString<Optional> *nopass_des;
@end
@interface CompanyAuthModelDB : BasePrivateModel
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *company;
@property (nonatomic,retain) NSString<Optional> *legal;
@property (nonatomic,retain) NSString<Optional> *licen_num;
@property (nonatomic,retain) NSString<Optional> *licen_pic;
@property (nonatomic,retain) NSString<Optional> *turnover;
@property (nonatomic,retain) NSString<Optional> *area_prov;
@property (nonatomic,retain) NSString<Optional> *area_city;
@property (nonatomic,retain) NSString<Optional> *area_dist;
@property (nonatomic,retain) NSString<Optional> *ent_start_time;
@property (nonatomic,retain) NSString<Optional> *ent_end_time;
@property (nonatomic,retain) NSString<Optional> *address;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *authH;
@property (nonatomic,retain) NSString<Optional> *s_time;
@property (nonatomic,retain) NSString<Optional> *e_time;
@property (nonatomic,retain) NSNumber<Optional> *isEdit;
@end
@interface CompanyAuthModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *username;
@property (nonatomic,retain) NSString<Optional> *auth_status;
@property (nonatomic,retain) NSString<Optional> *company;
@property (nonatomic,retain) NSString<Optional> *legal;
@property (nonatomic,retain) NSString<Optional> *legal_id_card;
@property (nonatomic,retain) NSString<Optional> *licen_num;
@property (nonatomic,retain) NSString<Optional> *licen_pic;
@property (nonatomic,retain) NSString<Optional> *turnover;
@property (nonatomic,retain) NSString<Optional> *telephone;
@property (nonatomic,retain) NSString<Optional> *area_prov;
@property (nonatomic,retain) NSString<Optional> *area_city;
@property (nonatomic,retain) NSString<Optional> *area_dist;
@property (nonatomic,retain) NSString<Optional> *ent_start_time;
@property (nonatomic,retain) NSString<Optional> *ent_end_time;
@property (nonatomic,retain) NSString<Optional> *residency;
@property (nonatomic,retain) NSString<Optional> *indus_pid;
@property (nonatomic,retain) NSString<Optional> *auth_area;
@property (nonatomic,retain) NSString<Optional> *licen_address;
@end
@interface SysMessagesModel : BaseModel
@property (nonatomic,retain) NSNumber<Optional> *isSel;
@property (nonatomic,retain) NSString<Optional> *msg_id;
@property (nonatomic,retain) NSString<Optional> *view_status;
@property (nonatomic,retain) NSString<Optional> *title;
@property (nonatomic,retain) NSString<Optional> *content;
@property (nonatomic,retain) NSString<Optional> *on_time;
@property (nonatomic,retain) NSString<Optional> *avatar;
@end

@interface MessageModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *msg_id;
@property (nonatomic,retain) NSString<Optional> *view_status;
@property (nonatomic,retain) NSString<Optional> *title;
@property (nonatomic,retain) NSString<Optional> *content;
@property (nonatomic,retain) NSString<Optional> *on_time;
@end

@protocol  MessageModel
@end

@interface MessageSysModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *count;
@property (nonatomic,retain) NSArray<MessageModel,Optional> *message;
@end

@interface MessageInformModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *count;
@property (nonatomic,retain) NSArray<MessageModel,Optional> *message;
@end

@interface AuthCountyModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *s;
@property (nonatomic,retain) NSNumber<Optional> *isEx;
@end
@protocol AuthCountyModel <NSObject>

@end
@interface AuthCityModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *n;
@property (nonatomic,retain) NSMutableArray<AuthCountyModel,Optional> *a;
@property (nonatomic,retain) NSNumber<Optional> *isEx;
@end
@protocol AuthCityModel <NSObject>

@end
@interface AuthAreaListModel : BaseModel
@property (nonatomic,retain) NSString<Optional> *p;
@property (nonatomic,retain) NSMutableArray<AuthCityModel,Optional> *c;
@property (nonatomic,retain) NSNumber<Optional> *isEx;
@end
