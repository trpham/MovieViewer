//
//  MovieCell.h
//  MovieViewer
//
//  Created by nathan on 6/25/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *overviewLabel;

@end
