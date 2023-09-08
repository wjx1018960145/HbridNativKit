//
//  HTDeviceInfoModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/16.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTDeviceInfoModule.h"
#import "DeviceInfoManager.h"
#import "NetWorkInfoManager.h"
#import "BatteryInfoManager.h"
#import "NSDictionary+NilSafe.h"
@interface BasicInfo : NSObject

@property (nonatomic, copy) NSString *infoKey;
@property (nonatomic, strong) NSObject *infoValue;

@end

@implementation BasicInfo
@end

@interface HTDeviceInfoModule()
@property (nonatomic, strong) NSMutableArray *infoArray;

@end


@implementation HTDeviceInfoModule

@synthesize htInstance;

- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    
    [bridge registerHandler:@"hardWare" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
         [self.infoArray removeAllObjects];
        
//
        const NSString *deviceName = [[DeviceInfoManager sharedManager] getDeviceName];
          [self _addInfoWithKey:@"deviceName" infoValue:[deviceName copy]];

          NSString *iPhoneName = [UIDevice currentDevice].name;
          [self _addInfoWithKey:@"iPhoneName" infoValue:iPhoneName];

          NSString *deviceColor = [[DeviceInfoManager sharedManager] getDeviceColor];
          [self _addInfoWithKey:@"deviceColor" infoValue:deviceColor];

          NSString *deviceEnclosureColor = [[DeviceInfoManager sharedManager] getDeviceEnclosureColor];
          [self _addInfoWithKey:@"EnclosureColor" infoValue:deviceEnclosureColor];

          NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
          [self _addInfoWithKey:@"appVerion" infoValue:appVerion];

          NSString *device_model = [[DeviceInfoManager sharedManager] getDeviceModel];
          [self _addInfoWithKey:@"device_model" infoValue:device_model];

          NSString *localizedModel = [UIDevice currentDevice].localizedModel;
          [self _addInfoWithKey:@"localizedModel" infoValue:localizedModel];

          NSString *systemName = [UIDevice currentDevice].systemName;
          [self _addInfoWithKey:@"systemName" infoValue:systemName];

          NSString *systemVersion = [UIDevice currentDevice].systemVersion;
          [self _addInfoWithKey:@"systemVersion" infoValue:systemVersion];

          const NSString *initialFirmware = [[DeviceInfoManager sharedManager] getInitialFirmware];
          [self _addInfoWithKey:@"initialFirmware" infoValue:[initialFirmware copy]];

          const NSString *latestFirmware = [[DeviceInfoManager sharedManager] getLatestFirmware];
          [self _addInfoWithKey:@"latestFirmware" infoValue:[latestFirmware copy]];

          BOOL canMakePhoneCall = [DeviceInfoManager sharedManager].canMakePhoneCall;
          [self _addInfoWithKey:@"canMakePhoneCall" infoValue:[NSString stringWithFormat:@"%d",canMakePhoneCall]];

          NSDate *systemUptime = [[DeviceInfoManager sharedManager] getSystemUptime];
        
        //用于格式化NSDate对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设置格式：zzz表示时区
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
        //NSDate转NSString
        NSString *currentDateString = [dateFormatter stringFromDate:systemUptime];
          [self _addInfoWithKey:@"systemUptime" infoValue: currentDateString];

          NSUInteger busFrequency = [[DeviceInfoManager sharedManager] getBusFrequency];
        [self _addInfoWithKey:@"busFrequency" infoValue:[NSString stringWithFormat:@"%@",@(busFrequency)]];

          NSUInteger ramSize = [[DeviceInfoManager sharedManager] getRamSize];
          [self _addInfoWithKey:@"ramSize" infoValue:[NSString stringWithFormat:@"%@",@(ramSize)] ];

        NSMutableArray *dataArr = [NSMutableArray array];
        for (BasicInfo *base in self.infoArray) {
            NSMutableDictionary *dic = [@{} mutableCopy];
            [dic setValue:base.infoValue?base.infoValue:@"" forKey:base.infoKey?base.infoKey:@""];
            [dataArr addObject: dic];
        }
        
//         NSLog(@"%@",dataArr);
        if (responseCallback) {
            responseCallback(@{@"result":@"success",@"data":dataArr});
                  }
        
    }];
    [bridge registerHandler:@"battery" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
        [self.infoArray removeAllObjects];
        BatteryInfoManager *batteryManager = [BatteryInfoManager sharedManager];
//           batteryManager.delegate = self;
           [batteryManager startBatteryMonitoring];
           
           CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
           NSString *levelValue = [NSString stringWithFormat:@"%.2f", batteryLevel];
           [self _addInfoWithKey:@"电池电量" infoValue:levelValue];
           
           NSInteger batteryCapacity = batteryManager.capacity;
           NSString *capacityValue = [NSString stringWithFormat:@"%ld mA", batteryCapacity];
           [self _addInfoWithKey:@"电池容量" infoValue:capacityValue];
           
           CGFloat batteryMAH = batteryCapacity * batteryLevel;
           NSString *mahValue = [NSString stringWithFormat:@"%.2f mA", batteryMAH];
           [self _addInfoWithKey:@"当前电池剩余电量" infoValue:mahValue];
           
           CGFloat batteryVoltage = batteryManager.voltage;
           NSString *voltageValue = [NSString stringWithFormat:@"%.2f V", batteryVoltage];
           [self _addInfoWithKey:@"电池电压" infoValue:voltageValue];
           
           NSString *batterStatus = batteryManager.status ? : @"unkonwn";
           [self _addInfoWithKey:@"电池状态" infoValue:batterStatus];
        
        NSMutableArray *dataArr = [NSMutableArray array];
              for (BasicInfo *base in self.infoArray) {
                  NSMutableDictionary *dic = [@{} mutableCopy];
                  [dic setValue:base.infoValue?base.infoValue:@"" forKey:base.infoKey?base.infoKey:@""];
                  [dataArr addObject: dic];
              }
        
        if (responseCallback) {
           responseCallback(@{@"result":@"success",@"data":dataArr});
        }
        
        
    }];
    
    [bridge registerHandler:@"address" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        // 广告位标识符：在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了
           NSString *idfa = [[DeviceInfoManager sharedManager] getIDFA];
           [self _addInfoWithKey:@"广告位标识符idfa" infoValue:idfa];
           
           //  UUID是Universally Unique Identifier的缩写，中文意思是通用唯一识别码。它是让分布式系统中的所有元素，都能有唯一的辨识资讯，而不需要透过中央控制端来做辨识资讯的指 定。这样，每个人都可以建立不与其它人冲突的 UUID。在此情况下，就不需考虑数据库建立时的名称重复问题。苹果公司建议使用UUID为应用生成唯一标识字符串。
           NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
           [self _addInfoWithKey:@"唯一识别码uuid" infoValue:uuid];
           
           NSString *device_token_crc32 = [[NSUserDefaults standardUserDefaults] objectForKey:@"device_token_crc32"] ? : @"";
           [self _addInfoWithKey:@"device_token_crc32真机测试才会显示" infoValue:device_token_crc32];

           NSString *macAddress = [[DeviceInfoManager sharedManager] getMacAddress];
           [self _addInfoWithKey:@"macAddress" infoValue:macAddress];
           
           NSString *deviceIP = [[NetWorkInfoManager sharedManager] getDeviceIPAddresses];
           [self _addInfoWithKey:@"deviceIP" infoValue:deviceIP];
           
           NSString *cellIP = [[NetWorkInfoManager sharedManager] getIpAddressCell];
           [self _addInfoWithKey:@"蜂窝地址" infoValue:cellIP];
           
           NSString *wifiIP = [[NetWorkInfoManager sharedManager] getIpAddressWIFI];
           [self _addInfoWithKey:@"WIFI IP地址" infoValue:wifiIP];
        
        NSMutableArray *dataArr = [NSMutableArray array];
                     for (BasicInfo *base in self.infoArray) {
                         NSMutableDictionary *dic = [@{} mutableCopy];
                         [dic setValue:base.infoValue?base.infoValue:@"" forKey:base.infoKey?base.infoKey:@""];
                         [dataArr addObject: dic];
                     }
               
               if (responseCallback) {
                  responseCallback(@{@"result":@"success",@"data":dataArr});
               }
               
        
    }];
    
    [bridge registerHandler:@"cpu" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        NSString *cpuName = [[DeviceInfoManager sharedManager] getCPUProcessor];
           [self _addInfoWithKey:@"CPU 处理器名称" infoValue:cpuName];
           
           NSUInteger cpuCount = [[DeviceInfoManager sharedManager] getCPUCount];
           [self _addInfoWithKey:@"CPU总数目" infoValue:@(cpuCount)];
           
           CGFloat cpuUsage = [[DeviceInfoManager sharedManager] getCPUUsage];
           [self _addInfoWithKey:@"CPU使用的总比例" infoValue:@(cpuUsage)];
           
           NSUInteger cpuFrequency = [[DeviceInfoManager sharedManager] getCPUFrequency];
           [self _addInfoWithKey:@"CPU 频率" infoValue:@(cpuFrequency)];
           
           NSArray *perCPUArr = [[DeviceInfoManager sharedManager] getPerCPUUsage];
           NSMutableString *perCPUUsage = [NSMutableString string];
           for (NSNumber *per in perCPUArr) {
               
               [perCPUUsage appendFormat:@"%.2f<-->", per.floatValue];
           }
           [self _addInfoWithKey:@"单个CPU使用比例" infoValue:perCPUUsage];
        NSMutableArray *dataArr = [NSMutableArray array];
                            for (BasicInfo *base in self.infoArray) {
                                NSMutableDictionary *dic = [@{} mutableCopy];
                                [dic setValue:base.infoValue?base.infoValue:@"" forKey:base.infoKey?base.infoKey:@""];
                                [dataArr addObject: dic];
                            }
                      
                      if (responseCallback) {
                         responseCallback(@{@"result":@"success",@"data":dataArr});
                      }
        
    }];
    [bridge registerHandler:@"disk" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        NSString *applicationSize = [[DeviceInfoManager sharedManager] getApplicationSize];
           [self _addInfoWithKey:@"当前 App 所占内存空间" infoValue:applicationSize];
           
           int64_t totalDisk = [[DeviceInfoManager sharedManager] getTotalDiskSpace];
           NSString *totalDiskInfo = [NSString stringWithFormat:@"== %.2f MB == %.2f GB", totalDisk/1024/1024.0, totalDisk/1024/1024/1024.0];
           [self _addInfoWithKey:@"磁盘总空间" infoValue:totalDiskInfo];
           
           int64_t usedDisk = [[DeviceInfoManager sharedManager] getUsedDiskSpace];
           NSString *usedDiskInfo = [NSString stringWithFormat:@" == %.2f MB == %.2f GB", usedDisk/1024/1024.0, usedDisk/1024/1024/1024.0];
           [self _addInfoWithKey:@"磁盘 已使用空间" infoValue:usedDiskInfo];
           
           int64_t freeDisk = [[DeviceInfoManager sharedManager] getFreeDiskSpace];
           NSString *freeDiskInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeDisk/1024/1024.0, freeDisk/1024/1024/1024.0];

           [self _addInfoWithKey:@"磁盘空闲空间" infoValue:freeDiskInfo];
           
           int64_t totalMemory = [[DeviceInfoManager sharedManager] getTotalMemory];
           NSString *totalMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", totalMemory/1024/1024.0, totalMemory/1024/1024/1024.0];
           [self _addInfoWithKey:@"系统总内存空间" infoValue:totalMemoryInfo];
           
           int64_t freeMemory = [[DeviceInfoManager sharedManager] getFreeMemory];
           NSString *freeMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", freeMemory/1024/1024.0, freeMemory/1024/1024/1024.0];
           [self _addInfoWithKey:@"空闲的内存空间" infoValue:freeMemoryInfo];
           
           int64_t usedMemory = [[DeviceInfoManager sharedManager] getFreeDiskSpace];
           NSString *usedMemoryInfo = [NSString stringWithFormat:@" %.2f MB == %.2f GB", usedMemory/1024/1024.0, usedMemory/1024/1024/1024.0];
           [self _addInfoWithKey:@"已使用的内存空间" infoValue:usedMemoryInfo];
           
           int64_t activeMemory = [[DeviceInfoManager sharedManager] getActiveMemory];
           NSString *activeMemoryInfo = [NSString stringWithFormat:@"正在使用或者很短时间内被使用过 %.2f MB == %.2f GB", activeMemory/1024/1024.0, activeMemory/1024/1024/1024.0];
           [self _addInfoWithKey:@"活跃的内存" infoValue:activeMemoryInfo];
           
           int64_t inActiveMemory = [[DeviceInfoManager sharedManager] getInActiveMemory];
           NSString *inActiveMemoryInfo = [NSString stringWithFormat:@"但是目前处于不活跃状态的内存 %.2f MB == %.2f GB", inActiveMemory/1024/1024.0, inActiveMemory/1024/1024/1024.0];
           [self _addInfoWithKey:@"最近使用过" infoValue:inActiveMemoryInfo];
           
           int64_t wiredMemory = [[DeviceInfoManager sharedManager] getWiredMemory];
           NSString *wiredMemoryInfo = [NSString stringWithFormat:@"framework、用户级别的应用无法分配 %.2f MB == %.2f GB", wiredMemory/1024/1024.0, wiredMemory/1024/1024/1024.0];
           [self _addInfoWithKey:@"用来存放内核和数据结构的内存" infoValue:wiredMemoryInfo];
           
           int64_t purgableMemory = [[DeviceInfoManager sharedManager] getPurgableMemory];
           NSString *purgableMemoryInfo = [NSString stringWithFormat:@"大对象存放所需的大块内存空间 %.2f MB == %.2f GB", purgableMemory/1024/1024.0, purgableMemory/1024/1024/1024.0];
           [self _addInfoWithKey:@"可释放的内存空间：内存吃紧自动释放" infoValue:purgableMemoryInfo];
        
        NSMutableArray *dataArr = [NSMutableArray array];
                                   for (BasicInfo *base in self.infoArray) {
                                       NSMutableDictionary *dic = [@{} mutableCopy];
                                       [dic setValue:base.infoValue?base.infoValue:@"" forKey:base.infoKey?base.infoKey:@""];
                                       [dataArr addObject: dic];
                                   }
                             
                             if (responseCallback) {
                                responseCallback(@{@"result":@"success",@"data":dataArr});
                             }
    }];
    
    return YES;
}


- (void)_addInfoWithKey:(NSString *)infoKey infoValue:(NSObject *)infoValue {
    BasicInfo *info = [[BasicInfo alloc] init];
    info.infoKey = infoKey;
    info.infoValue = infoValue;
    NSLog(@"%@---%@", infoKey, infoValue);
    [self.infoArray addObject:info];
}

- (NSMutableArray *)infoArray {
    if (!_infoArray) {
        _infoArray = [NSMutableArray array];
    }
    return _infoArray;
}

@end
