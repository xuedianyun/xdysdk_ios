//
//  XDY_PictureListVC.m
//  XDYSDKDemo
//
//  Created by lyy on 2017/7/23.
//  Copyright © 2017年 liyanyan. All rights reserved.
//


#import "XDY_PictureListVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XDY_ChoicePictureVC.h"

#define kWHC_CellHeight    (60.0)
#define kWHC_CellName      (@"WHC_PictureListVC")
@interface XDY_PictureListVC (){
    ALAssetsLibrary                  *  _assetsLibray;         //图片库
    NSMutableArray                   *  _assetsGroupArr;       //图片库集合
    NSArray                          *  _imageArr;             //图片集合
}
@property (nonatomic , strong)IBOutlet  UITableView  * pictureList;
@end

@implementation XDY_PictureListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"相册";
    [self initData];
    [self layoutUI];
    [self getPhotoGroup];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutUI{
    UIBarButtonItem  * cancelBarItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(clickCancelBarItem:)];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = cancelBarItem;
}

- (void)initData{
    _assetsGroupArr = [NSMutableArray new];
    _assetsLibray = [ALAssetsLibrary new];
}

-(void)getPhotoGroup{
    __weak  typeof(self)  sf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        void  (^assetGroupEnumerator)(ALAssetsGroup  * ,BOOL * ) = ^(ALAssetsGroup * group,BOOL * stop){
            if(group){
                NSString  * groupPropertyName = [group valueForProperty:ALAssetsGroupPropertyName];
                NSUInteger  groupType = [[group valueForProperty:ALAssetsGroupPropertyType] integerValue];
                if([[groupPropertyName lowercaseString] isEqualToString:@"camera roll"] &&
                   groupType == ALAssetsGroupSavedPhotos){
                    [_assetsGroupArr insertObject:group atIndex:0];
                }else{
                    [_assetsGroupArr addObject:group];
                }
                [sf performSelectorOnMainThread:@selector(updateTableView) withObject:Nil waitUntilDone:YES];
            }
        };
        void  (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError * err){
            NSString  * msg = [NSString stringWithFormat:@"相册错误:%@-%@",[err localizedDescription],[err localizedRecoverySuggestion]];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        };
        [_assetsLibray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:assetGroupEnumerator failureBlock:assetGroupEnumberatorFailure];
    });
}


-(void)updateTableView{
    [_pictureList reloadData];
}

- (void)clickCancelBarItem:(UIBarButtonItem *)sender{
    if (_picDelegate && [_picDelegate respondsToSelector:@selector(XDYPictureCancel)]) {
        [_picDelegate XDYPictureCancel];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWHC_CellHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetsGroupArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:kWHC_CellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kWHC_CellName];
    }
    ALAssetsGroup  * tempGroup = _assetsGroupArr[indexPath.row];
    [tempGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    NSUInteger  count = [tempGroup numberOfAssets];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%lu)",[tempGroup valueForProperty:ALAssetsGroupPropertyName],(unsigned long)count];
    cell.imageView.image = [UIImage imageWithCGImage:[tempGroup posterImage]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    XDY_ChoicePictureVC  * vc = [XDY_ChoicePictureVC new];
    vc.delegate = _delegate;
    vc.maxChoiceImageNumber = _maxChoiceImageNumberumber;
    vc.assetsGroup = _assetsGroupArr[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
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
