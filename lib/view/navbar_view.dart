import 'package:elibrary/view/search_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../common/styles/app_colors.dart';
import 'history_view.dart';
import 'rented_view.dart';
import 'profile_view.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  List<Widget> _buildScreens() {
    return [
      const RentedView(),
      const SearchView(),
      const HistoryView(),
      const SearchView()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      _navBarItem(
        icon: CupertinoIcons.book,
        title: "Rented",
        screenIndex: 0,
      ),
      _navBarItem(
        icon: CupertinoIcons.search,
        title: "Search",
        screenIndex: 1,
      ),
      _navBarItem(
        icon: CupertinoIcons.book_solid,
        title: "History",
        screenIndex: 2,
      ),
      _navBarItem(
        icon: CupertinoIcons.profile_circled,
        title: "Profile",
        screenIndex: 3,
      ),
    ];
  }

  PersistentBottomNavBarItem _navBarItem({
    required IconData icon,
    required String title,
    required int screenIndex,
  }) {
    return PersistentBottomNavBarItem(
      icon: Icon(icon),
      inactiveIcon: Icon(icon, color: const Color(0xFF333333)),
      title: title,
      activeColorPrimary: AppColors.primaryColorLight,
      inactiveColorPrimary: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const Drawer(),
      endDrawer: Builder(
        builder: (context) {
          return const ProfileView();
        },
      ),
      body: PersistentTabView(
        context,
        navBarStyle: NavBarStyle.style14,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        hideNavigationBarWhenKeyboardAppears: true,
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
        isVisible: true,
        onItemSelected: (index) {
          if (index == 3) {
            _scaffoldKey.currentState?.openEndDrawer();
          } else {
            setState(() {
              selectedIndex = index;
            });
          }
        },
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            animateTabTransition: true,
            duration: Duration(milliseconds: 200),
            screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
          ),
        ),
      ),
    );
  }
}
