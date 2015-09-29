//
//  CategoryTableViewCell.m
//  jcadrg.BlocSpot
//
//  Created by Mac on 9/28/15.
//  Copyright © 2015 Mac. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "FlatUIKit.h"

@interface CategoryTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, strong) NSLayoutConstraint *categoryLabelHeight;

@end


@implementation CategoryTableViewCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        //Labels
        self.categoryLabel = [[UILabel alloc] init];
        self.categoryLabel.numberOfLines = 0;
        self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.categoryLabel.attributedText = [self categoryLabelAttributedString];
        [self.contentView addSubview:self.categoryLabel];
        
        //Cells
        [self configureFlatCellWithColor:[UIColor cloudsColor]
                           selectedColor:[UIColor cloudsColor]
                         roundingCorners:UIRectCornerAllCorners];
        
        self.cornerRadius = 5.0f;
        self.separatorHeight = 2.0f;
        
        //Tagged Image
        self.tagIV = [[UIImageView alloc] init];
        self.image = [UIImage imageNamed:@"like"];
        self.tagIV.image = self.image;
        
        self.tagIV.image = [_tagIV.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        self.tagIV.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_tagIV];
        
        self.tagIVFullView = [[UIImageView alloc] init];
        self.image2 = [UIImage imageNamed:@"hearts_filled"];
        self.tagIVFullView.image = [_tagIVFullView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.contentView addSubview:_tagIVFullView];
        
        [self createConstraints];
        
        
    }
    
    return self;
}

#pragma mark - Attributed String

-(NSAttributedString *) categoryLabelAttributedString{
    NSString *categoryName = self.category.categoryName;
    NSString *string = NSLocalizedString([categoryName uppercaseString], @"Category label");
    NSRange range = [string rangeOfString:string];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont boldFlatFontOfSize:16] range:range];
    [mutableAttributedString addAttribute:NSKernAttributeName value:@1.3 range:range];
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:self.category.categoryColor range:range];
    
    return mutableAttributedString;
}

-(void) createConstraints{
    
    NSDictionary *viewDictionary = NSDictionaryOfVariableBindings(_categoryLabel, _tagIV, _tagIVFullView);
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagIV(==44)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    ;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tagIV(==44)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tagIVFullView]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    ;
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tagIVFullView(==44)]|"
                                                                             options:kNilOptions
                                                                             metrics:nil
                                                                               views:viewDictionary]];
    
    [self.contentView addConstraints:({
        
        @[[NSLayoutConstraint
           constraintWithItem:_categoryLabel
           attribute:NSLayoutAttributeCenterX
           relatedBy:NSLayoutRelationEqual
           toItem:self.contentView
           attribute:NSLayoutAttributeCenterX
           multiplier:1.f
           constant:0.f],
          
          [NSLayoutConstraint
           constraintWithItem:_categoryLabel
           attribute:NSLayoutAttributeCenterY
           relatedBy:NSLayoutRelationEqual
           toItem:self.contentView
           attribute:NSLayoutAttributeCenterY
           multiplier:1.f
           constant:0]

           ];
    })];
    
    
    
}

-(void) setState:(CategoryTableViewCellState)state{
    [self requestState];
}

-(void) requestState{
    
    switch (self.state) {
        case CategoryTableViewCellStateSelected:
            [self.tagIV setHidden:YES];
            [self.tagIVFullView setHidden:NO];{
                
            }break;
            
        case CategoryTableViewCellStateUnSelected:{
            [self.tagIV setHidden:YES];
            [self.tagIVFullView setHidden:NO];
            
        }break;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
