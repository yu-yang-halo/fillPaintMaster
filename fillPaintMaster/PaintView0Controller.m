//
//  PaintView0Controller.m
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "PaintView0Controller.h"
#import "LeftCarViewController.h"
#import "RightCarViewController.h"
#import "FrontCarViewController.h"
#import "BackCarViewController.h"
#import "TopCarViewController.h"
#import "OtherCarViewController.h"
#import "TDConstants.h"
#import "TDButtonView.h"
#import "OrderReViewController.h"
#import "OrderReViewController.h"
const int PAGE_SIZE_NUM=6;

@interface PaintView0Controller ()<OutOfViewLoadDelegate>{
    float offsetStartX;
    float offsetEndX;
     int  pageIndex;
    
    NSUInteger k1_number;
    NSUInteger qQ_number;
    NSUInteger k2_number;
    
    NSArray *paintArrs;
    
    UIView *leftCarView;
    UIView *rightCarView;
    UIView *frontCarView;
    UIView *backCarView;
    UIView *topCarView;
    UIView *otherCarView;
    
}
@property (retain, nonatomic)  UIScrollView *scrollView;
@property (retain, nonatomic)  UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)orderCommit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

@implementation PaintView0Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self updateLabelView];
    
    [self initView];
    

}
-(void)initViewLayout{
    self.scrollView.frame=self.containerView.bounds;
    [self.scrollView setContentSize:CGSizeMake(self.containerView.frame.size.width*PAGE_SIZE_NUM, self.containerView.frame.size.height)];
    self.pageControl.frame=CGRectMake(0, self.containerView.frame.size.height-30, self.containerView.frame.size.width,30);
    
    
    leftCarView.frame=CGRectMake(self.scrollView.frame.size.width*0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    rightCarView.frame=CGRectMake(self.scrollView.frame.size.width*1, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    frontCarView.frame=CGRectMake(self.scrollView.frame.size.width*2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    backCarView.frame=CGRectMake(self.scrollView.frame.size.width*3, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    topCarView.frame=CGRectMake(self.scrollView.frame.size.width*4, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    otherCarView.frame=CGRectMake(self.scrollView.frame.size.width*5, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
}
-(void)initView{
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.containerView.bounds];
    
    
    self.scrollView.delegate=self;
    
    
    [self.scrollView setBounces:NO];
    [self.scrollView setPagingEnabled:YES];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];


    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height-30, self.containerView.frame.size.width,30)];
    
    
    
    [self.pageControl setNumberOfPages:PAGE_SIZE_NUM];
    [self.pageControl setEnabled:NO];
    
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    
    
    [self.containerView addSubview:_scrollView];
    [self.containerView addSubview:_pageControl];
    
    
    DelegateViewController *v0=[[LeftCarViewController alloc] init];
    DelegateViewController *v1=[[RightCarViewController alloc] init];
    DelegateViewController *v2=[[FrontCarViewController alloc] init];
    DelegateViewController *v3=[[BackCarViewController alloc] init];
    DelegateViewController *v4=[[TopCarViewController alloc] init];
    DelegateViewController *v5=[[OtherCarViewController alloc] init];
    [v0 setViewDelegate:self];
    [v1 setViewDelegate:self];
    [v2 setViewDelegate:self];
    [v3 setViewDelegate:self];
    [v4 setViewDelegate:self];
    [v5 setViewDelegate:self];
    
    
    leftCarView=v0.view;
    rightCarView=v1.view;
    frontCarView=v2.view;
    backCarView=v3.view;
    topCarView=v4.view;
    otherCarView=v5.view;
    
    [self.scrollView addSubview:leftCarView];
    [self.scrollView addSubview:rightCarView];
    [self.scrollView addSubview:frontCarView];
    [self.scrollView addSubview:backCarView];
    [self.scrollView addSubview:topCarView];
    [self.scrollView addSubview:otherCarView];
    
    
}

-(void)setPaintItem:(int)posTag numbers:(int)nums{

    
}
-(void)setPaintItem:(int)posTag selected:(BOOL)selected{
}

-(NSMutableArray *)selectedItems{
   
    return nil;
}

-(void)updateLabelView{
    
}

-(void)viewDidLayoutSubviews{
    [self initViewLayout];
}



-(void)clickView:(UITapGestureRecognizer *)sender{
    NSLog(@"sender.view.tag :%d",sender.view.tag);
    if([sender.view isKindOfClass:[TDButtonView class]]){
        TDButtonView *tdBtnView=(TDButtonView *)sender.view;
        if(sender.view.tag==CAR_TYPE_K1){
            k1_number++;
            if(k1_number>2){
                k1_number=0;
            }
            [self setPaintItem:sender.view.tag numbers:k1_number];
            [tdBtnView.numbersLabel setText:[NSString stringWithFormat:@"%d",k1_number]];
        }else  if(sender.view.tag==CAR_TYPE_K2){
            k2_number++;
            if(k2_number>2){
                k2_number=0;
            }
             [self setPaintItem:sender.view.tag numbers:k2_number];
            [tdBtnView.numbersLabel setText:[NSString stringWithFormat:@"%d",k2_number]];
        }else  if(sender.view.tag==CAR_TYPE_qQ){
            qQ_number++;
            if(qQ_number>4){
                qQ_number=0;
            }
            [self setPaintItem:sender.view.tag numbers:qQ_number];
            [tdBtnView.numbersLabel setText:[NSString stringWithFormat:@"%d",qQ_number]];
        }
        
    }
    
    
    [self updateLabelView];
    
    
}
- (void)clickButton:(UIButton *)sender {
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    
    [self setPaintItem:sender.tag selected:sender.selected];
    [self updateLabelView];
    NSLog(@"sender tag:%d",sender.tag);
}
#pragma mark delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)_scrollView{
    //NSLog(@"scrollViewWillBeginDragging %@",_scrollView);
    offsetStartX=_scrollView.contentOffset.x;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)_scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    
    // NSLog(@"targetContentOffset %f",targetContentOffset->x);
    
    BOOL isScrollLeft=YES;
    offsetEndX=targetContentOffset->x;
    if((offsetEndX-offsetStartX)<0){
        isScrollLeft=NO;
    }
    
    int pageNum=offsetEndX/self.view.frame.size.width;
    int MAX_OFFSET_X_VALUE=60;
    
    if(isScrollLeft){
        //向左滑动
        if((offsetEndX-pageNum*self.view.frame.size.width)>MAX_OFFSET_X_VALUE){
            // NSLog(@"*****pageNum %d",pageNum);
            pageNum+=1;
            
        }
    }else{
        //向右滑动
        //        if((self.frame.size.width-(offsetEndX-pageNum*self.frame.size.width))>MAX_OFFSET_X_VALUE){
        //            pageNum-=1;
        //        }
        
    }
    if(pageNum<0){
        pageNum=0;
    }
    
    // NSLog(@"pageNum %d offsetX %f",pageNum,offsetEndX);
    pageIndex=pageNum;
    
    [self performSelector:@selector(scrollViewFix) withObject:self afterDelay:0.02];
    
}

-(void)scrollViewFix{
    [self.pageControl setCurrentPage:pageIndex];
    [self.scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*self.view.frame.size.width, self.scrollView.contentOffset.y) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)orderCommit:(id)sender {
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    OrderReViewController *orderVC=[storyBoard instantiateViewControllerWithIdentifier:@"orderVC"];
    [orderVC setCarBeautyType:CarBeautyType_paint];
    [orderVC setItems:[self selectedItems]];
    
    [self.tdPaintVCDelegate.navigationController pushViewController:orderVC animated:YES];
    
    
}
@end
