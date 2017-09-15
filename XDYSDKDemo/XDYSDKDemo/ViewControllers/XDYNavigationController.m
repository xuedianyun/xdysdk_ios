//
//  CustomNavigationControllerViewController.m
//
//
//  Created by Pradeep Kumar Yadav
//

#import "XDYNavigationController.h"

@interface XDYNavigationController ()

@end

@implementation XDYNavigationController

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//    
//}

- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0) {
    return [self.topViewController shouldAutorotate];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.topViewController supportedInterfaceOrientations];
}
// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0) {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end
