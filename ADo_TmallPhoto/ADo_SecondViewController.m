//
//  ADo_SecondViewController.m
//  ADo_TmallPhotoAlbum
//
//  Created by 杜 维欣 on 15/5/19.
//  Copyright (c) 2015年 ADo. All rights reserved.
//

#import "ADo_SecondViewController.h"
#import "Ado_CommonCell.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "Ado_CameraCell.h"
#define screenW ([UIScreen mainScreen].bounds.size.width)
#define idenfierCommon @"dwx"
#define idenfierCamera @"camera"
#define lineSpacing  10.0;
@interface ADo_SecondViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *ado_collectionView;
@property (nonatomic, strong) NSMutableArray *urlArray;

@end

@implementation ADo_SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getImgs];
    [self.view addSubview:self.ado_collectionView];
}
- (NSMutableArray *)urlArray
{
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (UICollectionView *)ado_collectionView
{
    if (!_ado_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = lineSpacing;
        CGFloat width = screenW - lineSpacing;
        CGFloat widthHW = width / 2;
        layout.itemSize = CGSizeMake(widthHW , widthHW);
        
        _ado_collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _ado_collectionView.backgroundColor = [UIColor whiteColor];
        _ado_collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _ado_collectionView.dataSource = self;
        _ado_collectionView.delegate = self;
        UINib *nib = [UINib nibWithNibName:@"Ado_CommonCell" bundle:nil];
        
        [self.ado_collectionView registerNib:nib forCellWithReuseIdentifier:idenfierCommon];
        [self.ado_collectionView registerClass:[Ado_CameraCell class] forCellWithReuseIdentifier:idenfierCamera];
        
    }
    return _ado_collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.urlArray.count + 1);
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        Ado_CameraCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:idenfierCamera forIndexPath:indexPath];
        
        return cell1;
    }else {
        
        Ado_CommonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenfierCommon forIndexPath:indexPath];
        if (self.urlArray.count) {
            NSURL *url = self.urlArray[indexPath.row - 1];
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
                cell.photoView.image = image;
            }failureBlock:^(NSError *error) {
                NSLog(@"error=%@",error);
            }];
        }else {
            NSLog(@"相册没有图片");
        }
        
        return cell;
    }
}


-(void)getImgs{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {
                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    
                    [self.urlArray addObject:result.defaultRepresentation.url];
                }
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            
            if (group!=nil) {
                
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
                /**
                 *  刷新
                 */
                [self.ado_collectionView reloadData];
            }
            
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });
    
}



@end
