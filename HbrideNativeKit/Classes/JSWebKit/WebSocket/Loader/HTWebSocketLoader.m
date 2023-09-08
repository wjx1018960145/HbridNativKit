//
//  HTWebSocketLoader.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/10.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTWebSocketLoader.h"
#import "HTWebSocketHandler.h"
#import "HTHandlerFactory.h"
#import "HTLog.h"
@interface HTWebSocketLoader()
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *protocol;

@end

@implementation HTWebSocketLoader
- (instancetype)initWithUrl:(NSString *)url protocol:(NSString *)protocol
{
    if (self = [super init]) {
        self.url = url;
        self.protocol = protocol;
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone {
    
    HTWebSocketLoader *newClass = [[HTWebSocketLoader alloc]init];
    newClass.onOpen = self.onOpen;
    newClass.onReceiveMessage = self.onReceiveMessage;
    newClass.onFail = self.onFail;
    newClass.onClose = self.onClose;
    newClass.protocol = self.protocol;
    newClass.url = self.url;
    newClass.identifier = self.identifier;
    return newClass;
}

-(NSString *)identifier
{
    if(!_identifier)
    {
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        _identifier = CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
        assert(_identifier);
        CFRelease(uuid);
    }
    return _identifier;
}

- (void)open
{
    id<HTWebSocketHandler> requestHandler = [HTHandlerFactory handlerForProtocol:@protocol(HTWebSocketHandler)];
    if (requestHandler) {
        [requestHandler open:self.url protocol:self.protocol identifier:self.identifier withDelegate:self];
    } else {
        HTLogError(@"No resource request handler found!");
    }
}

- (void)send:(id)data
{
    id<HTWebSocketHandler> requestHandler = [HTHandlerFactory handlerForProtocol:@protocol(HTWebSocketHandler)];
    
    if (requestHandler) {
        [requestHandler send:self.identifier data:data];
    } else {
        HTLogError(@"No resource request handler found!");
    }
}
- (void)close
{
    id<HTWebSocketHandler> requestHandler = [HTHandlerFactory handlerForProtocol:@protocol(HTWebSocketHandler)];
    if (requestHandler) {
        [requestHandler close:self.identifier];
    } else {
        HTLogError(@"No resource request handler found!");
    }
}

- (void)clear
{
    id<HTWebSocketHandler> requestHandler = [HTHandlerFactory handlerForProtocol:@protocol(HTWebSocketHandler)];
    if (requestHandler) {
        [requestHandler clear:self.identifier];
    } else {
        HTLogError(@"No resource request handler found!");
    }
}

- (void)close:(NSInteger)code reason:(NSString *)reason
{
    id<HTWebSocketHandler> requestHandler = [HTHandlerFactory handlerForProtocol:@protocol(HTWebSocketHandler)];
    if (requestHandler) {
        [requestHandler close:self.identifier code:code reason:reason];
    } else {
        HTLogError(@"No resource request handler found!");
    }
}

#pragma mark - WXWebSocketDelegate
- (void)didOpen
{
    if (self.onOpen) {
        self.onOpen();
    }
}
- (void)didFailWithError:(NSError *)error
{
    if(self.onFail) {
        self.onFail(error);
    }
}
- (void)didReceiveMessage:(id)message
{
    if (self.onReceiveMessage) {
        self.onReceiveMessage(message);
    }
}

- (void)didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    if (self.onClose) {
        self.onClose(code,reason,wasClean);
    }
}
@end
