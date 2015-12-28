//
//  RightCarViewController.m
//  fillPaintMaster
//
//  Created by apple on 15/12/27.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "RightCarViewController.h"
#import "TDConstants.h"
@interface RightCarViewController ()

@property (weak, nonatomic) IBOutlet UIButton *c2Btn;
@property (weak, nonatomic) IBOutlet UIButton *d2Btn;
@property (weak, nonatomic) IBOutlet UIButton *e2Btn;
@property (weak, nonatomic) IBOutlet UIButton *f2Btn;
@property (weak, nonatomic) IBOutlet UIButton *j2Btn;

@end

@implementation RightCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButton];
}

-(void)initButton{
    
    [self.c2Btn setTag:CAR_TYPE_C2];
    [self.d2Btn setTag:CAR_TYPE_D2];
    [self.e2Btn setTag:CAR_TYPE_E2];
    [self.f2Btn setTag:CAR_TYPE_F2];
    [self.j2Btn setTag:CAR_TYPE_J2];
    
    [self.c2Btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.d2Btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.e2Btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.f2Btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.j2Btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickButton:(UIButton *)sender {
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
