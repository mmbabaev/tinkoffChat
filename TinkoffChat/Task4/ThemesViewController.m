//
//  ThemesViewController.m
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.03.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//

#import "ThemesViewController.h"

@interface ThemesViewController ()

@end

@implementation ThemesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _model = [Themes new];
}

- (void)dealloc {
    [_model release];
    _model = nil;
    
    [_delegate release];
    _delegate = nil;
    
    [super dealloc];
}

- (IBAction)selectTheme:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    UIColor *color = nil;
    
    if ([title isEqualToString:@"Тема 1"]) {
        color = _model.theme1;
    } else if ([title isEqualToString:@"Тема 2"]) {
        color = _model.theme2;
    } else if ([title isEqualToString:@"Тема 3"]) {
        color = _model.theme3;
    }
    
    [self changeTheme:color];
}

- (void)changeTheme:(UIColor *)theme {
    self.view.backgroundColor = theme;
    [[UINavigationBar appearance] setBarTintColor:theme];
    
    
    if (_delegate) {
        [_delegate themesViewController:self didSelectTheme:theme];
    }
}
        
- (IBAction)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
