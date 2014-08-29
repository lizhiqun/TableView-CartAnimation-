//
//  CaiDanViewController.h
//  fanqieDian
//
//  Created by chenzhihui on 13-11-6.
//  Copyright (c) 2013年 chenzhihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetHelper.h"
#import "TouchTableView.h"
#import "TouchTableViewDelegate.h"
@interface CaiDanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NetHelperDelegate,TouchTableViewDelegate>
@property(strong,nonatomic)TouchTableView *myTableView;
@property(strong,nonatomic)NSMutableArray *marr;
@property(assign,nonatomic)int buyId;
@end
