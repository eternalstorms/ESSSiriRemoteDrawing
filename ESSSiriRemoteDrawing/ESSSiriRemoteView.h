//
//  ESSSiriRemoteView.h
//  SiriMote
//
//  Created by Matthias Gansrigler on 28.01.2016.
//  Copyright © 2016 Eternal Storms Software. All rights reserved.
//

/*
 
 License Agreement

 1) You can use the code in your own products.
 2) You can modify the code as you wish, and use the modified code in your products.
 3) You can redistribute the original, unmodified code - with this license text included
 4) You can redistribute the modified code as you wish - without this license text included
 5) In all cases, you must include a credit mentioning Matthias Gansrigler as the original author of the source.
 6) Matthias Gansrigler is not liable for anything you do with the code, no matter what. So be sensible.
 7) You can’t use my name or other marks to promote your products based on the code.
 8) If you agree to all of that, go ahead and download the source. Otherwise, don’t.
 
 */

#import <Cocoa/Cocoa.h>

typedef enum : NSUInteger {
	ESSAppleTVSiriRemoteType1080p		= 0,
	ESSAppleTVSiriRemoteType4k			= 1,
	ESSAppleTVRemoteType4k_2021			= 2
} ESSAppleTVSiriRemoteType;

IB_DESIGNABLE
@interface ESSSiriRemoteView : NSView

@property (nonatomic, assign) IBInspectable ESSAppleTVSiriRemoteType remoteType;

@property (nonatomic, strong) IBInspectable NSColor *primaryColor;
@property (nonatomic, strong) IBInspectable NSColor *secondaryColor;
@property (nonatomic, strong) IBInspectable NSColor *fillColor;

- (void)setFillColor:(NSColor *)fill
		primaryColor:(NSColor *)border
	  secondaryColor:(NSColor *)secondary;

@end
