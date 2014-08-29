//
//  CaiDanViewController.m
//  fanqieDian
//
//  Created by chenzhihui on 13-11-6.
//  Copyright (c) 2013年 chenzhihui. All rights reserved.
//

#import "CaiDanViewController.h"
#import "ShopCell.h"
#import "Meal.h"
#import "OrderInstance.h"

@interface CaiDanViewController ()
#define SELECTEDBGCOLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"cm_center_sv_bg"]]
@end

@implementation CaiDanViewController
UIButton *carButton;
UIImageView *carBG;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableView=[[TouchTableView alloc]initWithFrame:CGRectMake(0, 40, 320, 390) style:UITableViewStylePlain];
    self.myTableView.delegate=self;
    self.myTableView.dataSource=self;
    self.myTableView.touchDelegate=self;
    [self.view addSubview:self.myTableView];
    [self sentRequest];
    [self loadMyBottonView];
	// Do any additional setup after loading the view.
}
#pragma mark
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indifier=@"HomeCell";
    ShopCell *cell=[tableView dequeueReusableCellWithIdentifier:indifier];
    if (cell==nil) {
        cell=[[ShopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indifier];
    }
    Meal *meal=[self.marr objectAtIndex:indexPath.row];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    BOOL buyed=[[OrderInstance sharedInstance]hasOredr:[meal.mId intValue]];
    [cell setInfoTitle:meal.title andPrice:[NSString stringWithFormat:@"￥%@/份",meal.price] andNum:meal.num andImageUrl:[NSString stringWithFormat:@"%@%@",MHHeadUrl,meal.imageUrl] andBuyed: buyed];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cellTaped:)];
    tap.numberOfTapsRequired=1;
    [cell.contentView addGestureRecognizer:tap];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//            
//
//}
-(void)sentRequest{

    self.marr=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<10; i++) {
        Meal *meal=[[Meal alloc]initWithID:[NSString stringWithFormat:@"%d",i+1] andTitle:[NSString stringWithFormat:@"菜品%d",i+1] andOther:@"卖的好" andImageUrl:@"45a6d" andPrice:@"45.0" andPoint:@"4.5" andNum:i+100];
        [self.marr addObject:meal];
        
    }
    [self.myTableView reloadData];

}
#pragma mark - 底部button
-(void)loadMyBottonView{
    
    carBG=[[UIImageView alloc]initWithFrame:CGRectMake(250, HEIGTH-55, 120, 38)];
    carBG.image=[UIImage imageNamed:@"cart_full_show"];
    carBG.userInteractionEnabled=YES;
    carBG.backgroundColor=[UIColor clearColor];
    [self.view addSubview:carBG];
    
    carButton=[UIButton buttonWithType:UIButtonTypeCustom];
    carButton.frame=CGRectMake(3, 2, 35, 35);
    [carButton setImage:[UIImage imageNamed:@"cart_empty"] forState:UIControlStateNormal];
    [carBG addSubview:carButton];


}
#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point=[[touches anyObject]locationInView:self.myTableView];
    int b=(int)(point.y/70);
    Meal *meal=[self.marr objectAtIndex:b];
    BOOL buyed=[[OrderInstance sharedInstance]hasOredr:[meal.mId intValue]];
    NSIndexPath *path=[NSIndexPath indexPathForRow:b inSection:0];
    ShopCell *cell=(ShopCell *)[tableView cellForRowAtIndexPath:path];
    
    if (buyed) {
        [[OrderInstance sharedInstance]deleOrder:meal];
        [cell notbuyAnimation];
    }else{
        [[OrderInstance sharedInstance]addOrder:meal];
        [cell buyAnimation];
    }
   
    
    if (!buyed) {
        //该部分动画 以self.view为参考系进行
        
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cm_center_discount"]];
        imageView.contentMode=UIViewContentModeScaleToFill;
        imageView.frame=CGRectMake(0, 0, 20, 20);
        imageView.hidden=YES;
        CGPoint point=[[touches anyObject]locationInView:self.myTableView];
        imageView.center=point;
        CALayer *layer=[[CALayer alloc]init];
        layer.contents=imageView.layer.contents;
        layer.frame=imageView.frame;
        layer.opacity=1;
        [self.view.layer addSublayer:layer];
        CGPoint point1=carButton.center;
        //动画 终点 都以sel.view为参考系
        CGPoint endpoint=[self.view convertPoint:point1 fromView:carBG];
        UIBezierPath *path=[UIBezierPath bezierPath];
        //动画起点
        CGPoint startPoint=[self.view convertPoint:point fromView:self.myTableView];
        [path moveToPoint:startPoint];
        //贝塞尔曲线中间点
        float sx=startPoint.x;
        float sy=startPoint.y;
        float ex=endpoint.x;
        float ey=endpoint.y;
        float x=sx+(ex-sx)/3;
        float y=sy+(ey-sy)*0.5-400;
        CGPoint centerPoint=CGPointMake(x,y);
        [path addQuadCurveToPoint:endpoint controlPoint:centerPoint];
        
        CAKeyframeAnimation *animation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.path = path.CGPath;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.duration=0.8;
        animation.delegate=self;
        animation.autoreverses= NO;
        animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [layer addAnimation:animation forKey:@"buy"];
    }
    
}

-(void)tableView:(UITableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

}
-(void)tableView:(UITableView *)tableView touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}
-(void)tableView:(UITableView *)tableView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}
-(void)move:(CALayer *)layer{
    [layer removeFromSuperlayer];

}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    id a=[anim valueForKey:@"buy"];
    NSLog(@"%@",a);

}
@end
