//
//  ViewController.m
//  WXDropdownMenu
//
//  Created by 魏新杰 on 2018/6/1.
//  Copyright © 2018年 weixinjie. All rights reserved.
//

#import "ViewController.h"
#import "WXDropDownMenu.h"
@interface ViewController ()<WXDropDownMenuDataSource,WXDropDownMenuDelegate>

@property (nonatomic, strong) WXDropDownMenu   * dropMenu;

//左列的数组
@property (nonatomic, strong) NSMutableArray   * leftColumnArray;

@property (nonatomic, strong) NSMutableArray   * leftColumnItemArray;

//右列的数组
@property (nonatomic, strong) NSMutableArray   * rightColumnArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.leftColumnArray = [[NSMutableArray alloc] initWithObjects:
                            @"所有科室",
                            @"儿科",@"妇科",@"脑科",
                            @"五官科",@"手术外科",@"整容科",
                            @"妇产科",@"新生儿科",@"骨外科",
                            @"消化科",@"内科",@"口腔科",nil];
    
    self.rightColumnArray = [[NSMutableArray alloc] initWithObjects:
                             @"职级从高到低",@"评论数从高到低",@"咨询量从高到低",
                             @"评分从高到低",nil];
    
    self.leftColumnItemArray = [[NSMutableArray alloc] initWithObjects:
                                @"小儿麻痹",@"小儿麻疹",@"小儿厌食",
                                @"小儿疝气",@"小儿病1",@"小儿病2",
                                @"小儿病3",@"小儿病4",@"小儿病5",
                                @"小儿病6",@"小儿病7",@"小儿病8",
                                @"小儿病9",@"小儿病10",@"小儿病11",
                                @"小儿病12",@"小儿病13",@"小儿病14",nil];
    
    _dropMenu = [[WXDropDownMenu alloc] init];
    _dropMenu.frame = CGRectMake(0, 130, self.view.bounds.size.width, 48);
    _dropMenu.backgroundColor = [UIColor clearColor];
    _dropMenu.defaultTitles = [NSMutableArray arrayWithArray:@[@"科室",@"最新的状况",@"排序"]];
    _dropMenu.dataSource = self;
    _dropMenu.delegate   = self;
    [self.view addSubview:_dropMenu];
}
    
#pragma Mark - WXDropDownMenuDataSource
    //一级列表的行数
- (NSInteger)numberOfRowsInColumnIndex:(NSInteger)columnIndex{
        
        if (columnIndex == 0) {
            
            return self.leftColumnArray.count;
            
        }else if (columnIndex == 1){
            
            return 0;
        }else
            return self.rightColumnArray.count;
        
}
    
    //是否存在二级列表
- (BOOL)isExistItemRowsInColumnIndex:(NSInteger)columnIndex{
        
        if (columnIndex == 0) {
            
            return YES;
            
        }else if (columnIndex == 1){
            
            return NO;
        }else
            return NO;
}
    
    //二级列表的行数
- (NSInteger)numberOfItemsInRow:(NSInteger) row  inColumnIndex:(NSInteger)columnIndex{
        
        if (columnIndex == 0) {
            
            return row + 2;
        }else
            return 0;
        
}
    
    //一级列表的标题
- (NSString *)titleForRow:(NSInteger)columnRow  inColumnIndex:(NSInteger)columnIndex{
        
        if (columnIndex == 0) {
            
            return self.leftColumnArray[columnRow];
        }else if (columnIndex == 2){
            
            return self.rightColumnArray[columnRow];
        }else
            return nil;
        
}
    
    //二级列表的标题
- (NSString *)titleForItemIndex:(NSInteger)itemIndex  forRow:(NSInteger)columnRow  inColumnIndex:(NSInteger)columnIndex{
        
        if (columnIndex == 0) {
            
            return  self.leftColumnItemArray[itemIndex];
            
        }else
            return nil;
        
}
    
#pragma Mark - WXDropDownMenuDelegate
    
- (void)wxDropDownMenuDidSelectColumn:(NSInteger)column columnRow:(NSInteger)row itemIndex:(NSInteger)itemIndex{
        
        NSLog(@"wxDropDownMenuDidSelectColumn  %ld=== %ld === %ld",column,row,itemIndex);
        
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
