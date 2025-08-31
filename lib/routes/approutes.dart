import 'package:chattingapp/views/authviews/loginview/loginview.dart';
import 'package:chattingapp/views/authviews/otpview/otpview.dart';
import 'package:chattingapp/views/authviews/profilesetupview/profilesetupview.dart';
import 'package:chattingapp/views/homeviews/homeview.dart';
import 'package:chattingapp/views/startingViews/loadingView/loadingview.dart';
import 'package:chattingapp/views/startingViews/onboardingView/onboardingview.dart';
import 'package:chattingapp/views/startingViews/splashView/splashview.dart';
import 'package:get/get.dart';


class AppRoutes {
  // Route names
  static String LoadingScreen = "/";
  static String SplashScreen = "/SplashView";
  static String OnboardingScreen = "/OnboardingView";
  static const String Login = '/LoginView';
  static const String OTP = '/OtpView';
  static const String ProfileSetup = '/ProfileSetupView';
  static const String Home = '/HomeView';
  // static const String ChatView = '/chatview';
  // static const String GroupChatView = '/groupchatview';
  // static const String ChatInfo = '/chatinfo';
  // static const String GroupChatInfo = '/groupchatinfo';

  // All routes
  static final routes = [
    GetPage(name: LoadingScreen, page: () => LoadingView()),
    GetPage(name: SplashScreen, page: () => SplashView()),
    GetPage(name: OnboardingScreen, page: () => OnboardingView()),
    GetPage(name: Login, page: () => LoginView()),
    GetPage(name: OTP, page: () => OtpView()),
    GetPage(name: ProfileSetup, page: () => ProfileSetupView()),
    GetPage(name: Home, page: () => HomeView()),
    // GetPage(
    //   name: ChatView,
    //   page: () {
    //     // Arguments: chatId, peerId, peerName, peerPhone
    //     final args = Get.arguments as Map<String, dynamic>;
    //     return ChatView(
    //       chatId: args['chatId'],
    //       peerId: args['peerId'],
    //       peerName: args['peerName'],
    //       peerPhone: args['peerPhone'],
    //     );
    //   },
    // ),
    // GetPage(
    //   name: GroupChatView,
    //   page: () {
    //     // Arguments: chatId, groupName, groupPhoto
    //     final args = Get.arguments as Map<String, dynamic>;
    //     return GroupChatView(
    //       chatId: args['chatId'],
    //       groupName: args['groupName'],
    //       groupPhoto: args['groupPhoto'],
    //     );
    //   },
    // ),
    // GetPage(
    //   name: ChatInfo,
    //   page: () {
    //     final args = Get.arguments as Map<String, dynamic>;
    //     return ChatInfoScreen(
    //       chatId: args['chatId'],
    //       peerId: args['peerId'],
    //       peerName: args['peerName'],
    //       peerPhone: args['peerPhone'],
    //     );
    //   },
    // ),
    // GetPage(
    //   name: GroupChatInfo,
    //   page: () {
    //     final args = Get.arguments as Map<String, dynamic>;
    //     return GroupChatInfoScreen(
    //       chatId: args['chatId'],
    //       groupName: args['groupName'],
    //       groupPhoto: args['groupPhoto'],
    //     );
    //   },
    // ),
  ];
}
