//
//  WXDropDownMenu.m
//  HealthManager
//
//  Created by 魏新杰 on 2018/5/30.
//  Copyright © 2018年 魏新杰. All rights reserved.
//

#import "WXDropDownMenu.h"
#import "WXDropDownMenuCell.h"

//#define ScreenWidth  [UIScreen mainScreen].bounds.size.width

//#define MAX_DropTableView_Height    336

#define TableViewCell_Height   42

#define Title_BaseTag     200

static  NSString    * reuseCell  =  @"reuse_cell";


@interface WXMenuIndexPath : NSObject

//标题列表索引
@property (nonatomic, assign) NSInteger  column;

//一级列表行索引
@property (nonatomic, assign) NSInteger  rowIndex;

//二级列表行索引
@property (nonatomic, assign) NSInteger  itemIndex;

- (instancetype)initWithColumn:(NSInteger)columnIndex;

@end


@implementation  WXMenuIndexPath

- (instancetype)initWithColumn:(NSInteger)columnIndex{
    
    self = [super init];
    if (self) {
        //默认非选中
        self.column    = columnIndex;
        self.rowIndex  = -1;
        self.itemIndex = -1;
    }
    return self;
}

@end



@interface WXDropDownMenu()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
{
    
    float   maxTable_height;
}
@property (nonatomic, strong) UIView   * backGroudView;

@property (nonatomic, strong) UIColor   * sep_lineColor;

//当前选中的title 列 id
@property (nonatomic, assign) NSInteger   currentSelectTitleIndex;

//标题点击时有一级列表就需要显示列表，没有就不显示
@property (nonatomic, assign) BOOL         isShowTable;

//一级列表
@property (nonatomic, strong) UITableView  * leftTable;

//二级列表
@property (nonatomic, strong) UITableView  * rightTable;


@property (nonatomic, strong) NSMutableArray  * indexPathArray;

@property (nonatomic, strong) WXMenuIndexPath * currentMenuPath;

/********列表cell字体设置******************/
@property (nonatomic, strong) UIFont   * itemFont;

@property (nonatomic, strong) UIColor  * item_defaultColor;

@property (nonatomic, strong) UIColor  * item_selectColor;

@property (nonatomic, assign) BOOL       isShowRightTable;

@end

@implementation WXDropDownMenu

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (void)setup{
    
    float height = [UIScreen mainScreen].bounds.size.height;
    if (height <= 568) {
        maxTable_height = 42*8;
    }else {
        
        maxTable_height  = 42*10;
        
    }
    
    _currentSelectTitleIndex = -1;
    _isShowTable            = NO;
    self.indexPathArray     = [[NSMutableArray alloc] init];
    self.backgroundColor    = [UIColor whiteColor];
    self.layer.borderWidth  = 0.5f;
    self.layer.borderColor  = [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1].CGColor;
    
    _titleFont              =  [UIFont systemFontOfSize:13];
    _itemFont               =  [UIFont systemFontOfSize:13];
    _title_defaultColor     =  [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1];
    _title_selectColor      =  [UIColor colorWithRed:100/255.0 green:140/255.0 blue:243/255.0 alpha:1];
    _item_defaultColor      =  [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1];
    _item_selectColor       =  [UIColor colorWithRed:100/255.0 green:140/255.0 blue:243/255.0 alpha:1];
    _sep_lineColor          =  [UIColor colorWithRed:205/255.0 green:205/255.0 blue:205/255.0 alpha:1];
}

- (UIView *)backGroudView{
    
    if (!_backGroudView) {
        _backGroudView = [[UIView alloc] init];
        _backGroudView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        _backGroudView.frame = CGRectMake(0,CGRectGetMaxY(self.frame),
                                          self.bounds.size.width,
                                          self.superview.bounds.size.height - CGRectGetMaxY(self.frame));
        _backGroudView.tag   = 606;
        
        UITapGestureRecognizer  * tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundTouch)];
        tapGest.delegate = self;
        [_backGroudView addGestureRecognizer:tapGest];
    }
    return _backGroudView;
}

- (UITableView *)leftTable{
    
    if (!_leftTable) {
        _leftTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTable.backgroundColor = [UIColor clearColor];
        _leftTable.dataSource      = self;
        _leftTable.delegate        = self;
        _leftTable.tableFooterView = [[UIView alloc] init];
        _leftTable.tag             = 101;
        [_leftTable registerClass:[WXDropDownMenuCell class] forCellReuseIdentifier:reuseCell];
    }
    
    return _leftTable;
}

- (UITableView *)rightTable{
    
    if (!_rightTable) {
        _rightTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTable.backgroundColor = [UIColor colorWithRed:243/255.0 green:247/255.0 blue:252/255.0 alpha:1.0];
        _rightTable.dataSource      = self;
        _rightTable.delegate        = self;
        _rightTable.tableFooterView = [[UIView alloc] init];
        _rightTable.tag             = 102;
        [_rightTable registerClass:[WXDropDownMenuCell class] forCellReuseIdentifier:reuseCell];
    }
    
    return _rightTable;
}


- (void)setDefaultTitles:(NSMutableArray *)defaultTitles{
    
    _defaultTitles = defaultTitles;
    float average_width = self.bounds.size.width / defaultTitles.count;
    for (int i = 0; i < defaultTitles.count; i++) {
        
        UIButton  * button         =   [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor     =   [UIColor clearColor];
        button.frame               =   CGRectMake(i*average_width, 0, average_width, self.bounds.size.height);
        [button setTitle:defaultTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:self.title_defaultColor forState:UIControlStateNormal];
        button.titleLabel.font     =   self.titleFont;
        button.tag                 =   i + Title_BaseTag;
        [button setImage:[UIImage imageNamed:@"indicate_drop_down"] forState:UIControlStateNormal];
        [self setButtonImageLeft:NO targetButton:button];
        [button addTarget:self action:@selector(titleIndexSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (i > 0) {
            UIView  * lineView         =  [[UIView alloc] init];
            lineView.backgroundColor   =  self.sep_lineColor;
            lineView.frame             =  CGRectMake(i*average_width, (self.bounds.size.height - 20)/2.0, 1.0, 20);
            [self addSubview:lineView];
        }
         WXMenuIndexPath  * menuPath = [[WXMenuIndexPath alloc] initWithColumn:i];
        [self.indexPathArray addObject:menuPath];
        
    }
    
}

- (void)setTitleImageIndexArray:(NSArray *)titleImageIndexArray{
    _titleImageIndexArray = titleImageIndexArray;
    
    [self setTitleImages];
}

- (void)setTitleImageNameArray:(NSArray *)titleImageNameArray{
    _titleImageNameArray = titleImageNameArray;
    [self setTitleImages];
}

- (void)setNoIndicateTitleIndexArray:(NSArray *)noIndicateTitleIndexArray{
    
    _noIndicateTitleIndexArray = noIndicateTitleIndexArray;
    if (noIndicateTitleIndexArray.count > 0) {
        
        for (NSString * index in noIndicateTitleIndexArray) {
            
            NSInteger indexID = [index integerValue];
            UIView * aview = [self viewWithTag:indexID + Title_BaseTag];
            if ([aview isKindOfClass:[UIButton class]]) {
                UIButton  * button = (UIButton *)aview;
                [button setImage:nil forState:UIControlStateNormal];
            }
            
        }
    }
    [self setTitleImages];
}

- (WXMenuIndexPath *)currentMenuPath{
    
    return  self.indexPathArray[self.currentSelectTitleIndex];
    
}

//设置标题的图片
- (void)setTitleImages{
    
    if (_titleImageNameArray.count == 0) {
        return;
    }
    if (_titleImageIndexArray.count == 0) {
        return;
    }
    
    if (_titleImageNameArray.count == _titleImageIndexArray.count) {
        
        for (NSString * index in _titleImageIndexArray) {
            
            
            NSInteger indexID = [index integerValue];
            
            UIView * aview = [self viewWithTag:indexID + Title_BaseTag];
            if ([aview isKindOfClass:[UIButton class]]) {
                
                NSInteger  objextIndex =  [_titleImageIndexArray indexOfObject:index];
                UIButton  * button = (UIButton *)aview;
                [button setImage:[UIImage imageNamed:_titleImageNameArray[objextIndex]] forState:UIControlStateNormal];
                [self setButtonImageLeft:YES targetButton:button];
            }
            
        }
    }
    
}

#pragma Mark ---- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger  columnRowCount   = 0; //一级列表行数
    NSInteger  itemRowCount     = 0; //二级列表行数
    
    if ([self.dataSource respondsToSelector:@selector(numberOfRowsInColumnIndex:)]) {
        
        columnRowCount   =  [self.dataSource numberOfRowsInColumnIndex:self.currentSelectTitleIndex];
    }
    
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInRow:inColumnIndex:)]) {
        
        NSInteger row = self.currentMenuPath.rowIndex >= 0 ?self.currentMenuPath.rowIndex:0;
        itemRowCount     =  [self.dataSource numberOfItemsInRow:row inColumnIndex:self.currentSelectTitleIndex];
    }
    
    if (tableView == self.leftTable) {
        return columnRowCount;
    }
    if (tableView == self.rightTable) {
        return itemRowCount;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return TableViewCell_Height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WXDropDownMenuCell * cell     = (WXDropDownMenuCell *)[tableView dequeueReusableCellWithIdentifier:reuseCell];
    cell.titleLabel.font          =   self.itemFont;
    cell.titleLabel.textColor     =   self.item_defaultColor;
    cell.titleLabel.frame         =   CGRectMake(20, (TableViewCell_Height - 24)/2.0, 120, 24);
    cell.titleLabel.textAlignment = NSTextAlignmentLeft;
    cell.backgroundColor          = [UIColor clearColor];
    
    if (tableView == self.leftTable) {
        cell.backgroundColor = [UIColor whiteColor];
        if (self.isShowRightTable == NO) {
            cell.titleLabel.frame         = CGRectMake(20, (TableViewCell_Height - 24)/2.0, self.leftTable.bounds.size.width - 20*2, 24);
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
        }
        
        if ([self.dataSource respondsToSelector:@selector(titleForRow:inColumnIndex:)]) {
            cell.titleLabel.text = [self.dataSource titleForRow:indexPath.row inColumnIndex:self.currentSelectTitleIndex];
        }
        
        if (self.currentMenuPath.rowIndex == indexPath.row) {
            cell.titleLabel.textColor  = self.item_selectColor;
            cell.backgroundColor = [UIColor colorWithRed:243/255.0 green:247/255.0 blue:252/255.0 alpha:1.0];
        }
    }

    if (tableView == self.rightTable) {
        
        
        if ([self.dataSource respondsToSelector:@selector(titleForItemIndex:forRow:inColumnIndex:)]) {
            
            NSInteger  rowIndex = self.currentMenuPath.rowIndex >= 0?self.currentMenuPath.rowIndex:0;
            cell.titleLabel.text = [self.dataSource titleForItemIndex:indexPath.row forRow:rowIndex inColumnIndex:self.currentSelectTitleIndex];
        }
        
        if (self.currentMenuPath.itemIndex == indexPath.row) {
            cell.titleLabel.textColor   = self.item_selectColor;
        }
    }
    
    
    return cell;
}

#pragma Mark--UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WXMenuIndexPath * menuPath = self.indexPathArray[self.currentSelectTitleIndex];
    
    if (tableView == self.leftTable) {
        
        if ([self.dataSource respondsToSelector:@selector(titleForRow:inColumnIndex:)]) {
            NSString * title = [self.dataSource titleForRow:indexPath.row inColumnIndex:self.currentSelectTitleIndex];
            [self changeSelectTitleText:title];
        }
        menuPath.rowIndex  = indexPath.row;
        menuPath.itemIndex = -1;
        [self.leftTable  reloadData];
       
        if (!self.isShowRightTable) {
            [self disMissTable];
        }else{
            [self.rightTable reloadData];
        }
        
    }else if (tableView == self.rightTable){
        
        if ([self.dataSource respondsToSelector:@selector(titleForItemIndex:forRow:inColumnIndex:)]) {
            
            NSInteger  rowIndex = self.currentMenuPath.rowIndex >= 0?self.currentMenuPath.rowIndex:0;
            NSString  * title = [self.dataSource titleForItemIndex:indexPath.row forRow:rowIndex inColumnIndex:self.currentSelectTitleIndex];
             [self changeSelectTitleText:title];
        }
        menuPath.itemIndex = indexPath.row;
        [self.rightTable reloadData];
        [self disMissTable];
    }
    
    
}


//设置button的图片位置
- (void)setButtonImageLeft:(BOOL) onLeft targetButton:(UIButton *)button{
    
    if (onLeft) {
        
        button.titleEdgeInsets = UIEdgeInsetsMake(0, (button.imageView.bounds.size.width), 0, -(button.imageView.bounds.size.width));
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -(button.titleLabel.bounds.size.width)+8, 0, (button.titleLabel.bounds.size.width));
        
    }else{
        
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -(button.imageView.bounds.size.width), 0, button.imageView.bounds.size.width);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, (button.titleLabel.bounds.size.width)+8, 0, -(button.titleLabel.bounds.size.width));
    }
}

//标题选择
- (void)titleIndexSelect:(UIButton *)sender{
    

   NSInteger   index =  sender.tag - Title_BaseTag;
    
    NSInteger  count = [self.dataSource numberOfRowsInColumnIndex:index];
    if (count > 0) {
        
        if (self.currentSelectTitleIndex == index) {
            self.isShowTable = !self.isShowTable;
        }else{
            self.isShowTable = YES;
        }
    
    }else{
        self.isShowRightTable = NO;
        self.isShowTable = NO;
    }
    
    self.currentSelectTitleIndex = index;
    
    if (self.isShowTable) {
        
        if ([self.superview viewWithTag:606] == nil) {
           [self.superview addSubview:self.backGroudView];
        }
        [self loadTableViewData];
       
    }else{
        [self disMissTable];
        
    }
    
}

//修改当前选择的标题文字
- (void)changeSelectTitleText:(NSString *)text {
    
    [self.defaultTitles replaceObjectAtIndex:self.currentSelectTitleIndex withObject:text];
    
    UIView * aview = [self viewWithTag:self.currentSelectTitleIndex + Title_BaseTag];
    if ([aview isKindOfClass:[UIButton class]]) {
        UIButton  * button = (UIButton *)aview;
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:self.title_selectColor forState:UIControlStateNormal];
        [self setButtonImageLeft:NO targetButton:button];
    }
    
}
//修改当前选择的标题图片
- (void)changeSelectTitleImage:(NSString *)imageName {
    
    UIView * aview = [self viewWithTag:self.currentSelectTitleIndex + Title_BaseTag];
    if ([aview isKindOfClass:[UIButton class]]) {
        UIButton  * button = (UIButton *)aview;
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setButtonImageLeft:YES targetButton:button];
    }
}

//列表消失
- (void)disMissTable{
    
    self.isShowTable = NO;
    
    if ([self.delegate respondsToSelector:@selector(wxDropDownMenuDidSelectColumn:columnRow:itemIndex:)]) {
        
        WXMenuIndexPath * path = self.indexPathArray[self.currentSelectTitleIndex];
        
        [self.delegate wxDropDownMenuDidSelectColumn:path.column columnRow:path.rowIndex itemIndex:path.itemIndex];
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect leftTableFrame = weakSelf.leftTable.frame;
        CGRect rightTableFrame = weakSelf.rightTable.frame;
        [UIView animateWithDuration:0.25 animations:^{
            
            weakSelf.leftTable.frame = CGRectMake(leftTableFrame.origin.x, leftTableFrame.origin.y, leftTableFrame.size.width, 1);
            weakSelf.rightTable.frame = CGRectMake(rightTableFrame.origin.x, rightTableFrame.origin.y, rightTableFrame.size.width, 1);
            
        } completion:^(BOOL finished) {
            [weakSelf.backGroudView removeFromSuperview];
        }];
    });
    
    
    
    
    
}

//加载一级、二级列表
- (void)loadTableViewData{
    
    
    _isShowRightTable = NO;
    if ([self.dataSource respondsToSelector:@selector(isExistItemRowsInColumnIndex:)]) {
        _isShowRightTable = [self.dataSource isExistItemRowsInColumnIndex:self.currentSelectTitleIndex];
    }
    if (_isShowRightTable) {
        if ([self.backGroudView viewWithTag:101] == nil) {
            [self.backGroudView addSubview:self.leftTable];
        }
        if ([self.backGroudView viewWithTag:102] == nil) {
            [self.backGroudView addSubview:self.rightTable];
        }
        
        self.leftTable.frame  = CGRectMake(0, 0, self.backGroudView.bounds.size.width/2.0, 1);
        self.rightTable.frame = CGRectMake(self.backGroudView.bounds.size.width/2.0, 0, self.backGroudView.bounds.size.width/2.0,1);
        [UIView animateWithDuration:0.25 animations:^{
            self.leftTable.frame = CGRectMake(0, 0, self.backGroudView.bounds.size.width/2.0, maxTable_height);
            self.rightTable.frame = CGRectMake(self.backGroudView.bounds.size.width/2.0, 0, self.backGroudView.bounds.size.width/2.0,
                                               maxTable_height);
        }];
        
        
        [self.leftTable reloadData];
        [self.rightTable reloadData];
        
    }else{
        [self.rightTable removeFromSuperview];
        if ([self.backGroudView viewWithTag:101] == nil) {
            [self.backGroudView addSubview:self.leftTable];
        }
        self.leftTable.frame  = CGRectMake(0, 0, self.backGroudView.bounds.size.width, 1);
        [UIView animateWithDuration:0.25 animations:^{
            self.leftTable.frame = CGRectMake(0, 0, self.backGroudView.bounds.size.width, maxTable_height);

        }];
        [self.leftTable reloadData];
    }
    
}

- (void)backGroundTouch{
    
    [self disMissTable];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件(只解除的是cell与手势间的冲突，cell以外仍然响应手势)
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    
    // 若为UITableView（即点击了tableView任意区域），则不截获Touch事件(完全解除tableView与手势间的冲突，cell以外也不会再响应手势)
    if ([touch.view isKindOfClass:[UITableView class]])
    {
        return NO;
    }
    return YES;
}

@end


