//
//  HTSDKManager.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/4.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTSDKManager.h"
#import "HTThreadSafeMutableDictionary.h"
#import "HTBridgeManager.h"
@interface HTSDKManager()
@property (nonatomic, strong) HTBridgeManager *bridgeMgr;
@property (nonatomic, strong) HTThreadSafeMutableDictionary *instanceDict;

@end

@implementation HTSDKManager
static HTSDKManager *_sharedInstance = nil;
+(HTSDKManager*)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_sharedInstance) {
            _sharedInstance = [[self alloc] init];
            _sharedInstance.instanceDict = [[HTThreadSafeMutableDictionary alloc] init];
            
        }
    });
    return _sharedInstance;
}

+(HTBridgeManager*)bridgeMgr {
    HTBridgeManager* result = [self sharedInstance].bridgeMgr;
    if (result == nil) {
          // devtool may invoke "unload" and set bridgeMgr to nil
          result = [HTBridgeManager sharedManager];
          [self sharedInstance].bridgeMgr = result;
      }
      return result;
}

@end
