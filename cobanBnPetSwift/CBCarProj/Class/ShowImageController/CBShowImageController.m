//
//  CBShowImageController.m
//  cobanBnPetSwift
//
//  Created by zzer on 2023/4/26.
//  Copyright © 2023 coban. All rights reserved.
//

#import "CBShowImageController.h"

@interface CBShowImageController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CBShowImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBarWithTitle:Localized(@"") isBack:YES];
    
    self.imageView = [UIImageView new];
    self.imageView.image = _image;
    self.view.backgroundColor = kBrownColor;
    [self.view addSubview:self.imageView];
    CGFloat height = SCREEN_WIDTH * _image.size.height / _image.size.width;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.left.right.equalTo(@0);
        make.height.equalTo(@(height));
    }];
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
