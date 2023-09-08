//
//  HTUploadTask+CheckInfo.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/19.
//  Copyright © 2020 WJX. All rights reserved.
//



#import "HTUploadTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface HTUploadTask (CheckInfo)

- (void)checkParamFromServer:(HTFileStreamSeparation *_Nonnull)fileStream
              paramCallback:(void(^ _Nullable)(NSString *_Nonnull chunkNumName,NSDictionary *_Nullable param))paramBlock;
@end

NS_ASSUME_NONNULL_END
