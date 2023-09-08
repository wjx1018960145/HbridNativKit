//
//  HTFileStreamSeparation.h
//  HybridForiOS
//
//  Created by wjx on 2020/3/19.
//  Copyright © 2020 WJX. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HTUploadStatusWaiting = 0,//任务队列等待
    HTUploadStatusUpdownloading,//上传中
    HTUploadStatusPaused,//暂停
    HTUploadStatusFinished,//上传成功
    HTUploadStatusFailed //上传失败
} HTUploadStatus;//任务状态

#define HTStreamFragmentMaxSize         1024 *512 // 500KB

@class HTStreamFragment;


@interface HTFileStreamSeparation : NSObject<NSCoding>
@property (nonatomic, readonly, copy) NSString *fileName;//包括文件后缀名的文件名
@property (nonatomic, readonly, assign) NSUInteger fileSize;//文件大小
@property (nonatomic, copy) NSString *filePath;;//文件所在的文件目录
@property (nonatomic, assign)HTUploadStatus fileStatus;//文件状态
@property (nonatomic, copy)NSString *md5String;//文件md5编码名称
@property (nonatomic, strong) NSArray<HTStreamFragment*> *streamFragments;//文件分片数组
@property (nonatomic, copy) NSString *bizId;

@property (nonatomic,readonly,assign)double progressRate;//上传进度
@property (nonatomic,readonly,assign)NSInteger uploadDateSize;//已上传文件大小

//若为读取文件数据，打开一个已存在的文件。
//若为写入文件数据，如果文件不存在，会创建的新的空文件。（创建FileStreamer对象就可以直接使用fragments(分片数组)属性）
- (instancetype)initFileOperationAtPath:(NSString*)path forReadOperation:(BOOL)isReadOperation ;

//获取当前偏移量
- (NSUInteger)offsetInFile;

//设置偏移量, 仅对读取设置
- (void)seekToFileOffset:(NSUInteger)offset;

//将偏移量定位到文件的末尾
- (NSUInteger)seekToEndOfFile;

//关闭文件
- (void)closeFile;

#pragma mark - 读操作
//通过分片信息读取对应的片数据
- (NSData*)readDateOfFragment:(HTStreamFragment*)fragment;

//从当前文件偏移量开始
- (NSData*)readDataOfLength:(NSUInteger)bytes;

//从当前文件偏移量开始
- (NSData*)readDataToEndOfFile;

#pragma mark - 写操作
//写入文件数据
- (void)writeData:(NSData *)data;

+(NSString*)fileKeyMD5WithPath:(NSString*)path;

@end

//上传文件片
@interface HTStreamFragment : NSObject<NSCoding>
@property (nonatomic,copy)NSString          *fragmentId;    //片的唯一标识
@property (nonatomic,assign)NSUInteger      fragmentSize;   //片的大小
@property (nonatomic,assign)NSUInteger      fragementOffset;//片的偏移量
@property (nonatomic,assign)BOOL            fragmentStatus; //上传状态 YES上传成功
@end
NS_ASSUME_NONNULL_END
