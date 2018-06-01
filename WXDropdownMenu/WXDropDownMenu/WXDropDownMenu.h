//
//  WXDropDownMenu.h
//  HealthManager
//
//  Created by 魏新杰 on 2018/5/30.
//  Copyright © 2018年 魏新杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXDropDownMenuDataSource <NSObject>

@required
//一级列表的行数
- (NSInteger)numberOfRowsInColumnIndex:(NSInteger)columnIndex;

//是否存在二级列表
- (BOOL)isExistItemRowsInColumnIndex:(NSInteger)columnIndex;

//二级列表的行数
- (NSInteger)numberOfItemsInRow:(NSInteger) row  inColumnIndex:(NSInteger)columnIndex;

//一级列表的标题
- (NSString *)titleForRow:(NSInteger)columnRow  inColumnIndex:(NSInteger)columnIndex;

//二级列表的标题
- (NSString *)titleForItemIndex:(NSInteger)itemIndex  forRow:(NSInteger)columnRow  inColumnIndex:(NSInteger)columnIndex;

@optional

//一级列表的标题左边显示图片的地址
- (NSString *)titleImageNameForRow:(NSInteger)columnRow  inColumnIndex:(NSInteger)columnIndex;

//二级列表的标题左边显示图片的地址
- (NSString *)titleImageNameForItemIndex:(NSInteger)itemIndex  forRow:(NSInteger)columnRow  inColumnIndex:(NSInteger)columnIndex;

@end

@protocol  WXDropDownMenuDelegate<NSObject>

- (void)wxDropDownMenuDidSelectColumn:(NSInteger) column columnRow:(NSInteger) row  itemIndex:(NSInteger) itemIndex;

@end


//@class WXMenuIndexPath;
@interface WXDropDownMenu : UIView

//默认的标题文字数组
@property (nonatomic, strong) NSMutableArray  * defaultTitles;

@property (nonatomic, strong) UIFont   * titleFont;

@property (nonatomic, strong) UIColor  * title_defaultColor;

@property (nonatomic, strong) UIColor  * title_selectColor;

//需要设置图片的标题索引数组 跟titleImageNameArray 的count对应，两者都要设置
@property (nonatomic, strong) NSArray  * titleImageIndexArray;

//需要设置的图片数组
@property (nonatomic, strong) NSArray  * titleImageNameArray;

//不显示默认指示器的标题索引数组
@property (nonatomic, strong) NSArray  * noIndicateTitleIndexArray;

@property (nonatomic, weak)   id <WXDropDownMenuDataSource> dataSource;

@property (nonatomic, weak)   id <WXDropDownMenuDelegate>   delegate;

@end
