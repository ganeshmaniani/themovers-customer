import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../config/config.dart';
import '../../../../../core/core.dart';
import '../../../tumpang/tumpang.dart';

class TumpangAddressScreen extends ConsumerStatefulWidget {
  const TumpangAddressScreen({super.key});

  @override
  ConsumerState<TumpangAddressScreen> createState() =>
      _TumpangAddressScreenConsumerState();
}

class _TumpangAddressScreenConsumerState
    extends ConsumerState<TumpangAddressScreen> {
  static CameraPosition _initialCameraPosition =
      const CameraPosition(target: LatLng(3.140853, 101.693207), zoom: 12);

  late GoogleMapController _controller;

  TumpangDirections directions = const TumpangDirections();
  bool isDirectionAvailable = true;
  bool isOn = false;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  void getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialCameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 12,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    final date = ref.watch(tumpangNotifierProvider).date;
    final time = ref.watch(tumpangNotifierProvider).time;

    final pickupAddress = ref.watch(tumpangNotifierProvider).pickupAddress;
    final dropOffAddress = ref.watch(tumpangNotifierProvider).dropOffAddress;

    final pickupGeometry = ref.watch(tumpangNotifierProvider).pickupGeometry;
    final dropOffGeometry = ref.watch(tumpangNotifierProvider).dropOffGeometry;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        // height: MediaQuery.of(context).size.height.h / 1.14.h,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            dateTimePicker(),
            Dimensions.kVerticalSpaceSmaller,
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10)),
                  border: Border.all(color: const Color(0x1AB30205))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchTextFormField(
                    locationIcon: AppIcon.pickupLocation,
                    onPressed: () => showAddressModelFunc('pickup'),
                    place: pickupAddress ?? 'Pickup Address',
                  ),
                  const Divider(
                      height: 0,
                      indent: 34,
                      endIndent: 16,
                      color: Color(0x1AB30205)),
                  const Divider(
                      height: 0,
                      indent: 34,
                      endIndent: 16,
                      color: Color(0x1AB30205)),
                  searchTextFormField(
                    locationIcon: AppIcon.dropLocation,
                    onPressed: () => showAddressModelFunc('drop_off'),
                    place: dropOffAddress ?? 'Drop off Address',
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 250,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialCameraPosition,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    markers: {
                      if (pickupGeometry != null)
                        Marker(
                          markerId: const MarkerId('origin'),
                          infoWindow: const InfoWindow(title: 'Origin'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                          position: pickupGeometry,
                        ),
                      if (dropOffGeometry != null)
                        Marker(
                          markerId: const MarkerId('destination'),
                          infoWindow: const InfoWindow(title: 'Destination'),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueRed),
                          position: dropOffGeometry,
                        )
                    },
                    polylines: {
                      if (!isDirectionAvailable)
                        Polyline(
                          polylineId: const PolylineId('overview_polyline'),
                          color: Colors.red,
                          width: 5,
                          points: directions.polylinePoints!
                              .map((e) => LatLng(e.latitude, e.longitude))
                              .toList(),
                        ),
                    },
                    onMapCreated: (GoogleMapController controller) =>
                        _controller = controller,
                  ),
                ],
              ),
            ),
            if (!isDirectionAvailable)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Color(0xFF1B293D),
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Distance / Travel Time',
                        style: context.textTheme.labelLarge!
                            .copyWith(color: Colors.white, fontSize: 12.sp)),
                    const Spacer(),
                    Text(
                      '${directions.totalDistance}/${directions.totalDuration}',
                      style: context.textTheme.labelLarge!.copyWith(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget dateTimePicker() {
    final textTheme = context.textTheme;
    final serviceDate = ref.watch(tumpangNotifierProvider).serviceDate;
    final serviceTime = ref.watch(tumpangNotifierProvider).serviceTime;
    int serviceType = ref.watch(tumpangNotifierProvider).serviceType ?? 1;

    return Container(
      padding: Dimensions.kPaddingAllMedium,
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tumpang Service',
            style:
                textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w400),
          ),
          Dimensions.kVerticalSpaceSmall,
          GestureDetector(
            onTap: () {
              if (serviceType == 1) {
                serviceType = 2;
                ref.read(tumpangNotifierProvider).setServiceType(serviceType);
              } else if (serviceType == 2) {
                serviceType = 1;
                ref.read(tumpangNotifierProvider).setServiceType(serviceType);
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xFFF7F7F7))),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6),
                        child: Opacity(
                          opacity: serviceType == 2 ? 1 : 0.50,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: Dimensions.kBorderRadiusAllSmallest,
                              border: Border.all(
                                width: 2,
                                color: serviceType == 2
                                    ? context.colorScheme.primary
                                    : const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: 1,
                          right: 1,
                          child: serviceType == 1
                              ? const SizedBox()
                              : Image(
                                  image: const AssetImage(AppIcon.checkMark),
                                  width: 24,
                                  color: context.colorScheme.primary,
                                )),
                    ],
                  ),
                  // serviceType == 1
                  //     ? SvgPicture.asset(AppIcon.check)
                  //     : SvgPicture.asset(AppIcon.checkIn),
                  Dimensions.kHorizontalSpaceSmaller,
                  Text(
                    'Anytime',
                    style: textTheme.labelLarge?.copyWith(
                        color: serviceType == 2
                            ? context.colorScheme.primary
                            : const Color(0xFF1B293D)),
                  ),
                ],
              ),
            ),
          ),
          Dimensions.kVerticalSpaceSmall,
          serviceType == 1
              ? Row(
                  children: [
                    Expanded(
                      child: DateTimePicker(
                        label: serviceDate != null
                            ? DateFormat('yyyy-MM-dd').format(serviceDate)
                            : 'Select Date',
                        icon: AppIcon.calender,
                        onTap: () async {
                          final date = await PickDateTime.date(context);
                          ref
                              .read(tumpangNotifierProvider)
                              .setServiceDate(date);
                        },
                        color: serviceDate != null ? false : true,
                      ),
                    ),
                    Dimensions.kHorizontalSpaceSmaller,
                    Expanded(
                      child: DateTimePicker(
                        label: serviceTime != null
                            ? serviceTime.format(context)
                            : 'Select Time',
                        icon: AppIcon.timer,
                        onTap: () async {
                          final time = await PickDateTime.time(context);
                          ref
                              .read(tumpangNotifierProvider)
                              .setServiceTime(time);
                        },
                        color: serviceTime != null ? false : true,
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  searchTextFormField(
      {required VoidCallback onPressed,
      required String place,
      required String locationIcon}) {
    final textTheme = context.textTheme;
    return InkWell(
      onTap: onPressed,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 58,
        child: Row(
          children: [
            Dimensions.kHorizontalSpaceSmall,
            SvgPicture.asset(locationIcon),
            Dimensions.kHorizontalSpaceSmall,
            Expanded(
              child: Opacity(
                opacity:
                    place == 'Pickup Address' || place == 'Drop off Address'
                        ? 0.25
                        : 1,
                child: Text(
                  place,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color:
                        place == 'Pickup Address' || place == 'Drop off Address'
                            ? Color(0xFF1B293D)
                            : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showAddressModelFunc(String label) {
    if (label == 'pickup') {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) {
          return const TumpangSearchLocation(label: 'Pickup Address');
        },
      );
    }
    if (label == 'drop_off') {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        builder: (_) {
          return const TumpangSearchLocation(label: 'Drop off Address');
        },
      ).then((value) async => {
            getDirection(
              ref.watch(tumpangNotifierProvider).pickupGeometry,
              ref.watch(tumpangNotifierProvider).dropOffGeometry,
            ),
          });
    }
  }

  Future<void> getDirection(LatLng? origin, LatLng? destination) async {
    debugPrint(
        '${origin?.latitude} ${origin?.longitude},${destination?.latitude} ${destination?.longitude}');
    ref
        .read(tumpangProvider.notifier)
        .getDirection(TumpangDirectionEntities(
          origin: origin!,
          destination: destination!,
          key: AppKeys.placeApiKey,
        ))
        .then((res) => res.fold(
            (l) => {},
            (r) => {
                  setState(() => {
                        directions = r,
                        _controller.animateCamera(
                          CameraUpdate.newLatLngBounds(directions.bounds!, 100),
                        ),
                        ref
                            .read(tumpangNotifierProvider)
                            .setDistance(r.totalDistance!),
                        ref
                            .read(tumpangNotifierProvider)
                            .setDuration(r.totalDuration!),
                        isDirectionAvailable = false,
                      }),
                }));
  }
}
