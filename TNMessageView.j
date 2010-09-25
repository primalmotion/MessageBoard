/*
 * TNMessageView.j
 *
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

@import <Foundation/Foundation.j>
@import <AppKit/AppKit.j>

/*! CPView that contains information to display chat information
*/
@implementation TNMessageView : CPView
{
    CPTextField             _fieldAuthor;
    CPTextField             _fieldTimestamp;
    LPMultiLineTextField    _fieldMessage;

    CPColor                 _bgColor;
    CPString                _author;
    CPString                _message;
    CPString                _subject;
    CPString                _timestamp;
}

/*! instanciate a TNMessageView
    @param anAuthor sender of the message
    @param aSubject subject of the message (not used)
    @param aMessage the content of the message
    @param aTimestamp the date of the message
    @param aColor a CPColor that will be used as background

    @return initialized view
*/
- (void)initWithFrame:aFrame
               author:(CPString)anAuthor
              subject:(CPString)aSubject
              message:(CPString)aMessage
            timestamp:(CPString)aTimestamp
      backgroundColor:(CPColor)aColor
{
    if (self = [super initWithFrame:aFrame])
    {
        _author     = anAuthor;
        _subject    = aSubject;
        _message    = aMessage;
        _timestamp  = aTimestamp;
        _bgColor    = aColor;

        [self setAutoresizingMask:CPViewWidthSizable];

        _fieldAuthor = [[CPTextField alloc] initWithFrame:CGRectMake(10,10, CGRectGetWidth(aFrame) - 10, 20)];
        [_fieldAuthor setFont:[CPFont boldSystemFontOfSize:12]];
        [_fieldAuthor setTextColor:[CPColor grayColor]];
        [_fieldAuthor setAutoresizingMask:CPViewWidthSizable];

        _fieldMessage = [[CPTextField alloc] initWithFrame:CGRectMake(10,30, CGRectGetWidth(aFrame) - 20, 50)];
        [_fieldMessage setAutoresizingMask:CPViewWidthSizable | CPViewHeightSizable];
        [_fieldMessage setLineBreakMode:CPLineBreakByWordWrapping];
        [_fieldMessage setAlignment:CPJustifiedTextAlignment];

        _fieldTimestamp = [[CPTextField alloc] initWithFrame:CGRectMake(CGRectGetWidth(aFrame) - 200, 10, 190, 20)];
        [_fieldTimestamp setAutoresizingMask:CPViewMinXMargin];
        [_fieldTimestamp setValue:[CPColor colorWithHexString:@"f2f0e4"] forThemeAttribute:@"text-shadow-color" inState:CPThemeStateNormal];
        [_fieldTimestamp setValue:[CPFont systemFontOfSize:9.0] forThemeAttribute:@"font" inState:CPThemeStateNormal];
        [_fieldTimestamp setValue:[CPColor colorWithHexString:@"808080"] forThemeAttribute:@"text-color" inState:CPThemeStateNormal];
        [_fieldTimestamp setAlignment:CPRightTextAlignment];

        [self addSubview:_fieldAuthor];
        [self addSubview:_fieldMessage];
        [self addSubview:_fieldTimestamp];

        [_fieldAuthor setStringValue:_author];
        [_fieldMessage setStringValue:_message];
        [_fieldTimestamp setStringValue:_timestamp];

        [self setBackgroundColor:_bgColor];

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
        messageHeight   = [_message sizeWithFont:[CPFont systemFontOfSize:12] inWidth:CGRectGetWidth(frame)].height,
        messageFrame    = [_fieldMessage frame];

    messageFrame.size.height = messageHeight + 10;
    frame.size.height =  messageFrame.size.height + 30;

    [self setFrame:frame];
    [_fieldMessage setFrame:messageFrame];
    [_fieldMessage setSelectable:YES];
}

@end
