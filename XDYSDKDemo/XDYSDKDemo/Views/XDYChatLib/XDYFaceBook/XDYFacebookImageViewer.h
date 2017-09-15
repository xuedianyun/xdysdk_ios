//
// MHFacebookImageViewer.h
// Version 2.0
//
// Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <UIKit/UIKit.h>

typedef void (^XDYFacebookImageViewerOpeningBlock)(void);
typedef void (^XDYFacebookImageViewerOpeningBlock)(void);


@class XDYFacebookImageViewer;
@protocol MHFacebookImageViewerDatasource <NSObject>
@required
- (NSInteger) numberImagesForImageViewer:(XDYFacebookImageViewer*) imageViewer;
- (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(XDYFacebookImageViewer*) imageViewer;
- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(XDYFacebookImageViewer*) imageViewer;
@end

@interface XDYFacebookImageViewer : UIViewController
@property (weak, readonly, nonatomic) UIViewController *rootViewController;
@property (nonatomic,strong) NSURL * imageURL;
@property (nonatomic,strong) UIImageView * senderView;
@property (nonatomic,weak) XDYFacebookImageViewerOpeningBlock openingBlock;
@property (nonatomic,weak) XDYFacebookImageViewerOpeningBlock closingBlock;
@property (nonatomic,weak) id<MHFacebookImageViewerDatasource> imageDatasource;
@property (nonatomic,assign) NSInteger initialIndex;


- (void)presentFromRootViewController;
- (void)presentFromViewController:(UIViewController *)controller;
@end

@interface MHFacebookImageViewerTapGestureRecognizer : UITapGestureRecognizer
@property(nonatomic,strong) NSURL * imageURL;
@property(nonatomic,strong) XDYFacebookImageViewerOpeningBlock openingBlock;
@property(nonatomic,strong) XDYFacebookImageViewerOpeningBlock closingBlock;
@property(nonatomic,weak) id<MHFacebookImageViewerDatasource> imageDatasource;
@property(nonatomic,assign) NSInteger initialIndex;

@end

#pragma mark - UIImageView Category

//@interface UIImageView(MHFacebookImageViewer)
//
////-(void)setImageBrowser:(MHFacebookImageViewer *)imageBrowser;
////-(MHFacebookImageViewer *)imageBrowser;
//- (void) setupImageViewer;
//- (void) setupImageViewerWithCompletionOnOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
//- (void) setupImageViewerWithImageURL:(NSURL*)url;
//- (void) setupImageViewerWithImageURL:(NSURL *)url onOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
//- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource onOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
//- (void) setupImageViewerWithDatasource:(id<MHFacebookImageViewerDatasource>)imageDatasource initialIndex:(NSInteger)initialIndex onOpen:(XDYFacebookImageViewerOpeningBlock)open onClose:(XDYFacebookImageViewerOpeningBlock)close;
//- (void)removeImageViewer;
//@end
