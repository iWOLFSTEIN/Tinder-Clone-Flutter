import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tinder_app_flutter/ui/screens/top_navigation_screens/profile_screen.dart';
import '../../data/model/top_navigation_item.dart';
import '../../util/constants.dart';
import 'top_navigation_screens/chats_screen.dart';
import 'top_navigation_screens/match_screen.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';

// class BottomNavigationScreen extends StatefulWidget {
//   const BottomNavigationScreen({Key? key}) : super(key: key);
//   static String id = 'navigaationScreenId';

//   @override
//   State<BottomNavigationScreen> createState() => _BottomBarScreenState();
// }

// class _BottomBarScreenState extends State<BottomNavigationScreen> {
//   final PageController controller = PageController(initialPage: 0);
//   var pageIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> buildScreens() {
//       return [MatchScreen(), ChatsScreen(), ProfileScreen()];
//     }

//     return SafeArea(
//         child: Scaffold(
//       backgroundColor: kPrimaryColor,
//       body: PageView(
//         physics: NeverScrollableScrollPhysics(),
//         controller: controller,
//         onPageChanged: (index) {
//           setState(() {
//             pageIndex = index;
//           });
//         },
//         children: buildScreens(),
//       ),
//       bottomNavigationBar: CustomNavigationBar(
//           backgroundColor: kPrimaryDark,
//           scaleFactor: 0.2,
//           scaleCurve: Curves.linear,
//           bubbleCurve: Curves.linear,
//           selectedColor: kSecondaryColor,
//           strokeColor: kPrimaryDark,
//           elevation: 16,
//           currentIndex: pageIndex,
//           onTap: (index) {
//             pageIndex = index;
//             controller.animateToPage(pageIndex,
//                 duration: const Duration(milliseconds: 100),
//                 curve: Curves.linearToEaseOut);
//           },
//           iconSize: 29,
//           items: [
//             CustomNavigationBarItem(
//                 icon: Icon(
//               Icons.favorite,
//               color: kSecondaryColor,
//             )),
//             CustomNavigationBarItem(
//                 icon: Icon(
//               Icons.email,
//               color: kSecondaryColor,
//             )),
//             CustomNavigationBarItem(
//                 icon: Icon(
//               Icons.person,
//               color: kSecondaryColor,
//             )),
//           ]),
//     ));
//   }
// }

class BottomNavigationScreen extends StatelessWidget {
  static const String id = 'top_navigation_screen';
  final List<TopNavigationItem> navigationItems = [
    TopNavigationItem(
      screen: MatchScreen(),
      image: "assets/asset/explore_icon.svg",
    ),
    TopNavigationItem(
      screen: ChatsScreen(),
      image: "assets/asset/chat_icon.svg",
    ),
    TopNavigationItem(
      screen: ProfileScreen(),
      image: "assets/asset/account_icon.svg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var tabBar = TabBar(
      tabs: navigationItems
          .map((navItem) => Container(
              height: double.infinity,
              child: Tab(
                icon: SvgPicture.asset(
                  navItem.image,
                  color: kSecondaryColor,
                ),
              )))
          .toList(),
    );

    var appBar = AppBar(
      flexibleSpace: tabBar,
      backgroundColor: kPrimaryColor.withOpacity(0.1),
      shadowColor: kPrimaryColor.withOpacity(0.1),
    );
    return DefaultTabController(
      length: navigationItems.length,
      child: SafeArea(
        child: Scaffold(
          appBar: appBar,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -
                  tabBar.preferredSize.height -
                  appBar.preferredSize.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                child: TabBarView(
                    children: navigationItems
                        .map((navItem) => navItem.screen)
                        .toList()),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
