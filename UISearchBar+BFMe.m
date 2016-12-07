//
//  UISearchBar+BFMe.m
//  BFMSellerProject
//
//  Created by hexingang on 16/4/20.
//  Copyright © 2016年 hexingang. All rights reserved.
//

#import "UISearchBar+BFMe.h"

@implementation UISearchBar (BFMe)

- (void)fm_setTextFont:(UIFont *)font {
    if (IOS_VERSION >= 9.0) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].font = font;
    }else {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:font];
    }
}

- (void)fm_setTextColor:(UIColor *)textColor {
    if (IOS_VERSION >= 9.0) {
        [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]].textColor = textColor;
    }else {
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:textColor];
    }
}

- (void)fm_setCancelButtonTitle:(NSString *)title {
    if (IOS_VERSION >= 9.0) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:title];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:title];
    }
}


@end
