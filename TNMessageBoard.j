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
@import "TNMessageView.j";
@import "TNStackView.j";

/*! Subclass of TNStackView that is specialized to stacks TNMessageViews
*/
@implementation TNMessageBoard : TNStackView
{
    CPArray     _messageDicts;
    CPArray     _messageViews;
}

/*! initialize the TNMessageBoard
    @param aFrame the frame
    @return new initialized TNMessageBoard
*/
- (id)initWithFrame:(CPRect)aFrame
{
    if(self = [super initWithFrame:aFrame])
    {
        _messageDicts   = [CPArray array];
        _messageViews   = [CPArray array];

        [self setDataSource:_messageViews];
    }

    return self;
}

/*! stack a new message
    @param aMessage the content of the message
    @param anAuthor sender of the message
    @param aColor a CPColor that will be used as background
    @param aDate the date of the message
*/
- (void)addMessage:(CPString)aMessage from:(CPString)anAuthor color:(CPColor)aColor date:(CPDate)aDate
{
    var messageView = [[TNMessageView alloc] initWithFrame:CPRectMake(0, 0, 100, 100)
                                                    author:anAuthor
                                                   subject:@"Subject"
                                                   message:aMessage
                                                 timestamp:aDate
                                           backgroundColor:aColor];

    [_messageViews addObject:messageView];

    [_messageDicts addObject:[CPDictionary dictionaryWithObjectsAndKeys:anAuthor, @"author", aMessage, @"message", aDate, @"date", aColor, @"color"]];

    [self reload];
}

/*! remove all message.
    I know it's useless because it's already in the superclass
    But I don't want to modifiy this in archipel.
    You should not use it and directly call removeAllViews
*/
- (IBAction)removeAllMessages:(id)aSender
{
    [self removeAllViews:aSender];
}

@end
