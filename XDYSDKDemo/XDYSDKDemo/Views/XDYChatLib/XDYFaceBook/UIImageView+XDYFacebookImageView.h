//
//  UIImageView+XDYFacebookImageView.h
//  FBImageViewController_Demo
//
//  Created by lyy on 2017/7/20.
//  Copyright © 2017年 Michael Henry Pantaleon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XDYFacebookImageViewer.h"

@interface UIImageView (XDYFacebookImageView)

- (void) setupImageViewer;
- (void) setupImageViewerWithCompletionOnOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
- (void) setupImageViewerWithImageURL:(NSURL*)url;
- (void) setupImageViewerWithImageURL:(NSURL *)url onOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource onOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
- (void)removeImageViewer;
@property (retain, nonatomic) XDYFacebookImageViewer *imageBrowser;

@end
