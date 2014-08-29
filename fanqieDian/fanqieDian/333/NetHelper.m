//
//  NetHelper.m
//  AliShopping
//
//  Created by ibokan on 13-7-7.
//  Copyright (c) 2013年 ibokan. All rights reserved.
//

#import "NetHelper.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
@implementation NetHelper
-(id)initWithDelegate:(id<NetHelperDelegate>)delegate{
    if (self=[super init]) {
        self.delegate=delegate;
    }
    return self;
}
#pragma mark - MD5加密方法
-(void)sentrequest:(NSString *)temp_url_str{
    NSString *url_str=[self getNewUrl:temp_url_str];
    NSURL *url=[NSURL URLWithString:url_str];
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:18];
    
    [NSURLConnection connectionWithRequest:request delegate:self];

}
-(NSString *)getNewUrl:(NSString *)oldUrlString{
//    NSDate* dat = [NSDate date];
//    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)[dat timeIntervalSince1970]];
//    
//    //字符串拼接
//    NSString * secretKey = [NSString stringWithFormat:@"3bf1114a986ba87ed28fc1b5884fc2f8%@",timeString];
//    
//    //MD5加密
//    NSString *strkey = [MyMD5 md5:secretKey];
//    NSString *newUrlString=[oldUrlString mutableCopy];
//    newUrlString=[newUrlString stringByAppendingString:[NSString stringWithFormat:@"&transTime=%@&transKey=%@",timeString,strkey]];

    return oldUrlString;
}
-(void)sentPostRequest:(NSString *)urlstr andBody:(NSDictionary *)tempbody{
    
    NSURL *url=[NSURL URLWithString:urlstr];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:28];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSMutableString *bodyStr=[self getBody:tempbody];
    NSLog(@"%@",bodyStr);
    NSData *data=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];


}
-(void)sentPostRequest:(NSString *)urlstr andNsstringBody:(NSString *)tempbody{
    
    NSURL *url=[NSURL URLWithString:urlstr];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:28];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *data=[tempbody dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
-(NSMutableString *)getBody:(NSDictionary *)dic{
     NSArray *arr=[dic allKeys];
    NSMutableString *body=[NSMutableString string];
    for(int i=0;i<[arr count]-1;i++){
        NSString *key=[arr objectAtIndex:i];
        NSString *value=[dic valueForKey:key];
        if (!value) {
            value=@"";
        }
        NSString *keyVlaue=[NSString stringWithFormat:@"%@=%@&",key,value];
        [body appendString:keyVlaue];
    }
    NSString *lastKey=[arr lastObject];
    NSString *lastValue=[dic valueForKey:lastKey];
    NSString *lastkeyVlaue=[NSString stringWithFormat:@"%@=%@",lastKey,lastValue];
    [body appendString:lastkeyVlaue];
    return body;
    
}

#pragma mark - URL Delegate
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate getdata:nil andIndifier:self.indifier AndResultSuccess:NO];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData=[NSMutableData dataWithCapacity:0];
    
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   
    NSString *str=[[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    id someThing=[str JSONValue];
    if ([someThing isKindOfClass:[NSDictionary class]])
    {
        self.receivedic=someThing;
        [self.delegate getdata:self.receivedic andIndifier:self.indifier AndResultSuccess:YES];

    }else{
        
        [self.delegate getdata:str andIndifier:self.indifier AndResultSuccess:YES];
        
    }
}

@end
