import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_app/screens/main/order/order_details_multi.dart';
import 'package:driver_app/screens/main/order/order_details_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:otlob/screens/sing_in.dart';
// import 'package:otlob/value/colors.dart';
// import 'package:otlob/widget/app_style_text.dart';
// import 'package:otlob/widget/row_edit_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timer_count_down/timer_count_down.dart';
// import 'package:latlong2/latlong.dart';

import '../../../value/colors.dart';
import '../../../widget/app_style_text.dart';
import '../../../widget/card_template_black.dart';
import '../../../widget/component.dart';
import '../../../widget/continer_list_details.dart';
import '../../../widget/continer_list_details_done.dart';
import '../../../widget/custom_image.dart';
import '../../Auth/sing_in.dart';

// import '../../widget/app_button.dart';
// import '../../widget/card_template.dart';
// import '../../widget/card_template_black.dart';
// import '../../widget/card_template_not.dart';
// import '../../widget/card_template_phone.dart';
// import '../../widget/custom_image.dart';
// import '../Auth/sing_in.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final TapGestureRecognizer _recognizer = TapGestureRecognizer()
    ..onTap = () => onTapRecognizer();
  bool isSwitched = true;

  // late StreamController<LocationMarkerPosition> positionStream;
  // late StreamSubscription<LocationMarkerPosition> streamSubscription;

  void onTapRecognizer() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SignIn()));
  }

  static const distanceFilters = [0, 5, 10, 30, 50];
  int _selectedIndex = 0;

  // Completer<GoogleMapController> _controller = Completer();

  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(37.42796133580664, -122.085749655962),
  //   zoom: 14.4746,
  // );

  // Set<Circle> circles = Set.from([Circle(
  //   circleId: CircleId('1'),
  //     fillColor: AppColors.appColor,
  //   center: LatLng(37.43296265331129, -122.08832357078792),
  //   radius: 4000,
  //
  // )]);
  // LatLng latLng = LatLng(31.524574924915523, 34.448129281505175);
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     tilt: 59.440717697143555,
  //     zoom: 19.151926040649414);
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final defaultPinTheme = PinTheme(
    width: 51.w,
    height: 51.h,
    textStyle: const TextStyle(
        fontSize: 20, color: AppColors.greyF, fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: AppColors.greyF,
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: AppColors.greyF,
      ),
    ),
  );

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState

    // positionStream = StreamController();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
    getCurrentLocation();
    super.initState();
    user = _auth.currentUser;
  }

  @override
  void dispose() {
    // positionStream.close();

    // TODO: implement dispose
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
    super.dispose();
  }

  final _auth = FirebaseAuth.instance;
  User? user;

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: AppColors.appColor
    // ));
    return Scaffold(
      backgroundColor: AppColors.greyA5,
      appBar: AppBar(
        leadingWidth: 200.w,
        toolbarHeight: 80.h,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        leading: Row(
          children: [
            SizedBox(
              width: 6.w,
            ),
            Container(
              height: 40.h,
              width: 40.w,
              padding: EdgeInsets.all(3.r),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle,
                  color: Colors.white),
              child: SizedBox(
                height: 28.h,
                width: 28.w,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80',
                    // buildContext: context,
                    // height: 72.h,
                    // width: 72.w,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => shimmerCarDes(context),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 6.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppTextStyle(
                  name: 'مرحباً، أحمد',
                  fontWeight: FontWeight.w900,
                  fontSize: 10.sp,
                ),
                SizedBox(
                  height: 6.h,
                ),
              ],
            ),
          ],
        ),
        // leading: MenuWidget(),
        actions: [
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
                print(isSwitched);
              });
            },
            activeTrackColor: AppColors.grey,
            activeColor: Colors.green,
          ),
          CustomSvgImage(
            imageName: 'notification',
            color: AppColors.white,
            width: 16.w,
            height: 17.h,
          ),
          SizedBox(
            width: 20.w,
          ),
        ],
        backgroundColor: AppColors.appColor,
        title: Text(''.tr),
      ),
      body: ListView(
        shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 0.h),
        children: [
          ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
            children: [
              SizedBox(
                height: 10.h,
              ),
              AppTextStyle(
                name: 'الطلبات الحالية',
                fontSize: 12.sp,
              ),
              SizedBox(
                height: 10.h,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                        height: 70.h,
                        decoration: BoxDecoration(
                          color: AppColors.greyF6,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ContainerListDetails(
                            visible: true,
                            mainImage:
                                'https://img.freepik.com/premium-vector/restaurant-logo-design-template_79169-56.jpg?w=2000',
                            secondImage:
                                'https://img.freepik.com/premium-vector/restaurant-logo-design-template_79169-56.jpg?w=2000',
                            mainTitle: index == 0
                                ? 'مطبخ الشام للفطائر الجاهزة '
                                : 'من عدة مطاعم',
                            time: 'يجب توصيله خلال 25 - 30 ',
                            space: '5.2',
                            rate: '22-05-2022   10:45 مساء',
                            mainGreen: 'التوصيل مجانا',
                            subGreen: 'لفترة محدودة',
                            mainYellow: '45',
                            subYellow: 'خصم على كل الطلبات',
                            map: 'أبو مازن السوري',
                            price: '78',
                            onPressed: () {
                              if (index == 0) {
                                Get.to(OrderDetailsOne());
                              } else {
                                Get.to(OrderDetailsMulti());
                              }
                            }));
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.h,
                    );
                  },
                  itemCount: 2),
              SizedBox(
                height: 10.h,
              ),
              AppTextStyle(
                name: 'الطلبات المكتملة',
                fontSize: 12.sp,
              ),
              SizedBox(
                height: 10.h,
              ),
              ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: AppColors.greyF6,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ContainerListDetailsDone(
                            visible: true,
                            mainImage:
                                'https://img.freepik.com/premium-vector/restaurant-logo-design-template_79169-56.jpg?w=2000',
                            secondImage:
                                'https://img.freepik.com/premium-vector/restaurant-logo-design-template_79169-56.jpg?w=2000',
                            mainTitle: index == 0
                                ? 'مطبخ الشام للفطائر الجاهزة '
                                : 'من عدة مطاعم',
                            time: 'يجب توصيله خلال 25 - 30 ',
                            space: '5.2',
                            rate: '22-05-2022   10:45 مساء',
                            mainGreen: 'التوصيل مجانا',
                            subGreen: 'لفترة محدودة',
                            mainYellow: '45',
                            subYellow: 'خصم على كل الطلبات',
                            map: 'أبو مازن السوري',
                            price: '78',
                            onPressed: () {}));
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 16.h,
                    );
                  },
                  itemCount: 3),
              SizedBox(
                height: 10.h,
              ),
              AppTextStyle(
                name: 'موقعي الحالي',
                fontSize: 12.sp,
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 122.h,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 122.h,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
                  child: currentLocation == null
                      ? const Center(child: Text("Loading"))
                      : GoogleMap(
                          myLocationEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                            zoom: 13.5,
                          ),
                          markers: {
                            Marker(
                              markerId: const MarkerId("currentLocation"),
                              position: LatLng(currentLocation!.latitude!,
                                  currentLocation!.longitude!),
                            ),
                            //  Marker(
                            //   markerId: MarkerId("source"),
                            //   position: latLng,
                            // ),
                            // const Marker(
                            //   markerId: MarkerId("destination"),
                            //   position: destination,
                            // ),
                          },
                          onMapCreated: (mapController) {
                            // _controller.complete(mapController); //  Marker(
                            //   markerId: MarkerId("source"),
                            //   position: latLng,
                            // ),
                            // const Marker(
                            //   markerId: MarkerId("destination"),
                            //   position: destination,
                            // ),
                          },
                        ),
                  // child: FlutterMap(

                  //   options: MapOptions(
                  //     center: latLng,
                  //     zoom: 14,
                  //     maxZoom: 26,
                  //     keepAlive: true,
                  //     plugins: [
                  //       LocationMarkerPlugin(), // <-- add plugin here
                  //     ],
                  //   ),
                  //   layers: [
                  //     TileLayerOptions(
                  //       urlTemplate:
                  //           'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  //       subdomains: ['a', 'b', 'c'],
                  //       userAgentPackageName:
                  //           'net.tlserver6y.flutter_map_location_marker.example',
                  //     ),
                  //     LocationMarkerLayerOptions(
                  //       positionStream: positionStream.stream,
                  //       marker: const DefaultLocationMarker(
                  //         color: Colors.green,
                  //         child: Icon(
                  //           Icons.person,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //       markerSize: const Size(40, 40),
                  //       accuracyCircleColor: Colors.green.withOpacity(0.1),
                  //       headingSectorColor: Colors.green.withOpacity(0.8),
                  //       headingSectorRadius: 120,
                  //       moveAnimationDuration: Duration.zero,
                  //     ),
                  //     // Align(
                  //     //     alignment: Alignment.bottomCenter,
                  //     //     child: Container(
                  //     //       color: Theme.of(context).scaffoldBackgroundColor,
                  //     //       padding: const EdgeInsets.all(8),
                  //     //       child: Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           const Text("Distance Filter:"),
                  //     //           ToggleButtons(
                  //     //             isSelected: List.generate(
                  //     //               distanceFilters.length,
                  //     //               (index) => index == _selectedIndex,
                  //     //               growable: false,
                  //     //             ),
                  //     //             onPressed: (index) {
                  //     //               setState(() => _selectedIndex = index);
                  //     //               streamSubscription.cancel();
                  //     //               _subscriptPositionStream();
                  //     //             },
                  //     //             children: distanceFilters
                  //     //                 .map(
                  //     //                     (distance) => Text(distance.toString()))
                  //     //                 .toList(growable: false),
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //     ))
                  //   ],
                  // ),
                ),
              ),
              CardTemplateBlack(
                prefix: 'maps',
                title: '25 شارع عبدالسلام النابلسي، الصفة الغربية',
                // colorFont: AppColors.black,
                controller: TextEditingController(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget shimmerCarDesA(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: AppColors.appColor,
    highlightColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[300], borderRadius: BorderRadius.circular(0)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    ),
  );
}
