//
//  TDAdView.m
//  fillPaintMaster
//
//  Created by apple on 15/9/28.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TDAdView.h"
@interface TDAdView()<UIScrollViewDelegate>{
    UIScrollView *scrollView;
    float offsetStartX;
    float offsetEndX;
    int  pageIndex;
}

@property(nonatomic,retain) UIPageControl *pageControl;
@property(nonatomic,retain) NSArray *imageNames;
@end

@implementation TDAdView

-(instancetype)initADViewWithFrame:(CGRect)frame  adImageNames:(NSArray *)imgNames{
    self=[super initWithFrame:frame];
    
    if(self){
        [self setAdViewImages:imgNames];
    }
    
    return self;
}
-(void)setAdViewImages:(NSArray *)imgNames{
    if(scrollView!=nil){
        [scrollView removeFromSuperview];
    }
    scrollView=[[UIScrollView alloc] initWithFrame:self.bounds];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setBounces:NO];
    [self addSubview:scrollView];
    self.imageNames=imgNames;
    scrollView.delegate=self;
    [self initAdContentView:self.frame];
}

-(void)initAdContentView:(CGRect)frame{
    for (int i=0;i<[_imageNames count];i++) {
        UIImageView *adImageView=[[UIImageView alloc] initWithFrame:CGRectMake(i*frame.size.width,0, frame.size.width, frame.size.height)];
        [adImageView setTag:i];
        [adImageView setImage:[UIImage imageNamed:[_imageNames objectAtIndex:i]]];
        
        [scrollView addSubview:adImageView];
    }
    int pageNum=[_imageNames count];
    
    [scrollView setContentSize:CGSizeMake(pageNum*frame.size.width,frame.size.height)];
    
    self.pageControl=[[UIPageControl alloc] initWithFrame:CGRectMake(0,frame.size.height-20,frame.size.width, 20)];
    [self.pageControl setEnabled:NO];
    [self.pageControl setNumberOfPages:[_imageNames count]];
    [self addSubview:_pageControl];
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
    
    int pageNum=offsetEndX/self.frame.size.width;
    int MAX_OFFSET_X_VALUE=15;
    
    if(isScrollLeft){
        //向左滑动
        if((offsetEndX-pageNum*self.frame.size.width)>MAX_OFFSET_X_VALUE){
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
     [scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*self.frame.size.width, scrollView.contentOffset.y) animated:YES];
}
@end
