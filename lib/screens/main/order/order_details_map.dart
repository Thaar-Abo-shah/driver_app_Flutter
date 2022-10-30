import 'dart:async';
import 'dart:developer' as dev;
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:driver_app/screens/main/order/order_details_accept_map.dart';
// import 'package:driver_app/screens/main/order/order_details_one.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:lottie/lottie.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// import 'package:otlob/screens/sing_in.dart';
// import 'package:otlob/value/colors.dart';
// import 'package:otlob/widget/app_style_text.dart';
// import 'package:otlob/widget/row_edit_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:shimmer/shimmer.dart';
// import 'package:timer_count_down/timer_count_down.dart';
// import 'package:latlong2/latlong.dart';

import '../../../value/colors.dart';
import '../../../widget/app_button.dart';
import '../../../widget/app_style_text.dart';
// import '../../../widget/card_template_black.dart';
// import '../../../widget/component.dart';
// import '../../../widget/continer_list_details.dart';
// import '../../../widget/continer_list_details_done.dart';
import '../../../widget/custom_image.dart';
import '../../../widget/order_map.dart';
import '../../Auth/sing_in.dart';

// import '../../widget/app_button.dart';
// import '../../widget/card_template.dart';
// import '../../widget/card_template_black.dart';
// import '../../widget/card_template_not.dart';
// import '../../widget/card_template_phone.dart';
// import '../../widget/custom_image.dart';
// import '../Auth/sing_in.dart';

class OrderDetailsMap extends StatefulWidget {
  const OrderDetailsMap({Key? key}) : super(key: key);

  @override
  State<OrderDetailsMap> createState() => _OrderDetailsMapState();
}

class _OrderDetailsMapState extends State<OrderDetailsMap> {
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

  final Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        setState(() {});
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

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyANw_x7f1lAyFlXaAq3xjQknsVo22AgleQ', // Your Google Map Key
      PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      PointLatLng(
          currentLocation!.latitude! - 0.01, currentLocation!.longitude!),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // positionStream = StreamController();

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
    getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  void dispose() {
    // positionStream.close();

    // TODO: implement dispose
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: AppColors.appColor));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //     statusBarColor: AppColors.appColor
    // ));

    // dev.log("###########################");
    // dev.log(currentLocation!.latitude!.toString());
    // dev.log(currentLocation!.longitude!.toString());
    return GlobalLoaderOverlay(
      textDirection: TextDirection.rtl,
      overlayColor: Colors.black,
      child: Scaffold(
        backgroundColor: AppColors.greyA5,
        appBar: AppBar(
          leadingWidth: 200.w,
          toolbarHeight: 50.h,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: TextButton.icon(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 25.r,
            ),
            label: AppTextStyle(
              name: 'رجوع',
              fontSize: 10.sp,
            ),
          ),
          // leading: MenuWidget(),
          actions: [
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
                Row(
                  children: [
                    AppTextStyle(
                      name: 'بيانات توصيل الطلبية',
                      fontSize: 12.sp,
                    ),
                    Spacer(),
                    AppTextStyle(
                      name: 'رقم الطلب',
                      fontSize: 8.sp,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    SizedBox(
                      width: 80.w,
                      child: AppButton(
                        fontSize: 10.sp,
                        title: '#2578921',
                        onPressed: () {},
                        color: AppColors.appColor,
                        height: 25.h,
                      ),
                    )
                  ],
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
                          child: OrderMapWi(
                            visible: true,
                            mainImage:
                                'https://img.freepik.com/premium-vector/restaurant-logo-design-template_79169-56.jpg?w=2000',
                            secondImage:
                                'https://img.freepik.com/premium-vector/restaurant-logo-design-template_79169-56.jpg?w=2000',
                            mainTitle: 'مطبخ الشام للفطائر الجاهزة ',
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
                              // Get.to(OrderDetailsOne());
                            },
                            onPressedAccept: () async {
                              context.loaderOverlay
                                  .show(widget: ReconnectingOverlay());

                              await Future.delayed(Duration(seconds: 5), () {
                                context.loaderOverlay.hide();
                              });

                              Get.to(OrderDetailsAccept(
                                isDone: false,
                              ));
                            },
                            onPressedCancel: () {},
                          ));
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 16.h,
                      );
                    },
                    itemCount: 1),
                SizedBox(
                  height: 28.h,
                ),
                SizedBox(
                  height: 460.h,
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
                              Marker(
                                markerId: MarkerId("source"),
                                position: LatLng(currentLocation!.latitude!,
                                    currentLocation!.longitude!),
                              ),
                              Marker(
                                markerId: MarkerId("destination"),
                                position: LatLng(
                                    currentLocation!.latitude! - 0.01,
                                    currentLocation!.longitude!),
                              ),
                            },
                            onMapCreated: (mapController) {
                              _controller.complete(mapController);
                              // //  Marker(
                              //   markerId: MarkerId("source"),
                              //   position: latLng,
                              // ),
                              // const Marker(
                              //   markerId: MarkerId("destination"),
                              //   position: destination,
                              // ),
                            },
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId("route"),
                                points: polylineCoordinates,
                                color: Colors.red,
                                width: 10,
                              ),
                            },
                          ),
                    // child: FlutterMap(
                    //   options: MapOptions(
                    //     center: latLng,
                    //     zoom: 18,
                    //     maxZoom: 26,
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
              ],
            ),
          ],
        ),
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

// class ReconnectingOverlay extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) => Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//                 height: 150.h,
//                 child: Lottie.network(
//                     'https://assets5.lottiefiles.com/packages/lf20_usmfx6bp.json')),
//             AppTextStyle(
//               textAlign: TextAlign.center,
//               fontSize: 15.sp,
//               height: 2,
//               name: '''برجاء الانتظار
// جاري تأكيد الطلب''',
//               color: Colors.white,
//             ),
//             // Text(
//             //
//             //   ' ... جاري التحميل',
//             // ),
//           ],
//         ),
//       );
// }
