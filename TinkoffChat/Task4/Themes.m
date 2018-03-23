//
//  Themes.m
//  TinkoffChat
//
//  Created by Mihail Babaev on 23.03.2018.
//  Copyright © 2018 mbabaev. All rights reserved.
//

#import "Themes.h"

@implementation Themes

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.theme1 = [UIColor redColor];
        self.theme2 = [UIColor yellowColor];
        self.theme3 = [UIColor blackColor];
    }
    
    return self;
}

- (void)dealloc {
    [self.theme1 release];
    [self.theme2 release];
    [self.theme3 release];
    
    [super dealloc];
}

@end
