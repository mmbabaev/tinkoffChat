//
//  ThemesViewController.h
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.03.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"

@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController:(ThemesViewController *)controller
              didSelectTheme:(UIColor *)selectedTheme;

@end

@interface ThemesViewController : UIViewController

@property (assign, nonatomic) id<ThemesViewControllerDelegate> delegate;
@property (retain, nonatomic) Themes *model;

@end
