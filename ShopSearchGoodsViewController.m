//
//  ShopSearchGoodsViewController.m
//  BFMSellerProject
//
//  Created by hexingang on 16/4/29.
//  Copyright © 2016年 hexingang. All rights reserved.
//

#import "ShopSearchGoodsViewController.h"
#import "GoodsPublishDetailViewController.h"
#import "LikeGoodsCollectionViewCell.h"
#import "UISearchBar+BFMe.h"

#import "ShopProductsModel.h"
#import "ShopProductsDetailModel.h"

@interface ShopSearchGoodsViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate>
{
    NSMutableArray<ShopProductsDetailModel> *goodsArray;
}

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@property (nonatomic, weak) IBOutlet UICollectionView *mainCollectionView;

@end

@implementation ShopSearchGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"LikeGoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"LikeGoodsCollectionViewCell"];
    
    [self initSearchBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addDropRefresh{
    
    self.mainCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.mainCollectionView reloadData];
        [self.mainCollectionView.mj_footer endRefreshing];
    }];
    
    self.mainCollectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self.mainCollectionView reloadData];
        [self.mainCollectionView.mj_footer endRefreshing];
    }];
    
    [self.mainCollectionView.mj_header beginRefreshing];
    
}

#pragma mark - UISearchBarDelegate

- (void)initSearchBar{
    
    //设置背景图是为了去掉上下黑线
    self.searchBar.backgroundImage = [[UIImage alloc] init];
    self.searchBar.barTintColor = UIColorWithRGB(241, 111, 164);
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14.0f;
        searchField.layer.borderColor = UIColorWithRGB(241, 111, 164).CGColor;
        searchField.layer.borderWidth = 1;
        searchField.layer.masksToBounds = YES;
        [searchField setValue:UIColorWithRGB(241, 111, 164) forKeyPath:@"_placeholderLabel.textColor"];
    }
    
    // 设置按钮文字和颜色
    [self.searchBar fm_setCancelButtonTitle:@"取消"];
    [self.searchBar fm_setTextColor:[UIColor darkGrayColor]];
    
    [self.searchBar becomeFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];

    [self getShopProducts];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = NO;
    [self.searchBar resignFirstResponder];
}

#pragma mark - UICollectionView delegate

#pragma mark - CollectionViewDelegate
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10 , 10, 10);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake( [UIScreen mainScreen].bounds.size.width / 2 - 15   ,  245.0 + (([UIScreen mainScreen].bounds.size.width / 2 - 15) - 147.0));
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return goodsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LikeGoodsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LikeGoodsCollectionViewCell" forIndexPath:indexPath];
    if(indexPath.row == 1)
    {
        [cell initTextCell];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsPublishDetailViewController *detailVC = [[GoodsPublishDetailViewController alloc]init];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (IBAction)touchConcelButton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取店铺商品列表
- (void)getShopProducts{
    NSString *URLString = [kURL_ROOT stringByAppendingString:@"ShopProduct/GetShopProducts"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:USER_PROFILE.userID,@"UserId",
                                USER_PROFILE.ShopId,@"ShopId",
                                @"0",@"Sort",
                                @"0",@"SaleStatus",
                                @"2",@"AuditStatus",
                                @"1",@"PageNo",
                                @"15",@"PageSize",
                                self.searchBar.text,@"KeyWords",
                                nil];
    
    [HttpTool post:URLString params:parameters success:^(id responseObject) {
        ShopProductsModel *returnModel = [[ShopProductsModel alloc]initWithDictionary:responseObject error:nil];
        if ([returnModel.ErrCode isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                goodsArray = returnModel.Products;
                [self.mainCollectionView reloadData];
            });
        }
        else{
            [ToolsFunction showPromptViewWithString:returnModel.ResponseMsg];
        }
        
    } failure:^(NSError *error) {
        SHOWALERT(@"连接服务器失败",1001);
    }];
}
@end
