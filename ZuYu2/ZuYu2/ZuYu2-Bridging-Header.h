//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#ifndef Swift_Bridging_Header_h
#define Swift_Bridging_Header_h

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MJRefresh/MJRefresh.h>
#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "WXApiObject.h"
#import "YKWoodpecker.h"
#import <UIKit/UIKit.h>

#endif /* Swift_Bridging_Header_h */
