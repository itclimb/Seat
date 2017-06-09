# Seat
### A demo about seats votes<br>
    Third-party libraries:`MBProgressHUD`,`MJExtension`<br>
    A category:`UIView+Extension`<br>
    [我的简书](http://www.jianshu.com/u/848ae424944b)<br>
The follow is result show:<br>
![](https://github.com/itclimb/Seat/raw/master/Seat/seat1.gif)<br>
The main structure is create some subViews in YCSeatSelectionView<br>
translate message though block<br>
```objective-C
[self initScrollView];
[self initAppLogo];
[self initSeatView:seatsModels];
[self initIndicator:seatsModels];
[self initRowIndexView:seatsModels];
[self initCenterLineView:seatsModels];
[self initHallLogoView:hallName];
[self startAnimation];
```
