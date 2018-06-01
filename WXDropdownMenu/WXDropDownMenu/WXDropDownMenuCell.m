//
//  WXDropDownMenuCell.m
//  HealthManager
//
//  Created by 魏新杰 on 2018/5/30.
//  Copyright © 2018年 魏新杰. All rights reserved.
//

#import "WXDropDownMenuCell.h"

@implementation WXDropDownMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        self.separatorInset  = UIEdgeInsetsZero;
        self.layoutMargins   = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = false;
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.text = @"";
        
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.textColor = [UIColor blackColor];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.text = @"";
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIImageView *)leftImageView{
    
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_leftImageView];
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView{
    
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightImageView];
    }
    return _rightImageView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
