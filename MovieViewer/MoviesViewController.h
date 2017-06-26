//
//  MoviesViewController.h
//  MovieViewer
//
//  Created by nathan on 6/24/17.
//  Copyright © 2017 Nathan Pham. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic) NSString* endpoint;
@property(nonatomic) NSArray* movies;
@property(nonatomic) NSArray* filteredMovies;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
