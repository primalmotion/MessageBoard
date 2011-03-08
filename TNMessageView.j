/*
 * TNMessageView.j
 *
 * Copyright (C) 2010  Antoine Mercadal <antoine.mercadal@inframonde.eu>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3.0 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>


TNMessageViewAvatarPositionRight    = @"TNMessageViewAvatarPositionRight";
TNMessageViewAvatarPositionLeft     = @"TNMessageViewAvatarPositionLeft";

TNMessageViewBubbleColorNormal      = @"TNMessageViewBubbleColorNormal";
TNMessageViewBubbleColorAlt         = @"TNMessageViewBubbleColorAlt";

/*! CPView that contains information to display chat information
*/
@implementation TNMessageView : CPView
{
    CPTextField             _fieldAuthor;
    CPTextField             _fieldTimestamp;
    LPMultiLineTextField    _fieldMessage;

    CPImageView             _imageViewAvatar;
    CPImage                 _imageDefaultAvatar;
    int                     _bgColor;
    CPString                _author;
    CPString                _message;
    CPString                _subject;
    CPString                _timestamp;
    CPView                  _viewContainer;
    int                     _position;
}

/*!
    compatibility
*/
- (void)initWithFrame:(CPRect)aFrame
               author:(CPString)anAuthor
              subject:(CPString)aSubject
              message:(CPString)aMessage
            timestamp:(CPString)aTimestamp
      backgroundColor:(CPColor)aColor
{
    return [self initWithFrame:aFrame
                   author:anAuthor
                  subject:aSubject
                  message:aMessage
                timestamp:aTimestamp
              bubbleColor:TNMessageViewBubbleColorNormal
                   avatar:nil
                 position:nil];
}

/*! instanciate a TNMessageView
    @param anAuthor sender of the message
    @param aSubject subject of the message (not used)
    @param aMessage the content of the message
    @param aTimestamp the date of the message
    @param aColor a CPColor that will be used as background
    @param anAvatar CPImage containg an avatar if nil, it will be the default one
    @return initialized view
*/
- (void)initWithFrame:(CPRect)aFrame
               author:(CPString)anAuthor
              subject:(CPString)aSubject
              message:(CPString)aMessage
            timestamp:(CPString)aTimestamp
          bubbleColor:(int)aColor
               avatar:(CPImage)anAvatar
              position:(int)position
{
    if (self = [super initWithFrame:aFrame])
    {
        _author     = anAuthor;
        _subject    = aSubject;
        _message    = aMessage;
        _timestamp  = aTimestamp;
        _bgColor    = aColor ? aColor : TNMessageViewBubbleColorNormal;

        [self setAutoresizingMask:CPViewWidthSizable];

        var bundle = [CPBundle bundleForClass:[self class]];

        _imageDefaultAvatar = anAvatar ? anAvatar : [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:@"user-unknown.png"] size:CPSizeMake(36, 36)];

        _position = position ? position : TNMessageViewAvatarPositionLeft;

        if (_position == TNMessageViewAvatarPositionLeft)
            _viewContainer = [[CPView alloc] initWithFrame:CGRectMake(50, 10, CGRectGetWidth(aFrame) - 60, 80)]
        else
            _viewContainer = [[CPView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(aFrame) - 60, 80)]
        [_viewContainer setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];


        if (_position == TNMessageViewAvatarPositionLeft)
        {
            _imageViewAvatar = [[CPImageView alloc] initWithFrame:CGRectMake(6, CGRectGetHeight(aFrame) - 46, 36, 36)];
            [_imageViewAvatar setAutoresizingMask:CPViewMinYMargin];
        }
        else
        {
            _imageViewAvatar = [[CPImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(aFrame) - 46, CGRectGetHeight(aFrame) - 46 , 36, 36)];
            [_imageViewAvatar setAutoresizingMask:CPViewMinXMargin | CPViewMinYMargin];
        }
        [_imageViewAvatar setImageScaling:CPScaleProportionally];

        [_imageViewAvatar setImage:_imageDefaultAvatar];

        var backgroundImage,
            backgroundFolder = (_bgColor == TNMessageViewBubbleColorNormal) ? @"Bubble" : @"BubbleAlt";
        if (_position == TNMessageViewAvatarPositionLeft)
            backgroundImage = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/1.png"] size:CPSizeMake(24.0, 14.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/2.png"] size:CPSizeMake(1.0, 14.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/3.png"] size:CPSizeMake(24.0, 14.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/4.png"] size:CPSizeMake(24.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/5.png"] size:CPSizeMake(1.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/6.png"] size:CPSizeMake(24.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/7.png"] size:CPSizeMake(24.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/8.png"] size:CPSizeMake(1.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/9.png"] size:CPSizeMake(24.0, 16.0)],
            ]]];
        else
            backgroundImage = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:[
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/1.png"] size:CPSizeMake(24.0, 14.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/2.png"] size:CPSizeMake(1.0, 14.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/3.png"] size:CPSizeMake(24.0, 14.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/4.png"] size:CPSizeMake(24.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/5.png"] size:CPSizeMake(1.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/6.png"] size:CPSizeMake(24.0, 1.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/7-alt.png"] size:CPSizeMake(24.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/8.png"] size:CPSizeMake(1.0, 16.0)],
                [[CPImage alloc] initWithContentsOfFile:[bundle pathForResource:backgroundFolder + @"/9-alt.png"] size:CPSizeMake(24.0, 16.0)],
            ]]];

        [_viewContainer setBackgroundColor:backgroundImage];

        _fieldAuthor = [[CPTextField alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth([_viewContainer frame]) - 30, 20)];
        [_fieldAuthor setFont:[CPFont boldSystemFontOfSize:12]];
        [_fieldAuthor setTextColor:[CPColor grayColor]];
        [_fieldAuthor setAutoresizingMask:CPViewWidthSizable];

        _fieldMessage = [[CPTextField alloc] initWithFrame:CGRectMake(20, 30, CGRectGetWidth([_viewContainer frame]) - 30 , CGRectGetHeight([_viewContainer frame]))];
        [_fieldMessage setAutoresizingMask:CPViewWidthSizable];
        [_fieldMessage setLineBreakMode:CPLineBreakByWordWrapping];
        [_fieldMessage setAlignment:CPJustifiedTextAlignment];

        _fieldTimestamp = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetWidth([_viewContainer frame]) - 210, 10, 190, 20)];
        [_fieldTimestamp setAutoresizingMask:CPViewMinXMargin];
        [_fieldTimestamp setValue:[CPColor colorWithHexString:@"f2f0e4"] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateNormal];
        [_fieldTimestamp setValue:[CPFont systemFontOfSize:9.0] forThemeAttribute:@"font" inState:CPThemeStateNormal];
        [_fieldTimestamp setValue:[CPColor colorWithHexString:@"808080"] forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
        [_fieldTimestamp setAlignment:CPRightTextAlignment];

        [_viewContainer addSubview:_fieldAuthor];
        [_viewContainer addSubview:_fieldMessage];
        [_viewContainer addSubview:_fieldTimestamp];
        [self addSubview:_imageViewAvatar];
        [self addSubview:_viewContainer];

        [_fieldAuthor setStringValue:_author];
        [_fieldMessage setStringValue:_message];
        [_fieldTimestamp setStringValue:_timestamp];

        [_fieldMessage setStringValue:_message];
    }

    return self;
}

/*! called by TNStackView. This will resize the content of the message's CPTextField in heigth
    according to it's size its own frame to display this field.
*/
- (void)layout
{
    var frame           = [self frame],
        messageHeight   = [_message sizeWithFont:[CPFont systemFontOfSize:12] inWidth:CGRectGetWidth([_fieldMessage frame])].height,
        messageFrame    = [_fieldMessage frame],
        containerFrame  = [_viewContainer frame];

    messageFrame.size.height = messageHeight + 10;
    frame.size.height =  containerFrame.origin.y + messageFrame.size.height + messageFrame.origin.y + 10;

    [self setFrame:frame];
    [_fieldMessage setFrame:messageFrame];
    [_fieldMessage setSelectable:YES];
}

@end
