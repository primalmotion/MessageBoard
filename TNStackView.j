/*
 * TNStackView.j
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

/*! This class allows to create a view that can stack  different subviews.
    It will resize if in width to fill completely the view, but keeps the height
    It is also possible to set padding between views and reverse it.

    when the positionning of the view is done, it will call eventual selector [aStackedView layout]
    of each subviews. The subview can then, if needed adjust its height, it's content
    call it's mom or whatever
*/
@implementation TNStackView: CPView
{
    CPArray     dataSource     @accessors(property=dataSource);
    int         padding        @accessors(property=padding);
    BOOL        reversed       @accessors(getter=isReversed, setter=setReversed:);
    CPArray     stackedViews;
}

/*! initialize the TNStackView
    @param aFrame the frame
    @return a instancied TNStackView
*/
- (id)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        dataSource     = [CPArray array];
        stackedViews   = [CPArray array];
        padding        = 0;
        reversed       = NO;
        [self setAutoresizingMask:CPViewWidthSizable];
    }

    return self;
}

/*! @ignore
*/
- (CPRect)nextPosition
{
    var lastStackedView = [stackedViews lastObject],
        position;

    if (lastStackedView)
    {
        position = [lastStackedView frame];
        position.origin.y = position.origin.y + position.size.height + padding;
        position.origin.x = padding;
    }
    else
    {
        position = CGRectMake(padding, padding, [self bounds].size.width - (padding * 2), 0);
    }

    return position
}

/*! reload the content of the datasource
*/
- (void)reload
{
    var frame = [self frame];

    frame.size.height = 0;
    [self setFrame:frame];

    for (var i = 0; i < [dataSource count]; i++)
    {
        var view = [dataSource objectAtIndex:i];

        if ([view superview])
            [view removeFromSuperview];
    }

    [stackedViews removeAllObjects];
    [self layout];
}

/*! @position the different subviews in the daasource
*/
- (void)layout
{
    var stackViewFrame  = [self frame],
        workingArray    = reversed ? [dataSource copy].reverse() : dataSource;

    stackViewFrame.size.height = 0;

    for (var i = 0; i < [workingArray count]; i++)
    {
        var currentView = [workingArray objectAtIndex:i],
            position    = [self nextPosition];

        position.size.height = [currentView frameSize].height;
        [currentView setAutoresizingMask:CPViewWidthSizable];
        [currentView setFrame:position];

        if ([currentView respondsToSelector:@selector(layout)])
        {
            [currentView layout];
        }

        [self addSubview:currentView];
        [stackedViews addObject:currentView];

        stackViewFrame.size.height += [currentView frame].size.height + padding;
    }

    stackViewFrame.size.height += padding;
    [self setFrame:stackViewFrame];
}

/*! remove all items as an @action
*/
- (@action)removeAllViews:(id)aSender
{
    [dataSource removeAllObjects];

    [self reload];
}

/*! reverse the display of the view (but not in the Datasource) as an @action
*/
- (@action)reverse:(id)sender
{
    reversed = !reversed;

    [self reload];
}

@end
