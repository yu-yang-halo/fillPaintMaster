//
//  CarBeautyViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/9/29.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "CarBeautyViewController.h"
#import "TimeUtils.h"
#import "TDBeautyTableViewCell.h"
@interface CarBeautyViewController ()
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UITableView *beautyItemTableView;

@property(retain,nonatomic) NSArray *items;

@end

@implementation CarBeautyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTitleView];
    [self initTimeView];
    [self initBeautyItemTableView];
    
}

-(void)initBeautyItemTableView{
    self.items=@[@"<离子覆膜精细洗车",@"<漆面深度清洁打蜡",@"<内室普通清洗消毒",@"<内室环保清洗护理"];
    [self.beautyItemTableView setRowHeight:50];
    self.beautyItemTableView.delegate=self;
    self.beautyItemTableView.dataSource=self;
}

-(void)initTimeView{
    /*
         4行 6列
     
     */
    float totalH=self.timeView.frame.size.height;
    float totalW=self.timeView.frame.size.width;
    float top=5;
    float left=20;
    
    float BTN_WIDTH=45;
    float BTN_HEIGHT=28;
   
    float hspace=(totalW-left-6*BTN_WIDTH)/6;
    float vspace=(totalH-4*BTN_HEIGHT-top*2)/3;
    
    for(int j=0;j<24;j++){
        int row=j/6;
        int col=j%6;
        UIButton *timeBtn=[[UIButton alloc] initWithFrame:CGRectMake(left+col*(BTN_WIDTH+hspace),top+row*(BTN_HEIGHT+vspace),BTN_WIDTH, BTN_HEIGHT)];
        [timeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [timeBtn.layer setBorderWidth:1];
        [timeBtn.layer setBorderColor:[[UIColor colorWithWhite:0.8 alpha:1] CGColor]];
        [timeBtn setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        
        [timeBtn setBackgroundImage:[UIImage imageNamed:@"yes"] forState:UIControlStateSelected];
        
        [timeBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [timeBtn setTag:j];
        [timeBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        [timeBtn setTitle:[TimeUtils createTimeString:row column:col] forState:UIControlStateNormal];
        [self.timeView addSubview:timeBtn];
        
    }
    
}
-(void)selectTime:(UIButton *)sender{
    NSLog(@"tag %d",sender.tag);
    if(sender.selected){
        [sender setSelected:NO];
        [sender setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
        

    }else{
        [sender setSelected:YES];
        [sender setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
      
    }
}

-(void)initTitleView{

    UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *changeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, 70, 44)];
    [changeBtn setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [changeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -40)];
    [changeBtn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView  *titleView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 24)];
    UILabel *cphLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 24, 150, 20)];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setFont:[UIFont systemFontOfSize:20]];
    [titleLabel setText:@"洗车美容"];
    
    [cphLabel setTextAlignment:NSTextAlignmentCenter];
    [cphLabel setFont:[UIFont systemFontOfSize:10]];
    [cphLabel setText:@"皖A PS826"];
    
    [titleView addSubview:titleLabel];
    [titleView addSubview:cphLabel];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.titleView=titleView;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:changeBtn];
}
-(void)change:(id)sender{
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier=@"beautyCell";
    TDBeautyTableViewCell *tableCell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(tableCell==nil){
       tableCell= [[[NSBundle mainBundle] loadNibNamed:@"TDBeautyTableViewCell" owner:self options:nil] lastObject];
       
        NSLog(@"new ....");
    }else{
        NSLog(@"exists...");
    }
    [tableCell.contentLabel setText:[_items objectAtIndex:indexPath.row]];
    [tableCell.addOrRemoveBtn setTag:indexPath.row];
    [tableCell.addOrRemoveBtn addTarget:self action:@selector(addOrRemoveCart:) forControlEvents:UIControlEventTouchUpInside];
    return tableCell;
}
-(void)addOrRemoveCart:(UIButton *)sender{
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    NSLog(@"addOrRemoveCart index %d",sender.tag);
    
}

@end
