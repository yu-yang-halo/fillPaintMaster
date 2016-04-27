//
//  GoodDataSourceViewController.m
//  fillPaintMaster
//
//  Created by admin on 16/4/26.
//  Copyright © 2016年 LZTech. All rights reserved.
//

#import "GoodDataSourceViewController.h"
#import "ElApiService.h"
#import "GoodsCollectionViewCell.h"
#import "Constants.h"
#import "GoodsDetailViewController.h"
@interface GoodDataSourceViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *currentGoodsList;
    SDWebImageManager *manager;
}
@property(nonatomic,strong) UICollectionView *collectionView;
@end

@implementation GoodDataSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    manager = [SDWebImageManager sharedManager];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]];
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(158, 118);
    layout.minimumInteritemSpacing=1;
    layout.minimumLineSpacing=3;
    // Do any additional setup after loading the view from its nib.
    self.collectionView=[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"GoodsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"goodsColllectionViewCell"];
    
    
    
    [self.view addSubview:_collectionView];
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
-(void)setAllGoods:(NSArray *)allGoods{
    currentGoodsList=[[NSMutableArray alloc] init];
    for (TDGoodInfo *goodsinfo in allGoods) {
        if(goodsinfo.type==_clazzType){
            [currentGoodsList addObject:goodsinfo];
        }
    }
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(currentGoodsList!=nil){
        return [currentGoodsList count];
    }
    return 0;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"goodsColllectionViewCell" forIndexPath:indexPath];
    TDGoodInfo *goodsInfo=[currentGoodsList objectAtIndex:indexPath.row];
    
    cell.nameLabel.text=goodsInfo.name;
    cell.descLabel.text=goodsInfo.desc;
    cell.priceLabel.text=[NSString stringWithFormat:@"%.1f元",goodsInfo.price];
    NSString *imageURL=[[ElApiService shareElApiService] getGoodsURL:goodsInfo.src shopId:goodsInfo.shopId];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL]
                      placeholderImage:[UIImage imageNamed:@"icon_default"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    TDGoodInfo *goodsInfo=[currentGoodsList objectAtIndex:indexPath.row];
    

     GoodsDetailViewController *goodsDetailVC=[[GoodsDetailViewController alloc] init];
     goodsDetailVC.title=goodsInfo.name;
    [goodsDetailVC setGoodInfo:goodsInfo];
    
    [self.delegateVC.navigationController pushViewController:goodsDetailVC animated:YES];
    
}

@end
