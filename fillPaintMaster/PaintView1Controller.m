//
//  PaintView1Controller.m
//  fillPaintMaster
//
//  Created by apple on 15/10/5.
//  Copyright © 2015年 LZTech. All rights reserved.
//

#import "PaintView1Controller.h"

@interface PaintView1Controller ()
@property (weak, nonatomic) IBOutlet UIButton *badCarPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *accidentPicBtn;
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

- (IBAction)uploadBadCarImage:(id)sender;
- (IBAction)uploadAccidentImage:(id)sender;
- (IBAction)orderCommit:(id)sender;

@end

@implementation PaintView1Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)uploadBadCarImage:(id)sender {
    
}

- (IBAction)uploadAccidentImage:(id)sender {
 
}

- (IBAction)orderCommit:(id)sender {
    
}
@end
