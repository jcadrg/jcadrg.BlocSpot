//
//  ColorCollectionViewCell.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "ColorCollectionViewCell.h"

@implementation ColorCollectionViewCell

-(id) initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        //Initalizing images
        
        self.colorCollectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.specificSize, self.specificSize)];
        self.colorCollectionViewWithImage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.specificSize, self.specificSize)];
        self.colorCollectionViewWithImage.layer.cornerRadius = 6.0f;
        self.colorCollectionViewWithImage.contentMode = UIViewContentModeScaleAspectFill;
        self.colorCollectionViewWithImage.clipsToBounds=YES;
        
        self.colorCollectionView.layer.cornerRadius = 6.0f;
        self.colorCollectionView.contentMode = UIViewContentModeScaleAspectFill;
        self.colorCollectionView.clipsToBounds = YES;
        
        
        self.checkImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.specificSize -8, self.specificSize-8)];
        self.checkImageView.image = [UIImage imageNamed:@"checkmark"];
        self.checkImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.checkImageView.image = [_checkImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.checkImageView setTintColor:[UIColor cloudsColor]];
        
        [self.contentView addSubview:self.colorCollectionView];
        [self.contentView addSubview:self.colorCollectionViewWithImage];
        [self.colorCollectionView addSubview:self.checkImageView];
        
    }
    
    return self;
}

-(void) setSpecificSize:(CGFloat)specificSize{
    self.colorCollectionView.frame = CGRectMake(0, 0, specificSize, specificSize);
    self.colorCollectionViewWithImage.frame = CGRectMake(0, 0, specificSize, specificSize);
    self.checkImageView.frame = CGRectMake(0, 0, specificSize-8, specificSize-8);
}

-(void) setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    if (selected) {
        [self.colorCollectionView addSubview:self.checkImageView];
    }
}

@end
