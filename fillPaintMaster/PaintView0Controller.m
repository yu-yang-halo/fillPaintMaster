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
const int PAGE_SIZE_NUM=6;

@interface PaintView0Controller ()<OutOfViewLoadDelegate>{
    float offsetStartX;
    float offsetEndX;
     int  pageIndex;
    
    NSUInteger k1_number;
    NSUInteger qQ_number;
    NSUInteger k2_number;
}
@property (retain, nonatomic)  UIScrollView *scrollView;
@property (retain, nonatomic)  UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)orderCommit:(id)sender;

@end

@implementation PaintView0Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

}
-(void)initView{
    
    self.scrollView=[[UIScrollView alloc] initWithFrame:self.containerView.bounds];
    self.scrollView.delegate=self;
    
    [self.scrollView setContentSize:CGSizeMake(self.containerView.frame.size.width*PAGE_SIZE_NUM, self.containerView.frame.size.height)];
    [self.scrollView setBounces:NO];
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];


    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0, self.containerView.frame.size.height-30, self.containerView.frame.size.width,30)];
    [self.pageControl setNumberOfPages:PAGE_SIZE_NUM];
    [self.pageControl setEnabled:NO];
    
    [self.pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [self.pageControl setCurrentPageIndicatorTintColor:[UIColor orangeColor]];
    
    
    [self.containerView addSubview:_scrollView];
    [self.containerView addSubview:_pageControl];
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewWillLayoutSubviews{
    

}
- (void)viewDidLayoutSubviews NS_AVAILABLE_IOS(5_0){
    [self initView];
    for (int i=0; i<PAGE_SIZE_NUM; i++) {
        DelegateViewController *vc=nil;
        switch (i) {
            case 0:{
                vc=[[LeftCarViewController alloc] init];
                
            }
                break;
                
            case 1:{
                vc=[[RightCarViewController alloc] init];
            }
                break;
            case 2:{
                vc=[[FrontCarViewController alloc] init];
            }
                break;
            case 3:{
                vc=[[BackCarViewController alloc] init];
            }
                break;
            case 4:{
                vc=[[TopCarViewController alloc] init];
            }
                break;
            case 5:{
                vc=[[OtherCarViewController alloc] init];
            }
                break;
        }
        if(vc!=nil){
            [vc setViewDelegate:self];
             vc.view.frame=CGRectMake(self.scrollView.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            
            
            
            [self.scrollView addSubview:vc.view];

        }
        
    }

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
            [tdBtnView.numbersLabel setText:[NSString stringWithFormat:@"%d",k1_number]];
        }else  if(sender.view.tag==CAR_TYPE_K2){
            k2_number++;
            if(k2_number>2){
                k2_number=0;
            }
            [tdBtnView.numbersLabel setText:[NSString stringWithFormat:@"%d",k2_number]];
        }else  if(sender.view.tag==CAR_TYPE_qQ){
            qQ_number++;
            if(qQ_number>4){
                qQ_number=0;
            }
            [tdBtnView.numbersLabel setText:[NSString stringWithFormat:@"%d",qQ_number]];
        }
        
    }
    
    
}
- (void)clickButton:(UIButton *)sender {
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    NSLog(@"sender tag:%d",sender.tag);
    
    switch (sender.tag) {
        case 0:
            /*
             逻辑处理
             */
            break;
            
        default:
            break;
    }
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
    
    
}
@end
