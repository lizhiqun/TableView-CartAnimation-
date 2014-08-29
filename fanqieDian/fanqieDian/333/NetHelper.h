//
//  NetHelper.h
//  AliShopping
//
//  Created by ibokan on 13-7-7.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol NetHelperDelegate;
@interface NetHelper : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property(strong,nonatomic)NSMutableData *receiveData;
@property(strong,nonatomic)NSMutableArray *receiveArr;
@property(strong,nonatomic)NSDictionary *receivedic;
@property(assign,nonatomic)id<NetHelperDelegate> delegate;
@property(copy,nonatomic)NSString  *indifier;


-(void)sentrequest:(NSString *)temp_url_str;
-(id)initWithDelegate:(id<NetHelperDelegate>)delegate;
//-(void)sentrequestWithNone:(NSString *)str;
//-(void)sentrequestWithOne:(NSString *)str;
-(void)sentPostRequest:(NSString *)urlstr andNsstringBody:(NSString *)tempbody;
-(void)sentPostRequest:(NSString *)urlstr andBody:(NSDictionary *)tempbody;
//-(void)sentPostRequestWithGet:(NSString *)urlstr andBody:(NSString *)tempbody;
@end
@protocol NetHelperDelegate <NSObject>

-(void)getdata:(id )somthing andIndifier:(NSString *) indefier AndResultSuccess:(BOOL)sucess;
@end