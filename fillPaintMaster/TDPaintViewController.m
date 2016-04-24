//
//  TDPaintViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "TDPaintViewController.h"
#import "PaintView0Controller.h"
#import "PaintView1Controller.h"
#import "YYButtonUtils.h"
#import "TDLocationViewController.h"

@interface TDPaintViewController (){
    PaintView0Controller *p0;
    PaintView1Controller *p1;
    

}
@property (weak, nonatomic) IBOutlet UIButton *btn0;
@property (weak, nonatomic) IBOutlet UIButton *btn1;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation TDPaintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"钣金喷漆";
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    [self initButton];
    
    p0=[[PaintView0Controller alloc] init];
    [p0 setTdPaintVCDelegate:self];
    p0.view.frame=self.containerView.bounds;
    
    p1=[[PaintView1Controller alloc] init];
    [p1 setTdPaintVCDelegate:self];
    p1.view.frame=self.containerView.bounds;
    
    [self.containerView addSubview:p0.view];
    [self.containerView addSubview:p1.view];
    [self.containerView bringSubviewToFront:p0.view];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [p0 viewWillAppear:animated];
    [p1 viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [p0 viewWillDisappear:animated];
    [p1 viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
  
}

-(void)initButton{
    [self.btn0 setSelected:NO];
    [self.btn0 setTag:1];
    [self.btn0 addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btn1 setSelected:YES];
    [self.btn1 setTag:2];
    [self.btn1 addTarget:self action:@selector(switchView:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)switchView:(UIButton *)sender{
    if(sender.tag==2){
        if(sender.selected){
            [sender setSelected:NO];
            [self.btn0 setSelected:YES];
            [self.containerView bringSubviewToFront:p1.view];
        }else{
            [sender setSelected:YES];
            [self.btn0 setSelected:NO];
            [self.containerView bringSubviewToFront:p0.view];
        }
    }else{
        if(sender.selected){
            [sender setSelected:NO];
            [self.btn1 setSelected:YES];
            [self.containerView bringSubviewToFront:p0.view];
        }else{
            [sender setSelected:YES];
            [self.btn1 setSelected:NO];
            [self.containerView bringSubviewToFront:p1.view];
        }
    }
}

-(void)change:(id)sender{
    TDLocationViewController *locationVC=[[TDLocationViewController alloc] init];
    [self presentViewController:locationVC animated:YES completion:^{
        
    }];
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
