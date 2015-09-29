//
//  ColorCollectionViewCell.h
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlatUIKit.h"



@interface ColorCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIView *colorCollectionView;
@property (nonatomic, strong) UIView *colorCollectionViewWithImage;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat specificSize;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIColor *backgroundCollectionColor;


-(void) setSelected:(BOOL)selected;


@end
