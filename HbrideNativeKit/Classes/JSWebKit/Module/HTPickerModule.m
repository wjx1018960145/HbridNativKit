//
//  HTPickerModule.m
//  HybridForiOS
//
//  Created by wjx on 2020/3/13.
//  Copyright © 2020 WJX. All rights reserved.
//

#import "HTPickerModule.h"
#import <UIKit/UIPickerView.h>
#import <UIKit/UIDatePicker.h>
#import <UIKit/UIKit.h>
#import "HTUtility.h"
#import "HTConvert.h"
#import "HTDefine.h"
#define HTPickerHeight 266
#define HTPickerToolBarHeight 44
#import "NSDictionary+NilSafe.h"
@interface HTPickerModule()<UIGestureRecognizerDelegate>
@property (nonatomic, strong)NSString * pickerType;
// when resign the picker ,then the focus will be.
@property (nonatomic, strong)UIView * focusToView;
//picker
@property(nonatomic,strong)UIPickerView *picker;
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,strong)UIView *pickerView;

//custom
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)UIColor *titleColor;
@property(nonatomic,copy)NSString *cancelTitle;
@property(nonatomic,copy)NSString *confirmTitle;
@property(nonatomic,strong)UIColor *cancelTitleColor;
@property(nonatomic,strong)UIColor *confirmTitleColor;
@property(nonatomic,strong)UIColor *titleBackgroundColor;
@property(nonatomic)CGFloat height;
@property(nonatomic,strong)UIColor *textColor;
@property(nonatomic,strong)UIColor *selectionColor;
//data
@property(nonatomic,copy)NSArray *items;
@property(nonatomic)BOOL isAnimating;
@property(nonatomic)NSInteger index;
@property(nonatomic,copy)HTJBResponseCallback callback;

//date picker
@property(nonatomic,strong)UIDatePicker *datePicker;
@property(nonatomic)UIDatePickerMode datePickerMode;

@end

@implementation HTPickerModule
@synthesize htInstance;

#pragma mark -
#pragma mark Single Picker
-(void)dealloc
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];

    if (nil != _backgroundView.superview) {
        UIView* backgroundView =  _backgroundView;
        dispatch_async(dispatch_get_main_queue(), ^{
            [backgroundView removeFromSuperview];
        });
    }
}

- (void)handleA11yFocusback:(NSDictionary*)options
{
    __weak typeof(self) weakSelf = self;
    if (options[@"sourceRef"] && [options[@"sourceRef"] isKindOfClass:[NSString class]]) {
        
//        HTPerformBlockOnComponentThread(^{
//            WXComponent * focusBackComponent = [weakSelf.weexInstance componentForRef:options[@"sourceRef"]];
//            WXPerformBlockOnMainThread(^{
//                weakSelf.focusToView = focusBackComponent.view;
//            });
//        });
    }
}

-(void)SetColorDelay:(NSNumber *)number
{
    if(self.selectionColor) {
        UILabel *labelSelected = (UILabel*)[self.picker viewForRow:[number integerValue] forComponent:0.3];
        [labelSelected setBackgroundColor:self.selectionColor];
    }
}

-(void)createPicker:(NSArray *)items index:(NSInteger)index
{
    [self configPickerView];
    self.items = [items copy];
    self.index = index;
    if (items && index < [items count]) {
        [self.picker selectRow:index inComponent:0 animated:NO];
        [self performSelector:@selector(SetColorDelay:) withObject:[NSNumber numberWithInteger:self.index] afterDelay:0.3];
        
    } else if(items && [items count]>0) {
        [self.picker selectRow:0 inComponent:0 animated:NO];
        [self performSelector:@selector(SetColorDelay:) withObject:[NSNumber numberWithInteger:0] afterDelay:0.3];

    }
    [self show];
}

-(void)show
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];  //hide keyboard
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundView];
    if (self.isAnimating) {
        return;
    }
    self.isAnimating = YES;
    self.backgroundView.hidden = NO;
    UIView * focusView = self.picker;
    if([_pickerType isEqualToString:@"picker"]) {
        focusView = self.picker;
    } else {
        focusView = self.datePicker;
    }
    UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, focusView);
    [UIView animateWithDuration:0.35f animations:^{
        self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - HTPickerHeight, [UIScreen mainScreen].bounds.size.width, HTPickerHeight);
        self.backgroundView.alpha = 1;
        
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        
    }];
}

-(void)hide
{
    if (self.isAnimating) {
        return;
    }
    self.isAnimating = YES;
    [UIView animateWithDuration:0.35f animations:^{
        self.pickerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, HTPickerHeight);
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        self.backgroundView.hidden = YES;
        self.isAnimating = NO;
        if (!self->_focusToView) {
            self->_focusToView = self.backgroundView.superview;
        }
        UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self->_focusToView);
        [self.backgroundView removeFromSuperview];
    }];
}

-(void)cancel:(id)sender
{
    [self hide];
    if (self.callback) {
        self.callback(@{ @"result": @"cancel"});
        self.callback=nil;
    }
}

-(void)done:(id)sender
{
    [self hide];
    if (self.callback) {
        self.callback(@{ @"result": @"success",@"data":[NSNumber numberWithInteger:self.index]});
        self.callback=nil;
    }
}

-(BOOL)isRightItems:(NSArray *)array
{
    for (id value in array) {
        if([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            continue;
        }else {
            return NO;
        }
    }
    return YES;
}

-(NSString *)convertItem:(id)value
{
    if ([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%ld",[value longValue]];
    }
    return value;
}

#pragma mark -
#pragma mark Picker View

-(void)configPickerView
{
    self.backgroundView = [self createbackgroundView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    if (HT_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && HT_SYS_VERSION_LESS_THAN(@"11.1")) {
        tapGesture.delegate = self;
    }
    [self.backgroundView addGestureRecognizer:tapGesture];
    self.pickerView = [self createPickerView];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HTPickerToolBarHeight)];
    toolBar.barTintColor = self.titleBackgroundColor?self.titleBackgroundColor:[UIColor whiteColor];
    
    
    
    UIBarButtonItem* noSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    noSpace.width=10;
    
    UIBarButtonItem* doneBtn ;
    if (self.confirmTitle.length >0) {
        doneBtn = [[UIBarButtonItem alloc] initWithTitle:self.confirmTitle style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    }else {
       doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    }
    if(self.confirmTitleColor){
        doneBtn.tintColor = self.confirmTitleColor;
    }
    UIBarButtonItem *cancelBtn;
    if (self.cancelTitle.length >0) {
        cancelBtn = [[UIBarButtonItem alloc] initWithTitle:self.cancelTitle style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
    }else {
        cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    }
    if(self.cancelTitleColor){
        cancelBtn.tintColor = self.cancelTitleColor;
    }
    UIBarButtonItem* flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:noSpace,cancelBtn,flexSpace,doneBtn,noSpace, nil]];
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame = CGRectMake(0, 0, 200, HTPickerToolBarHeight);
    titleLabel.center = toolBar.center;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    if(self.titleColor){
        titleLabel.textColor = self.titleColor;
    }
    if(self.title.length>0){
        titleLabel.text = self.title;
        [toolBar addSubview:titleLabel];
    }
    [self.pickerView addSubview:toolBar];
    self.picker = [[UIPickerView alloc]init];
    self.picker.delegate = self;
    CGFloat height = HTPickerHeight;
    if (HTFloatEqual(self.height, 0)){
        height = self.height>HTPickerToolBarHeight?self.height:HTPickerHeight;
    }
    CGRect pickerFrame = CGRectMake(0, HTPickerToolBarHeight, [UIScreen mainScreen].bounds.size.width, height-HTPickerToolBarHeight);
    self.picker.backgroundColor = [UIColor whiteColor];
    self.picker.frame = pickerFrame;
    [self.pickerView addSubview:self.picker];
    [self.backgroundView addSubview:self.pickerView];
}

-(UIView *)createPickerView
{
    UIView *view = [UIView new];
    CGFloat height = HTPickerHeight;
    if (HTFloatEqual(self.height, 0)){
        height = self.height>HTPickerToolBarHeight?self.height:HTPickerHeight;
    }
    view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, height);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

-(UIView *)createbackgroundView
{
    UIView *view = [UIView new];
    view.frame = [UIScreen mainScreen].bounds;
    view.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
    return view;
}

#pragma mark -
#pragma UIPickerDelegate
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.items count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self convertItem:self.items[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.index = row;
    if(self.selectionColor) {
        UILabel *labelSelected = (UILabel*)[pickerView viewForRow:row forComponent:component];
        [labelSelected setBackgroundColor:self.selectionColor];
    }
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *label = (id)view;
    
    if (!label)
    {
        
        label= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        label.textAlignment = NSTextAlignmentCenter;
        UIColor *color = self.textColor?self.textColor:[UIColor blackColor];
        label.textColor = color;
        label.text = [self convertItem:self.items[row]];
    }
    
    return label;
}


- (BOOL)registerBridge:(nonnull WKWebViewJavascriptBridge *)bridge {
    [bridge registerHandler:@"pick" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        
        if (UIAccessibilityIsVoiceOverRunning()) {
              [self handleA11yFocusback:data];
          }
          
        self->_pickerType = @"picker";
          NSArray *items = @[];
          NSInteger index = 0 ;
        
          if (data[@"items"]) {
              items = data[@"items"];
          }
          if (data[@"index"]) {
              index = [HTConvert NSInteger:data[@"index"]];
          }
          if (data[@"title"]) {
              self.title = [HTConvert NSString:data[@"title"]];
          }
          if (data[@"titleColor"]) {
              self.titleColor = [HTConvert UIColor:data[@"titleColor"]];
          }
          if (data[@"cancelTitle"]) {
              self.cancelTitle = [HTConvert NSString:data[@"cancelTitle"]];
          }
          if (data[@"confirmTitle"]) {
              self.confirmTitle = [HTConvert NSString:data[@"confirmTitle"]];
          }
          if (data[@"cancelTitleColor"]) {
              self.cancelTitleColor = [HTConvert UIColor:data[@"cancelTitleColor"]];
          }
          if (data[@"confirmTitleColor"]) {
              self.confirmTitleColor = [HTConvert UIColor:data[@"confirmTitleColor"]];
          }
          if (data[@"titleBackgroundColor"]) {
              self.titleBackgroundColor = [HTConvert UIColor:data[@"titleBackgroundColor"]];
          }
          if (data[@"textColor"]) {
              self.textColor = [HTConvert UIColor:data[@"textColor"]];
          }
          if (data[@"selectionColor"]) {
              self.selectionColor = [HTConvert UIColor:data[@"selectionColor"]];
          }
          if (data[@"height"]) {
              self.height = [HTConvert CGFloat:data[@"height"]];
          }
        
          if (items && [items count]>0 && [self isRightItems:items]) {
              [self createPicker:items index:index];
              self.callback = responseCallback;
          } else {
              if (responseCallback) {
                  responseCallback(@{ @"result": @"error" });
              }
              self.callback = nil;
          }
    }];
    
    [bridge registerHandler:@"pickDate" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        if (UIAccessibilityIsVoiceOverRunning()) {
               [self handleA11yFocusback:data];
           }
        self->_pickerType = @"pickDate";
           self.datePickerMode = UIDatePickerModeDate;
           [self datepick:data callback:responseCallback];
        
    }];
    
    [bridge registerHandler:@"pickTime" handler:^(id  _Nullable data, HTJBResponseCallback  _Nullable responseCallback) {
        if (UIAccessibilityIsVoiceOverRunning()) {
              [self handleA11yFocusback:data];
          }
        self->_pickerType = @"pickTime";
          self.datePickerMode = UIDatePickerModeTime;
          [self datepick:data callback:responseCallback];
    }];
    
    return YES;
}

-(void)datepick:(NSDictionary *)options callback:(HTJBResponseCallback)callback
{
    if ((UIDatePickerModeTime == self.datePickerMode) || (UIDatePickerModeDate == self.datePickerMode)) {
        [self createDatePicker:options callback:callback];
    } else {
        if (callback) {
            callback(@{ @"result": @"error" });
        }
        self.callback = nil;
    }
}

- (void)createDatePicker:(NSDictionary *)options callback:(HTJBResponseCallback)callback
{
    self.callback = callback;
    self.datePicker = [[UIDatePicker alloc]init];
    if (UIDatePickerModeDate == self.datePickerMode) {
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        NSString *value = [HTConvert NSString:options[@"value"]];
        if (value) {
            NSDate *date = [HTUtility dateStringToDate:value];
            if (date) {
                self.datePicker.date =date;
            }
        }
        NSString *max = [HTConvert NSString:options[@"max"]];
        if (max) {
            NSDate *date = [HTUtility dateStringToDate:max];
            if (date) {
                self.datePicker.maximumDate =date;
            }
        }
        NSString *min = [HTConvert NSString:options[@"min"]];
        if (min) {
            NSDate *date = [HTUtility dateStringToDate:min];
            if (date) {
                self.datePicker.minimumDate =date;
            }
        }
    } else if (UIDatePickerModeTime == self.datePickerMode) {
        self.datePicker.datePickerMode = UIDatePickerModeTime;
        NSString *value = [HTConvert NSString:options[@"value"]];
        if (value) {
            NSDate *date = [HTUtility timeStringToDate:value];
            if (date) {
                self.datePicker.date = date;
            }
        }
    }
    [self configDatePickerView];
    [self show];
}

-(void)configDatePickerView
{
    self.backgroundView = [self createbackgroundView];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    if (HT_SYS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") && HT_SYS_VERSION_LESS_THAN(@"11.1")) {
        tapGesture.delegate = self;
    }
    [self.backgroundView addGestureRecognizer:tapGesture];
    self.pickerView = [self createPickerView];
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, HTPickerToolBarHeight)];
    [toolBar setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem* noSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    noSpace.width=10;
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDatePicker:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:noSpace,cancelBtn,flexSpace,doneBtn,noSpace, nil]];
    [self.pickerView addSubview:toolBar];
    CGRect pickerFrame = CGRectMake(0, HTPickerToolBarHeight, [UIScreen mainScreen].bounds.size.width, HTPickerHeight-HTPickerToolBarHeight);
    self.datePicker.frame = pickerFrame;
    self.datePicker.backgroundColor = [UIColor whiteColor];
    [self.pickerView addSubview:self.datePicker];
    [self.backgroundView addSubview:self.pickerView];
}
    
-(void)cancelDatePicker:(id)sender
{
    [self hide];
    if (self.callback) {
        self.callback(@{ @"result": @"cancel"});
        self.callback = nil;
    }
}

-(void)doneDatePicker:(id)sender
{
    [self hide];
    NSString *value = @"";
    if (UIDatePickerModeTime == self.datePicker.datePickerMode) {
        value = [HTUtility timeToString:self.datePicker.date];
    } else if(UIDatePickerModeDate == self.datePicker.datePickerMode)
    {
        value = [HTUtility dateToString:self.datePicker.date];
    }
    if (self.callback) {
        self.callback(@{ @"result": @"success",@"data":value});
        self.callback=nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.pickerView && [touch.view isDescendantOfView:self.pickerView]) {
        return NO;
    }
    return YES;
}


@end
