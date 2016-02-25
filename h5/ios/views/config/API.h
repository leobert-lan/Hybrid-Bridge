//
//  API.h
//  resource
//
//  Created by Yan Qingyang on 15/10/23.
//  Copyright © 2015年 YAN Qingyang. All rights reserved.
//

#ifndef API_h
#define API_h

//正式环境

#define BASE_URL_V3                         @"https://cbs.vsochina.com/v3"
#define BASE_URL_NEW                        @"https://cbs.vsochina.com/storage"


////////////////////////////////////////////////////////////////////////////////
//sign
#define API_Login                           BASE_URL_V3 @"/login"
#define API_Logout                          BASE_URL_V3 @"/logout"
#define API_Register                        BASE_URL_V3 @"/register/mobile"
////////////////////////////////////////////////////////////////////////////////
//user
#define API_Auth                            BASE_URL_V3 @"/loginstatus"
#define API_Users                           @"/users"

#define API_UsersInfo                       BASE_URL_V3 API_Users@"/%@"

#define API_UsersSearch                     BASE_URL_V3 @"/users"

#define API_PanSearch                       BASE_URL_NEW API_Users@"/%@/search"
#define API_UsersList                       BASE_URL_NEW API_Users@"/%@/list"
#define API_UsersListImages                 BASE_URL_NEW API_Users@"/%@/list/image"
#define API_UsersListVideos                 BASE_URL_NEW API_Users@"/%@/list/video"
#define API_UsersListDocuments              BASE_URL_NEW API_Users@"/%@/list/document"
#define API_UsersListAudios                 BASE_URL_NEW API_Users@"/%@/list/audio"
#define API_UsersFolders                    BASE_URL_NEW API_Users@"/%@/folders"

#define API_UsersFeedback                   BASE_URL_V3 API_Users@"/%@/feedback"
#define API_UsersRename                     BASE_URL_NEW API_Users@"/%@/files/rename"
#define API_UsersRenameF                    BASE_URL_NEW API_Users@"/%@/folders/rename"
#define API_UsersFiles                      BASE_URL_NEW API_Users@"/%@/files"
#define API_UsersMove                       BASE_URL_NEW API_Users@"/%@/move"
#define API_UsersFind                       BASE_URL_V3 API_Users@"/%@/password"
// Share
#define API_SharePublic                     BASE_URL_V3 API_Users@"/%@/share/link/public"
#define API_SharePrivate                    BASE_URL_V3 API_Users@"/%@/share/link/private"
#define API_ShareFriend                     BASE_URL_V3 API_Users@"/%@/share/friend"
#define API_ShareList                       BASE_URL_V3 API_Users@"/%@/share"
#define API_Sharedtome                      BASE_URL_V3 API_Users@"/%@/sharedtome"
//file
#define API_Image_URL                       BASE_URL_NEW API_Users"/%@/thumbnail?path=%@"

//load
#define API_Download                        BASE_URL_NEW API_Users@"/%@/download?path=%@"

#define API_DownloadShare                   BASE_URL_V3 API_Users @"/%@/share/%@/download?path=%@&queryUsername=%@"
#define API_ImageShare                      BASE_URL_V3 API_Users @"/%@/share/%@/thumbnail?path=%@&queryUsername=%@"
#endif /* API_h */
