//
//  ESSSiriRemoteView.m
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


#import "ESSSiriRemoteView.h"

//ESSAppleTVSiriRemoteTypePre2021 Constants
#define ESS_SIRIREMOTE_HEIGHT						12.350
#define ESS_SIRIREMOTE_WIDTH						 3.700

#define ESS_SIRIREMOTE_TOUCHAREA_Y					 7.000

#define ESS_SIRIREMOTE_BUTTON_X						 0.400
#define ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT		 1.250

#define ESS_SIRIREMOTE_TOPBUTTONS_Y					 7.200

#define ESS_SIRIREMOTE_HOMEBUTTON_IMAGEWIDTH		 0.450
#define ESS_SIRIREMOTE_HOMEBUTTON_IMAGEHEIGHT		 0.250

#define ESS_SIRIREMOTE_MIDDLEBUTTON_Y				 5.500

#define ESS_SIRIREMOTE_BOTTOMBUTTON_Y				 3.900

#define ESS_SIRIREMOTE_VOLUMEBUTTON_HEIGHT			 2.850

#define ESS_SIRIREMOTE_PLAYPAUSE_PLAYPAUSEWIDTH		 0.425
#define ESS_SIRIREMOTE_PLAYPAUSE_PLAYWIDTHHEIGHT	 0.200
#define ESS_SIRIREMOTE_PLAYPAUSE_PAUSEWIDTH			 0.040
#define ESS_SIRIREMOTE_PLAYPAUSE_DISTANCE			 0.075

#define ESS_SIRIREMOTE_VOLUME_PLUSMINUS_WIDTH		 0.330
#define ESS_SIRIREMOTE_VOLUME_PLUSMINUS_X			 0.400 //in relation to volumeupdown button
#define ESS_SIRIREMOTE_VOLUME_MINUS_Y				 0.600 //in relation to volumeupdown button

#define ESS_SIRIREMOTE_SIRIINSET_WIDTH				 0.250
#define ESS_SIRIREMOTE_SIRIINSET_HEIGHT				 0.500
#define ESS_SIRIREMOTE_SIRIINSET_LOWLINE_WIDTH		 0.200
#define ESS_SIRIREMOTE_SIRIINSET_STANDLINE_HEIGHT	 0.100
#define ESS_SIRIREMOTE_SIRIINSET_MIC_WIDTH			 0.100
#define ESS_SIRIREMOTE_SIRIINSET_MIC_HEIGHT			 0.310
#define ESS_SIRIREMOTE_SIRIINSET_MIC_DISTANCE		 0.050

#define ESS_SIRIREMOTE_MICROPHONE_WIDTH				 0.240
#define ESS_SIRIREMOTE_MICROPHONE_HEIGHT			 0.100
#define ESS_SIRIREMOTE_MICROPHONE_Y					11.900




//ESSAppleTVSiriRemoteType2021 Constants, in cm
#define ESS_SIRIREMOTE2021_WIDTH					3.5
#define ESS_SIRIREMOTE2021_HEIGHT					13.6

#define ESS_SIRIREMOTE2021_BUTTON_WIDTHHEIGHT		1.15
#define ESS_SIRIREMOTE2021_VOLUME_HEIGHT			2.7

#define ESS_SIRIREMOTE2021_POWER_WIDTHHEIGHT		0.6

#define ESS_SIRIREMOTE2021_MICROPHONE_HEIGHT		0.05
#define ESS_SIRIREMOTE2021_MICROPHONE_WIDTH			0.2

#define ESS_SIRIREMOTE2021_TOUCHBUTTON_WIDTHHEIGHT	3.1

#define ESS_SIRIREMOTE2021_EMPTYSPACE_BOTTOMUP		4.9

#define ESS_SIRIREMOTE2021_ORDINARYBUTTON_DISTANCE_V	0.3
#define ESS_SIRIREMOTE2021_ORDINARYBUTTON_DISTANCE_H	0.3

#define ESS_SIRIREMOTE2021_TOUCHBUTTON_BOTTOMDISTANCE	0.1

#define ESS_SIRIREMOTE2021_TOUCHBUTTON_TOPDISTANCE		0.5
#define ESS_SIRIREMOTE2021_MICROPHONE_TOPDISTANCE		0.6

#define ESS_SIRIREMOTE2021_NONTOUCHBUTTON_INSET			0.4

#define ESS_SIRIREMOTE2021_TOUCHBUTTON_WHITEDOT_WH		0.1
#define ESS_SIRIREMOTE2021_TOUCHBUTTON_WHITEDOT_INSET	0.15

#define ESS_SIRIREMOTE2021_TOUCHBUTTON_OUTER_WIDTH		0.7
#define ESS_SIRIREMOTE2021_TOUCHBUTTON_INNER_WIDTH		1.7
























@interface ESSSiriRemoteView ()

@property (assign) NSRect remoteBorderRect;
@property (assign) NSPoint dividerLineStartPoint;
@property (assign) CGFloat dividerLineWidth;

@property (assign) NSRect menuButtonRect;

@property (strong) NSArray *currentTouchRects;

@end

@implementation ESSSiriRemoteView

@synthesize remoteType = remoteTypeInternal, primaryColor = primaryColorInternal, secondaryColor = secondaryColorInternal, fillColor = fillColorInternal;

- (void)viewWillDraw
{
	[super viewWillDraw];
	
	if (self.primaryColor == nil)
		self.primaryColor = [NSColor labelColor];
	if (self.secondaryColor == nil)
		self.secondaryColor = [NSColor secondaryLabelColor];
	if (self.fillColor == nil)
		self.fillColor = [NSColor clearColor];
}

- (void)setFillColor:(NSColor *)fill
		 primaryColor:(NSColor *)border
secondaryColor:(NSColor *)secondary
{
	if (fill == nil)
		fill = [NSColor clearColor];
	if (border == nil)
		border = [NSColor labelColor];
	if (secondary == nil)
		secondary = [NSColor secondaryLabelColor];
	
	BOOL redraw = NO;
	if (fill != self.fillColor)
	{
		redraw = YES;
		self.fillColor = fill;
	}
	if (border != self.primaryColor)
	{
		redraw = YES;
		self.primaryColor = border;
	}
	if (secondary != self.secondaryColor)
	{
		redraw = YES;
		self.secondaryColor = secondary;
	}
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
	if (self.remoteType < ESSAppleTVRemoteType4k_2021)
	{
		//calculate remote border rect
		CGFloat height = self.bounds.size.height;
		CGFloat width = height/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_WIDTH);
		if (width > self.bounds.size.width)
		{
			width = self.bounds.size.width;
			height = width*(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_WIDTH);
		}
		self.remoteBorderRect = NSMakeRect((self.bounds.size.width-width)/2.0,
										   (self.bounds.size.height-height)/2.0,
										   width,
										   height);
		
		//calculate touch area divider x and y
		self.dividerLineStartPoint = NSMakePoint(NSMinX(self.remoteBorderRect),
												 NSMinY(self.remoteBorderRect)+NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_TOUCHAREA_Y));
		self.dividerLineWidth = NSWidth(self.remoteBorderRect);
		
		CGFloat menuX = NSMinX(self.remoteBorderRect)+NSWidth(self.remoteBorderRect)/(ESS_SIRIREMOTE_WIDTH/ESS_SIRIREMOTE_BUTTON_X);
		CGFloat menuY = NSMinY(self.remoteBorderRect)+NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_TOPBUTTONS_Y);
		CGFloat buttonWidth = NSWidth(self.remoteBorderRect)/(ESS_SIRIREMOTE_WIDTH/ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT);
		CGFloat buttonHeight = NSWidth(self.remoteBorderRect)/(ESS_SIRIREMOTE_WIDTH/ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT);
		self.menuButtonRect = NSMakeRect(menuX, menuY, buttonWidth, buttonHeight);
		
		//draw limiter line btw touch- and not touch area
		[self.secondaryColor set];
		NSBezierPath *bp = [NSBezierPath bezierPath];
		[bp moveToPoint:self.dividerLineStartPoint];
		[bp lineToPoint:NSMakePoint(self.dividerLineStartPoint.x+NSWidth(self.remoteBorderRect),
									self.dividerLineStartPoint.y)];
		[bp stroke];
		
		[self.primaryColor set];
		//draw remote border
		bp = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.remoteBorderRect, 0.5, 0.5)
											 xRadius:NSWidth(self.remoteBorderRect)/8.0
											 yRadius:NSWidth(self.remoteBorderRect)/8.0];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[self.fillColor setFill];
		[bp fill];
		[bp stroke];
		
		//draw microphone
		CGFloat micWidth = NSWidth(self.remoteBorderRect)/(ESS_SIRIREMOTE_WIDTH/ESS_SIRIREMOTE_MICROPHONE_WIDTH);
		CGFloat micHeight = NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_MICROPHONE_HEIGHT);
		CGFloat micY = self.remoteBorderRect.origin.y+NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_MICROPHONE_Y);
		CGFloat micX = self.remoteBorderRect.origin.x+((NSWidth(self.remoteBorderRect)-micWidth)/2);
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(micX,micY, micWidth, micHeight)
											 xRadius:micWidth/4.0
											 yRadius:micHeight/2.0];
		bp.flatness = 0.0;
		[bp stroke];
		
		[self.primaryColor set];
		//draw menu button
		menuX = NSMinX(self.remoteBorderRect)+NSWidth(self.remoteBorderRect)/(ESS_SIRIREMOTE_WIDTH/ESS_SIRIREMOTE_BUTTON_X);
		menuY = NSMinY(self.remoteBorderRect)+NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_TOPBUTTONS_Y);
		buttonWidth = NSWidth(self.remoteBorderRect)/(ESS_SIRIREMOTE_WIDTH/ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT);
		buttonHeight = NSWidth(self.remoteBorderRect)/(ESS_SIRIREMOTE_WIDTH/ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT);
		CGFloat fontSize = (buttonHeight/4);
		bp = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(menuX,
															   menuY,
															   buttonWidth,
															   buttonHeight)];
		bp.flatness = 0.0;
		if (self.remoteType == ESSAppleTVSiriRemoteType1080p)
			bp.lineWidth = 1.0;
		if (self.remoteType == 	ESSAppleTVSiriRemoteType4k)
			bp.lineWidth = 3.0;
		[bp stroke];
		
		CGFloat pauseLineWidth = (buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_PLAYPAUSE_PAUSEWIDTH));
		
		//draw MENU string on menu button
		NSString *menuTitle = @"MENU";
		NSMutableParagraphStyle *st = [[NSMutableParagraphStyle alloc] init];
		st.alignment = NSTextAlignmentCenter;
		NSDictionary *textAtts = @{NSFontAttributeName:[NSFont systemFontOfSize:fontSize weight:0.2],
								   NSForegroundColorAttributeName:self.primaryColor,
								   NSParagraphStyleAttributeName:st};
		/*[menuTitle drawInRect:NSMakeRect(menuX,
		 menuY - ((buttonHeight-fontSize)/2.3),
		 buttonWidth,
		 buttonHeight)
		 withAttributes:textAtts];*/
		NSSize stringSize = [menuTitle sizeWithAttributes:textAtts];
		CGFloat stringX = menuX+((buttonWidth-stringSize.width)/2);
		CGFloat stringY = menuY+((buttonHeight-stringSize.height)/2)-0.5;
		[menuTitle drawAtPoint:NSMakePoint(stringX, stringY) withAttributes:textAtts];
		
		//draw home button
		CGFloat homeButtonX = NSMinX(self.remoteBorderRect)+(NSWidth(self.remoteBorderRect)-((menuX-NSMinX(self.remoteBorderRect))+buttonWidth));
		bp = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(homeButtonX,
															   menuY,
															   buttonWidth,
															   buttonHeight)];
		bp.flatness = 0.0;
		[bp stroke];
		//draw home button icon
		CGFloat hbImgWidth = buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_HOMEBUTTON_IMAGEWIDTH);
		CGFloat hbImgHeight = buttonHeight/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_HOMEBUTTON_IMAGEHEIGHT);
		CGFloat hbImgX = homeButtonX+((buttonWidth/2.0)-(hbImgWidth/2.0));
		CGFloat hbImgY = menuY+((buttonHeight/2.0)-(hbImgHeight/2.0));
		bp = [NSBezierPath bezierPathWithRect:NSMakeRect(hbImgX,
														 hbImgY,
														 hbImgWidth,
														 hbImgHeight)];
		bp.flatness = 0.0;
		bp.lineWidth = pauseLineWidth;
		[bp stroke];
		//draw home button icon's second part
		bp = [NSBezierPath bezierPath];
		[bp moveToPoint:NSMakePoint(hbImgX+(hbImgWidth/4.0),
									hbImgY-(buttonHeight/22.0))];
		[bp lineToPoint:NSMakePoint(hbImgX+(hbImgWidth/4.0)+(hbImgWidth/2.0),
									hbImgY-(buttonHeight/22.0))];
		bp.lineWidth = pauseLineWidth;
		bp.flatness = 0.0;
		[bp stroke];
		
		//draw siri button
		CGFloat siriButtonX = NSMinX(self.remoteBorderRect)+(menuX-NSMinX(self.remoteBorderRect));
		CGFloat siriButtonY = NSMinY(self.remoteBorderRect)+NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_MIDDLEBUTTON_Y);
		bp = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(siriButtonX,
															   siriButtonY,
															   buttonWidth,
															   buttonHeight)];
		bp.flatness = 0.0;
		[bp stroke];
		
		//draw siri inset
		CGFloat siriInsetWidth = buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_SIRIINSET_WIDTH);
		CGFloat siriInsetHeight = buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_SIRIINSET_HEIGHT);
		CGFloat siriInsetX = siriButtonX+((buttonWidth-siriInsetWidth)/2);
		CGFloat siriInsetY = siriButtonY+((buttonWidth-siriInsetHeight)/2);
		CGFloat siriInsetLowlineWidth = buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_SIRIINSET_LOWLINE_WIDTH);
		CGFloat siriInsetLowlineX = siriInsetX+((siriInsetWidth-siriInsetLowlineWidth)/2.0);
		bp = [NSBezierPath bezierPath];
		[bp moveToPoint:NSMakePoint(siriInsetLowlineX,
									siriInsetY)];
		[bp lineToPoint:NSMakePoint(siriInsetLowlineX+siriInsetLowlineWidth,
									siriInsetY)];
		bp.flatness = 0.0;
		bp.lineWidth = pauseLineWidth;
		bp.lineCapStyle = NSRoundLineCapStyle;
		[bp stroke];
		
		bp = [NSBezierPath bezierPath];
		CGFloat siriInsetStandHeight = buttonHeight/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_SIRIINSET_STANDLINE_HEIGHT);
		CGFloat siriInsetStandX = siriInsetLowlineX+((siriInsetLowlineWidth)/2);
		[bp moveToPoint:NSMakePoint(siriInsetStandX,
									siriInsetY)];
		[bp lineToPoint:NSMakePoint(siriInsetLowlineX+((siriInsetLowlineWidth)/2),
									siriInsetY+siriInsetStandHeight)];
		bp.lineWidth = pauseLineWidth;
		bp.flatness = 0.0;
		bp.lineCapStyle = NSRoundLineCapStyle;
		[bp stroke];
		
		CGFloat siriMicWidth = buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_SIRIINSET_MIC_WIDTH);
		CGFloat siriMicHeight = buttonHeight/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_SIRIINSET_MIC_HEIGHT);
		CGFloat siriMicDistance = buttonHeight/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_SIRIINSET_MIC_DISTANCE);
		CGFloat siriMicX = siriInsetStandX-(siriMicWidth/2.0);
		CGFloat siriMicY = siriInsetY+siriInsetHeight-siriMicHeight;//siriInsetStandHeight+micDistance;
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(siriMicX,
																siriMicY,
																siriMicWidth,
																siriMicHeight)
											 xRadius:siriMicWidth
											 yRadius:siriMicWidth/2.0];
		[bp fill];
		bp.flatness = 0.0;
		[bp stroke];
		
		bp = [NSBezierPath bezierPath];
		bp.flatness = 0.0;
		[bp moveToPoint:NSMakePoint(siriInsetX, siriInsetY+(siriInsetHeight/1.5))];
		[bp curveToPoint:NSMakePoint(siriInsetX+siriInsetWidth,
									 siriInsetY+(siriInsetHeight/1.5))
		   controlPoint1:NSMakePoint(siriInsetX, siriInsetY+siriInsetStandHeight-siriMicDistance)
		   controlPoint2:NSMakePoint(siriInsetX+siriInsetWidth, siriInsetY+siriInsetStandHeight-siriMicDistance)];
		//[bp curveToPoint:NSMakePoint(100, 0) controlPoint1:NSMakePoint(0, 100) controlPoint2:NSMakePoint(100, 100)];
		bp.lineWidth = pauseLineWidth;
		[bp stroke];
		
		
		//draw playpause button
		CGFloat playPauseX = NSMinX(self.remoteBorderRect)+(menuX-NSMinX(self.remoteBorderRect));
		CGFloat playPauseY = NSMinY(self.remoteBorderRect)+NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_BOTTOMBUTTON_Y);
		bp = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(playPauseX,
															   playPauseY,
															   buttonWidth,
															   buttonHeight)];
		bp.flatness = 0.0;
		[bp stroke];
		
		//draw playinsert
		bp = [NSBezierPath bezierPath];
		CGFloat playPauseInsertWidth = (buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_PLAYPAUSE_PLAYPAUSEWIDTH));
		CGFloat playInsertWidth = (buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_PLAYPAUSE_PLAYWIDTHHEIGHT));
		CGFloat playInsertHeight = (buttonHeight/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_PLAYPAUSE_PLAYWIDTHHEIGHT));
		CGFloat playInsertX = playPauseX+((buttonWidth-playPauseInsertWidth)/2);
		CGFloat playInsertY = playPauseY+((buttonHeight-playInsertHeight)/2);
		[bp moveToPoint:NSMakePoint(playInsertX,
									playInsertY)];
		[bp lineToPoint:NSMakePoint(playInsertX,
									playInsertY+playInsertHeight)];
		[bp lineToPoint:NSMakePoint(playInsertX+playInsertWidth,
									playInsertY+(playInsertHeight/2.0))];
		[bp lineToPoint:NSMakePoint(playInsertX,
									playInsertY)];
		[bp fill];
		bp.flatness = 0.0;
		[bp stroke];
		
		//draw pause insert
		bp = [NSBezierPath bezierPath];
		CGFloat distance = (buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_PLAYPAUSE_DISTANCE));
		[bp moveToPoint:NSMakePoint(playInsertX+playInsertWidth+distance,
									playInsertY)];
		[bp lineToPoint:NSMakePoint(playInsertX+playInsertWidth+distance,
									playInsertY+playInsertHeight)];
		bp.lineWidth = pauseLineWidth;
		bp.lineCapStyle = NSRoundLineCapStyle;
		bp.flatness = 0.0;
		[bp stroke];
		
		bp = [NSBezierPath bezierPath];
		[bp moveToPoint:NSMakePoint(playInsertX+playInsertWidth+distance+pauseLineWidth+distance,
									playInsertY)];
		[bp lineToPoint:NSMakePoint(playInsertX+playInsertWidth+distance+pauseLineWidth+distance,
									playInsertY+playInsertHeight)];
		bp.lineWidth = pauseLineWidth;
		bp.lineCapStyle = NSRoundLineCapStyle;
		bp.flatness = 0.0;
		[bp stroke];
		
		//draw volupdownbtn
		CGFloat vlBtnX = homeButtonX;
		CGFloat vlBtnY = NSMinY(self.remoteBorderRect)+NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_BOTTOMBUTTON_Y);
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(vlBtnX,
																vlBtnY,
																buttonWidth,
																((NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_MIDDLEBUTTON_Y))-(NSHeight(self.remoteBorderRect)/(ESS_SIRIREMOTE_HEIGHT/ESS_SIRIREMOTE_BOTTOMBUTTON_Y)))+buttonHeight)
											 xRadius:buttonWidth
											 yRadius:buttonWidth/2];
		bp.flatness = 0.0;
		[bp stroke];
		
		//draw volupdwnbtn minus insert
		bp = [NSBezierPath bezierPath];
		CGFloat minusWidth = (buttonWidth/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_VOLUME_PLUSMINUS_WIDTH));
		CGFloat minusX = vlBtnX+((buttonWidth-minusWidth)/2);
		CGFloat minusY = vlBtnY+(buttonHeight/(ESS_SIRIREMOTE_BUTTON_WIDTHANDHEIGHT/ESS_SIRIREMOTE_VOLUME_MINUS_Y));
		[bp moveToPoint:NSMakePoint(minusX,
									minusY)];
		[bp lineToPoint:NSMakePoint(minusX+minusWidth,
									minusY)];
		bp.lineWidth = pauseLineWidth;
		bp.lineCapStyle = NSRoundLineCapStyle;
		bp.flatness = 0.0;
		[bp stroke];
		
		//draw volupdwnbtn plus insert
		bp = [NSBezierPath bezierPath];
		[bp moveToPoint:NSMakePoint(minusX,
									siriButtonY+((buttonWidth)/2))];
		[bp lineToPoint:NSMakePoint(minusX+minusWidth,
									siriButtonY+((buttonWidth)/2))];
		bp.flatness = 0.0;
		bp.lineWidth = pauseLineWidth;
		bp.lineCapStyle = NSRoundLineCapStyle;
		[bp stroke];
		
		bp = [NSBezierPath bezierPath];
		bp.lineWidth = pauseLineWidth;
		bp.lineCapStyle = NSRoundLineCapStyle;
		[bp moveToPoint:NSMakePoint(minusX+((minusWidth)/2),
									siriButtonY+((buttonWidth-minusWidth)/2))];
		[bp lineToPoint:NSMakePoint(minusX+((minusWidth)/2),
									siriButtonY+((buttonWidth-minusWidth)/2)+minusWidth)];
		bp.flatness = 0.0;
		[bp stroke];
		
		[[NSColor redColor] set];
		[[NSColor redColor] setFill];
		for (NSValue *rectVal in self.currentTouchRects)
		{
			NSRect rect = rectVal.rectValue;
			
			NSBezierPath *bp1 = [NSBezierPath bezierPathWithOvalInRect:rect];
			[bp1 fill];
			[bp1 stroke];
		}
	} else if (self.remoteType == ESSAppleTVRemoteType4k_2021)
	{
		CGFloat remoteRatio = ESS_SIRIREMOTE2021_HEIGHT / ESS_SIRIREMOTE2021_WIDTH;
		
		CGFloat remoteHeight = self.frame.size.height;
		CGFloat remoteWidth = remoteHeight/remoteRatio;
		if (remoteWidth > self.frame.size.width)
		{
			remoteWidth = self.frame.size.width;
			remoteHeight = remoteRatio*remoteWidth;
		}
		
		CGFloat widthToWidthRatio = ESS_SIRIREMOTE2021_WIDTH / remoteWidth;
		CGFloat heightToHeightRatio = ESS_SIRIREMOTE2021_HEIGHT / remoteHeight;
		
		//draw remote border
		[self.primaryColor set];
		
		CGFloat remoteX = (self.frame.size.width/2.0)-(remoteWidth/2.0);
		CGFloat remoteY = (self.frame.size.height/2.0)-(remoteHeight/2.0);
		
		NSBezierPath *bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(remoteX+0.5,
																			  remoteY+0.5,
																			  remoteWidth-1,
																			  remoteHeight-1)
														   xRadius:(remoteWidth/6)
														   yRadius:(remoteWidth/6)];
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw microphone
		CGFloat micWidth = ESS_SIRIREMOTE2021_MICROPHONE_WIDTH/widthToWidthRatio;
		CGFloat micHeight = ESS_SIRIREMOTE2021_MICROPHONE_HEIGHT/heightToHeightRatio;
		CGFloat micYFromTop = ESS_SIRIREMOTE2021_MICROPHONE_TOPDISTANCE/heightToHeightRatio;
		CGFloat micY = remoteY + (remoteHeight-(micYFromTop+micHeight));
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(remoteX + ((remoteWidth/2.0)-(micWidth/2.0)),
																micY,
																micWidth,
																micHeight)
											 xRadius:micHeight/2.0
											 yRadius:micHeight/2.0];
		[self.primaryColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw power btn
		CGFloat pbtnWidthHeight = ESS_SIRIREMOTE2021_POWER_WIDTHHEIGHT/widthToWidthRatio;
		CGFloat pbtnY = (micY + (micHeight/2.0)) - (pbtnWidthHeight/2.0);
		CGFloat pbtnX = (remoteX + remoteWidth) - ((ESS_SIRIREMOTE2021_NONTOUCHBUTTON_INSET/widthToWidthRatio) + pbtnWidthHeight);
		NSRect powerBtnRect = NSMakeRect(pbtnX,
										 pbtnY,
										 pbtnWidthHeight,
										 pbtnWidthHeight);
		
		bp = [NSBezierPath bezierPathWithRoundedRect:powerBtnRect
											 xRadius:pbtnWidthHeight/2.0
											 yRadius:pbtnWidthHeight/2.0];
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw power icon
		NSImage *helperImage = nil;
		if (@available(macOS 11.0, *))
		{
			helperImage = [NSImage imageWithSystemSymbolName:@"power" accessibilityDescription:nil];
			NSImageSymbolConfiguration *conf = [NSImageSymbolConfiguration configurationWithPointSize:pbtnWidthHeight weight:NSFontWeightRegular];
			helperImage = [helperImage imageWithSymbolConfiguration:conf].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
		} else
		{
			helperImage = [NSImage imageWithSize:powerBtnRect.size flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
				[self.primaryColor set];
				
				NSRect realDstRect = NSInsetRect(dstRect, dstRect.size.width/16.0, dstRect.size.height/16.0);
				//draw outer circle
				NSBezierPath *pb = [NSBezierPath bezierPathWithOvalInRect:realDstRect];
				bp.lineWidth = 1.0;
				bp.flatness = 0.0;
				[pb stroke];
				pb = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(realDstRect, 1.0, 1.0)];
				bp.lineWidth = 1.0;
				bp.flatness = 0.0;
				[pb stroke];
				pb = [NSBezierPath bezierPathWithOvalInRect:NSInsetRect(realDstRect, 2.0, 2.0)];
				bp.lineWidth = 1.0;
				bp.flatness = 0.0;
				[pb stroke];
				
				//block out the middle part for the line
				[[NSColor whiteColor] set];
				NSCompositingOperation op = [[NSGraphicsContext currentContext] compositingOperation];
				[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationDestinationOut];
				[NSBezierPath fillRect:NSMakeRect(realDstRect.origin.x + (realDstRect.size.width/5.0),
												  realDstRect.origin.y + (realDstRect.size.height-(realDstRect.size.height/3.0)),
												  realDstRect.size.width - ((realDstRect.size.width/5.0)*2),
												  realDstRect.size.height)];
				[[NSGraphicsContext currentContext] setCompositingOperation:op];
				
				//draw the line
				[self.primaryColor set];
				NSRect lineRect = NSMakeRect(realDstRect.origin.x + ((realDstRect.size.width/2.0) - 1.0),
											 realDstRect.origin.y + (realDstRect.size.height - (realDstRect.size.height/2.0)),
											 2.0,
											 realDstRect.size.height/2.0);
				pb = [NSBezierPath bezierPathWithRoundedRect:lineRect xRadius:lineRect.size.width yRadius:lineRect.size.height/4.5];
				[pb fill];
				[pb stroke];
				
				return YES;
			}];
		}
		[helperImage drawInRect:NSInsetRect(powerBtnRect, powerBtnRect.size.width/4.3, powerBtnRect.size.height/4.3) fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
		
		//draw outer touch area
		CGFloat otWidthHeight = ESS_SIRIREMOTE2021_TOUCHBUTTON_WIDTHHEIGHT/widthToWidthRatio;
		CGFloat otY = (micY - ((ESS_SIRIREMOTE2021_TOUCHBUTTON_TOPDISTANCE/heightToHeightRatio) + otWidthHeight));
		CGFloat otX = (remoteX + (remoteWidth/2.0)) - (otWidthHeight/2.0);
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(otX, otY, otWidthHeight, otWidthHeight)
											 xRadius:otWidthHeight/2.0
											 yRadius:otWidthHeight/2.0];
		
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw outer touch area dots
		CGFloat dotWH = ESS_SIRIREMOTE2021_TOUCHBUTTON_WHITEDOT_WH/widthToWidthRatio;
		CGFloat dotInsetV = ESS_SIRIREMOTE2021_TOUCHBUTTON_WHITEDOT_INSET/heightToHeightRatio;
		CGFloat dotInsetH = ESS_SIRIREMOTE2021_TOUCHBUTTON_WHITEDOT_INSET/widthToWidthRatio;
		
		//top dot
		CGFloat dotX = otX + ((otWidthHeight/2.0) - (dotWH/2.0));
		CGFloat dotY = (otY + otWidthHeight) - (dotInsetV+dotWH);
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(dotX, dotY, dotWH, dotWH)
											 xRadius:dotWH/2.0
											 yRadius:dotWH/2.0];
		
		[self.primaryColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//left dot
		dotX = otX + dotInsetH;
		dotY = (otY + (otWidthHeight/2.0)) - (dotWH/2.0);
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(dotX, dotY, dotWH, dotWH)
											 xRadius:dotWH/2.0
											 yRadius:dotWH/2.0];
		
		[self.primaryColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//right dot
		dotX = otX + otWidthHeight - (dotInsetH+dotWH);
		dotY = (otY + (otWidthHeight/2.0)) - (dotWH/2.0);
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(dotX, dotY, dotWH, dotWH)
											 xRadius:dotWH/2.0
											 yRadius:dotWH/2.0];
		
		[self.primaryColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//bottom dot
		dotX = otX + ((otWidthHeight/2.0) - (dotWH/2.0));
		dotY = (otY + (dotInsetV));
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(dotX, dotY, dotWH, dotWH)
											 xRadius:dotWH/2.0
											 yRadius:dotWH/2.0];
		
		[self.primaryColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw inner touch area
		CGFloat itWidthHeight = ESS_SIRIREMOTE2021_TOUCHBUTTON_INNER_WIDTH/widthToWidthRatio;
		CGFloat itY = (otY + (otWidthHeight/2.0)) - (itWidthHeight/2.0);
		CGFloat itX = (remoteX + (remoteWidth/2.0)) - (itWidthHeight/2.0);
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(itX, itY, itWidthHeight, itWidthHeight)
											 xRadius:itWidthHeight/2.0
											 yRadius:itWidthHeight/2.0];
		
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw back button
		CGFloat bbwh = ESS_SIRIREMOTE2021_BUTTON_WIDTHHEIGHT/widthToWidthRatio;
		CGFloat bbX = remoteX + (ESS_SIRIREMOTE2021_NONTOUCHBUTTON_INSET/widthToWidthRatio);
		CGFloat bbY = otY - (bbwh + (ESS_SIRIREMOTE2021_TOUCHBUTTON_BOTTOMDISTANCE/heightToHeightRatio));
		
		NSRect bbRect = NSMakeRect(bbX, bbY, bbwh, bbwh);
		bp = [NSBezierPath bezierPathWithRoundedRect:bbRect
											 xRadius:bbwh/2.0
											 yRadius:bbwh/2.0];
		
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw back label
		helperImage = nil;
		if (@available(macOS 11.0, *))
		{
			helperImage = [NSImage imageWithSystemSymbolName:@"chevron.left" accessibilityDescription:nil];
			NSImageSymbolConfiguration *conf = [NSImageSymbolConfiguration configurationWithPointSize:bbwh/3.0 weight:NSFontWeightLight];
			helperImage = [helperImage imageWithSymbolConfiguration:conf].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
		} else
		{
			helperImage = [NSImage imageNamed:NSImageNameGoBackTemplate].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
			helperImage.size = NSMakeSize(bbwh/3.0, bbwh/3.0);
		}
		[helperImage drawInRect:NSMakeRect(bbRect.origin.x + ((bbRect.size.width / 2.0) - helperImage.size.width/2.0),
										   bbRect.origin.y + ((bbRect.size.height / 2.0) - helperImage.size.height/2.0),
										   helperImage.size.width,
										   helperImage.size.height) fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
		
		//draw home button
		CGFloat hbwh = ESS_SIRIREMOTE2021_BUTTON_WIDTHHEIGHT/widthToWidthRatio;
		CGFloat hbX = (remoteX + remoteWidth) - ((ESS_SIRIREMOTE2021_NONTOUCHBUTTON_INSET/widthToWidthRatio)+hbwh);
		CGFloat hbY = bbY;
		
		NSRect hbRect = NSMakeRect(hbX, hbY, hbwh, hbwh);
		bp = [NSBezierPath bezierPathWithRoundedRect:hbRect
											 xRadius:hbwh/2.0
											 yRadius:hbwh/2.0];
		
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw home label
		helperImage = nil;
		if (@available(macOS 11.0, *))
		{
			helperImage = [NSImage imageWithSystemSymbolName:@"tv" accessibilityDescription:nil];
			NSImageSymbolConfiguration *conf = [NSImageSymbolConfiguration configurationWithPointSize:hbwh/3.0 weight:NSFontWeightLight];
			helperImage = [helperImage imageWithSymbolConfiguration:conf].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
		} else
		{
			helperImage = [NSImage imageWithSize:NSMakeSize(hbwh/3.0, hbwh/4.0) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
				[self.primaryColor set];
				NSRect displayRect = NSMakeRect(0, dstRect.size.height/4.0, dstRect.size.width, dstRect.size.height-(dstRect.size.height/4.0));
				NSBezierPath *bp = [NSBezierPath bezierPathWithRoundedRect:displayRect xRadius:displayRect.size.width/8.0 yRadius:displayRect.size.height/8.0];
				bp.lineWidth = 2.0;
				[bp stroke];
				
				bp = [NSBezierPath bezierPathWithRect:NSMakeRect(dstRect.size.width/3.0, 0, dstRect.size.width/3.0, 1)];
				[bp fill];
				[bp stroke];
				return YES;
			}];
		}
		NSRect tvLabelRect = NSMakeRect(hbRect.origin.x + ((hbRect.size.width / 2.0) - helperImage.size.width/2.0),
										hbRect.origin.y + ((hbRect.size.height / 2.0) - helperImage.size.height/2.0),
										helperImage.size.width,
										helperImage.size.height);
		[helperImage drawInRect:tvLabelRect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
		
		//draw playpause button
		CGFloat pphw = ESS_SIRIREMOTE2021_BUTTON_WIDTHHEIGHT/widthToWidthRatio;
		CGFloat ppX = bbX;
		CGFloat ppY = bbY - ((ESS_SIRIREMOTE2021_ORDINARYBUTTON_DISTANCE_V/heightToHeightRatio)+pphw);
		
		NSRect ppRect = NSMakeRect(ppX, ppY, pphw, pphw);
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(ppX, ppY, pphw, pphw)
											 xRadius:pphw/2.0
											 yRadius:pphw/2.0];
		
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw playpause label
		helperImage = nil;
		if (@available(macOS 11.0, *))
		{
			helperImage = [NSImage imageWithSystemSymbolName:@"playpause" accessibilityDescription:nil];
			NSImageSymbolConfiguration *conf = [NSImageSymbolConfiguration configurationWithPointSize:pphw/3.0 weight:NSFontWeightLight];
			helperImage = [helperImage imageWithSymbolConfiguration:conf].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
		} else
		{
			helperImage = [NSImage imageNamed:NSImageNameTouchBarPlayPauseTemplate].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
			helperImage.size = NSMakeSize(pphw/3.0, pphw/3.0);
		}
		NSRect ppLabelRect = NSMakeRect(ppRect.origin.x + ((ppRect.size.width / 2.0) - helperImage.size.width/2.0),
										ppRect.origin.y + ((ppRect.size.height / 2.0) - helperImage.size.height/2.0),
										helperImage.size.width,
										helperImage.size.height);
		[helperImage drawInRect:ppLabelRect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
		
		//draw mute button
		CGFloat mbhw = ESS_SIRIREMOTE2021_BUTTON_WIDTHHEIGHT/widthToWidthRatio;
		CGFloat mbX = bbX;
		CGFloat mbY = ppY - ((ESS_SIRIREMOTE2021_ORDINARYBUTTON_DISTANCE_V/heightToHeightRatio)+mbhw);
		
		NSRect mbRect = NSMakeRect(mbX, mbY, mbhw, mbhw);
		bp = [NSBezierPath bezierPathWithRoundedRect:mbRect
											 xRadius:mbhw/2.0
											 yRadius:mbhw/2.0];
		
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw playpause label
		helperImage = nil;
		if (@available(macOS 11.0, *))
		{
			helperImage = [NSImage imageWithSystemSymbolName:@"speaker.slash" accessibilityDescription:nil];
			NSImageSymbolConfiguration *conf = [NSImageSymbolConfiguration configurationWithPointSize:mbhw/3.0 weight:NSFontWeightLight];
			helperImage = [helperImage imageWithSymbolConfiguration:conf].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
		} else
		{
			helperImage = [NSImage imageNamed:NSImageNameTouchBarAudioOutputMuteTemplate].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
			helperImage.size = NSMakeSize(mbhw/3.0, mbhw/3.0);
		}
		NSRect mLabelRect = NSMakeRect(mbRect.origin.x + ((mbRect.size.width / 2.0) - helperImage.size.width/2.0),
									   mbRect.origin.y + ((mbRect.size.height / 2.0) - helperImage.size.height/2.0),
									   helperImage.size.width,
									   helperImage.size.height);
		[helperImage drawInRect:mLabelRect fromRect:NSZeroRect operation:NSCompositingOperationSourceOver fraction:1.0];
		
		//draw volume button
		CGFloat volw = ESS_SIRIREMOTE2021_BUTTON_WIDTHHEIGHT/widthToWidthRatio;
		CGFloat volh = hbY - ((ESS_SIRIREMOTE2021_ORDINARYBUTTON_DISTANCE_V/heightToHeightRatio)+mbY);
		CGFloat volX = hbX;
		CGFloat volY = mbY;
		
		bp = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(volX, volY, volw, volh)
											 xRadius:volw
											 yRadius:volh/4.5];
		
		[self.fillColor setFill];
		bp.lineWidth = 1.0;
		bp.flatness = 0.0;
		[bp fill];
		[bp stroke];
		
		//draw volume + label
		helperImage = nil;
		if (@available(macOS 11.0, *))
		{
			helperImage = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
			NSImageSymbolConfiguration *conf = [NSImageSymbolConfiguration configurationWithPointSize:mbhw/3.0 weight:NSFontWeightLight];
			helperImage = [helperImage imageWithSymbolConfiguration:conf].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
		} else
		{
			helperImage = [NSImage imageWithSize:NSMakeSize(mbhw/3.0, mbhw/3.0) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
				[self.primaryColor set];
				//horizontal line
				NSBezierPath *bp = [NSBezierPath bezierPathWithRect:NSMakeRect(0, (dstRect.size.height/2.0) - 0.25, dstRect.size.width, 0.5)];
				bp.lineWidth = 1.0;
				[bp stroke];
				[bp fill];
				
				//vertical line
				bp = [NSBezierPath bezierPathWithRect:NSMakeRect((dstRect.size.width/2.0) - 0.25, 0, 0.5, dstRect.size.height)];
				bp.lineWidth = 1.0;
				[bp stroke];
				[bp fill];
				
				return YES;
			}];
		}
		[helperImage drawInRect:NSMakeRect(tvLabelRect.origin.x + ((tvLabelRect.size.width/2.0) - (helperImage.size.width/2.0)),
										   ppLabelRect.origin.y + ((ppLabelRect.size.height/2.0) - (helperImage.size.height/2.0)),
										   helperImage.size.width,
										   helperImage.size.height)
					   fromRect:NSZeroRect
					  operation:NSCompositingOperationSourceOver
					   fraction:1.0];
		
		//draw volume - label
		helperImage = nil;
		if (@available(macOS 11.0, *))
		{
			helperImage = [NSImage imageWithSystemSymbolName:@"minus" accessibilityDescription:nil];
			NSImageSymbolConfiguration *conf = [NSImageSymbolConfiguration configurationWithPointSize:mbhw/3.0 weight:NSFontWeightLight];
			helperImage = [helperImage imageWithSymbolConfiguration:conf].copy;
			helperImage.template = YES;
			[helperImage lockFocus];
			[[NSGraphicsContext currentContext] setCompositingOperation:NSCompositingOperationSourceIn];
			[self.primaryColor set];
			[NSBezierPath fillRect:NSMakeRect(0, 0, helperImage.size.width, helperImage.size.height)];
			[helperImage unlockFocus];
		} else
		{
			helperImage = [NSImage imageWithSize:NSMakeSize(mbhw/3.0, mbhw/3.0) flipped:NO drawingHandler:^BOOL(NSRect dstRect) {
				[self.primaryColor set];
				//horizontal line
				NSBezierPath *bp = [NSBezierPath bezierPathWithRect:NSMakeRect(0, (dstRect.size.height/2.0) - 0.25, dstRect.size.width, 0.5)];
				bp.lineWidth = 1.0;
				[bp stroke];
				[bp fill];
				
				return YES;
			}];
		}
		[helperImage drawInRect:NSMakeRect(tvLabelRect.origin.x + ((tvLabelRect.size.width/2.0) - (helperImage.size.width/2.0)),
										   mLabelRect.origin.y + ((mLabelRect.size.height/2.0) - (helperImage.size.height/2.0)),
										   helperImage.size.width,
										   helperImage.size.height)
					   fromRect:NSZeroRect
					  operation:NSCompositingOperationSourceOver
					   fraction:1.0];
	}
}

- (void)setRemoteType:(ESSAppleTVSiriRemoteType)type
{
	@synchronized (self) {
		remoteTypeInternal = type;
	}
	
	[self setNeedsDisplay:YES];
}

- (void)setPrimaryColor:(NSColor *)primaryColor
{
	@synchronized (self) {
		primaryColorInternal = primaryColor;
	}
	
	[self setNeedsDisplay:YES];
}

- (void)setFillColor:(NSColor *)fillColor
{
	@synchronized (self) {
		fillColorInternal = fillColor;
	}
	
	[self setNeedsDisplay:YES];
}

- (void)setSecondaryColor:(NSColor *)secondaryColor
{
	@synchronized (self) {
		secondaryColorInternal = secondaryColor;
	}
	
	[self setNeedsDisplay:YES];
}

@end
