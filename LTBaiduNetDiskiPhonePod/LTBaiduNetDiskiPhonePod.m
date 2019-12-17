//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  LTBaiduNetDiskiPhonePod.m
//  LTBaiduNetDiskiPhonePod
//
//  Created by 裕福 on 2018/8/20.
//  Copyright (c) 2018年 裕福. All rights reserved.
//

#import "LTBaiduNetDiskiPhonePod.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>

CHDeclareClass(BDPanAccountInfo)

CHOptimizedMethod0(self, BOOL, BDPanAccountInfo, isSVIP){
    return YES;
}
CHOptimizedMethod0(self, BOOL, BDPanAccountInfo, svipExpireTime){
    return [[NSDate dateWithTimeIntervalSinceNow:1 * 365 * 24 * 60 * 60] timeIntervalSince1970];
}

void modifyUserInfoToVip(){
    NSString *userId = ((id (*)(id, SEL))objc_msgSend)(objc_getClass("BDNCAccountInfo"),@selector(userId));
       NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
       NSDictionary *originDic = [ud objectForKey:userId];
       NSLog(@"%@ == %@",userId,originDic);
       
       NSTimeInterval expireTime = [[NSDate dateWithTimeIntervalSinceNow:1 * 365 * 24 * 60 * 60] timeIntervalSince1970];
       NSString *expireTimeStr = [NSString stringWithFormat:@"%f",expireTime];
       NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:originDic];
       [dic setValue:@YES forKey:@"isSVipUser"];
       [dic setValue:expireTimeStr forKey:@"SVipExpireTime"];
       [ud setObject:dic forKey:userId];
}
CHDeclareClass(BDPanCloudFileListViewController)

CHOptimizedMethod1(self, void, BDPanCloudFileListViewController, viewWillAppear, BOOL, arg1){
    CHSuper1(BDPanCloudFileListViewController, viewWillAppear, arg1);
    modifyUserInfoToVip();
}

CHDeclareClass(DownTransListViewController)

CHOptimizedMethod1(self, void, DownTransListViewController, viewWillAppear, BOOL, arg1){
    CHSuper1(DownTransListViewController, viewWillAppear, arg1);
     modifyUserInfoToVip();
}

CHDeclareClass(SettingViewController)

CHOptimizedMethod1(self, void, SettingViewController, viewWillAppear, BOOL, arg1){
    CHSuper1(SettingViewController, viewWillAppear, arg1);
    modifyUserInfoToVip();
}


CHConstructor{
    CHLoadLateClass(BDPanAccountInfo);
    CHLoadLateClass(BDPanCloudFileListViewController);
    CHLoadLateClass(DownTransListViewController);
    CHClassHook0(BDPanAccountInfo, isSVIP);
    CHClassHook0(BDPanAccountInfo, svipExpireTime);
    
    CHHook1(BDPanCloudFileListViewController, viewWillAppear);
    CHHook1(DownTransListViewController, viewWillAppear);
    CHHook1(SettingViewController, viewWillAppear);
}

