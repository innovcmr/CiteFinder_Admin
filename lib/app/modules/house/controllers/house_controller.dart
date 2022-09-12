// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:cite_finder_admin/app/data/models/home_room_model.dart';
import 'package:cite_finder_admin/app/data/models/house_model.dart';
import 'package:cite_finder_admin/app/data/models/house_model2.dart';
import 'package:cite_finder_admin/app/data/models/house_room_model2.dart';
import 'package:cite_finder_admin/app/data/models/location_model2.dart';
import 'package:cite_finder_admin/app/data/providers/homeRoomProvider.dart';
import 'package:cite_finder_admin/app/data/providers/houseProvider.dart';
import 'package:cite_finder_admin/app/modules/house/controllers/location_controller.dart';
import 'package:cite_finder_admin/app/utils/config.dart';
import 'package:cite_finder_admin/app/utils/formKeys.dart';
import 'package:cite_finder_admin/app/utils/upload_media.dart';
import 'package:cite_finder_admin/app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:video_player/video_player.dart';

class HouseController extends GetxController {
  //TODO: Implement HouseController

  final count = 0.obs;
  static HouseController get to => Get.find();

  // List<User> get moduleItems => moduleItemList.value;
  final houseProvider = HouseProvider();
  final homeRoomProvider = HomeRoomProvider();
  final selectedUserIndex = Rxn<int>();

  final GlobalKey<FormState> _createHomeFormKey = CreateHomeFormKey();
  GlobalKey<FormState> _roomKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;

  RxBool isLoadingMainImage = false.obs;
  RxBool isLoadingImage = false.obs;
  RxBool isLoadingVideo = false.obs;
  RxBool isLoadingRoomImage = false.obs;

  bool isEditMode =
      Get.arguments != null && Get.arguments[Config.firebaseKeys.home] != null;

  Rx<House?> homeToEdit = Rx(null);

  final searchController = TextEditingController();
  final autoValidate = false.obs;
  // final selectedUserRole = Config..firebaseKeys.userRole.first.obs;
  final selectedUserRole = "".obs;

  late String? initialLocation;
  late String? initialbasePrice;

  TextEditingController nameController = TextEditingController(
      text: Get.arguments?[Config.firebaseKeys.home].name ?? '');
  TextEditingController descriptionController = TextEditingController(
      text: Get.arguments?[Config.firebaseKeys.home].description ?? '');
  TextEditingController basePriceController = TextEditingController(
      text:
          Get.arguments?[Config.firebaseKeys.home].basePrice?.toString() ?? '');

  TextEditingController roomNumberController = TextEditingController();
  TextEditingController roomDescriptionController = TextEditingController();
  TextEditingController roomPriceController = TextEditingController();
  RxString roomType = RxString(Config.firebaseKeys.roomTypes[0]);
  RxList<String> roomImages = RxList<String>();

  Rx<HomeRoom2?> roomToEdit = Rx(null);

  RxString type = RxString(Config.firebaseKeys.availableAccomodations[0]);

  Rx<Location> location = Location(
          city: Config.firebaseKeys.availableCities[0],
          geoCoordinates: GeoPoint(0, 0))
      .obs;

  RxList<String> facilities = RxList<String>();
  RxString shortVideo = "".obs;
  RxString mainImage = "".obs;
  RxList<String> images = RxList<String>();

  RxMap<String, dynamic> homeRooms = RxMap({});

  final LatLng defaultCoordinates =
      LatLng(6.011559361192787, 10.259347515194026);
  Rx<CameraPosition> initialCameraPosition = CameraPosition(
          target: LatLng(6.011559361192787, 10.259347515194026), zoom: 15)
      .obs;

  // late LandLord landlord;

  //focus nodes
  FocusNode nameFocusNode = FocusNode();
  FocusNode descriptionFocusNode = FocusNode();
  FocusNode basePriceFocusNode = FocusNode();

  VideoPlayerController? videoController;

  GoogleMapController? mapController;

  RxMap<String, Marker> markers = RxMap({});

  DocumentReference<Map<String, dynamic>>? currentHomeRef;

  RxList<HomeRoom2> currentHomeRooms2 = RxList<HomeRoom2>();
  RxList<HomeRoom> currentHomeRooms = RxList<HomeRoom>();
  @override
  void onInit() {
    super.onInit();
    houseProvider.onInit();
    homeRoomProvider.onInit();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   //   // executes after build
    // });
    if (isEditMode) {
      homeToEdit.value = Get.arguments[Config.firebaseKeys.home];

      type.value = homeToEdit.value!.type!;

      location.update((val) {
        if (val == null) return;
        val.city = homeToEdit.value!.location!.city;
        val.quarter = homeToEdit.value!.location!.quarter;
        // val.geoCoordinates = homeToEdit.value!.location!.p geoCoordinates;
      });

      facilities = homeToEdit.value!.facilities!.obs;

      mainImage.value = homeToEdit.value!.mainImage ?? "";

      shortVideo.value = homeToEdit.value!.shortVideo ?? "";

      images = homeToEdit.value!.images!.obs;
    }
    print("is edit mode ${roomType.value}");
  }

  Future<void> setRooms(House? house) async {
    homeToEdit.value = house;
    getHomeRooms().then((rooms) {
      if (rooms.isNotEmpty) {
        currentHomeRooms2.addAll(rooms);
        // currentHomeRooms.addAll(rooms);
      }
    });
  }

  Future<void> initLocation() async {
    if (isEditMode) return;
    //attempt to get and set the user's device current location
    Get.put(LocationController());
    final locationController = LocationController.to;
    Position? pos;
    if (locationController.currentDevicePosition.value == null) {
      pos = await locationController.determineCurrentPosition();
    } else
      pos = locationController.currentDevicePosition.value;

    if (pos != null) {
      location.update((loc) {
        if (loc != null) {
          loc.geoCoordinates = GeoPoint(pos!.latitude, pos.longitude);
        }
      });
    }
  }

  void centralizeCamera() {
    mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(
        location.value.geoCoordinates?.latitude ?? defaultCoordinates.latitude,
        location.value.geoCoordinates?.longitude ??
            defaultCoordinates.longitude)));
  }

  void moveMarker(LatLng pos) {
    markers.removeWhere((key, value) => key == 'home_location');

    markers["home_location"] = Marker(
      markerId: MarkerId("home_location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      position: LatLng(pos.latitude, pos.longitude),
      infoWindow: InfoWindow(
        title: "Home Location",
        snippet: "This marker indicates the location of the home",
      ),
    );

    location.update((loc) {
      if (loc != null) {
        loc.geoCoordinates = GeoPoint(pos.latitude, pos.longitude);
      }
    });

    centralizeCamera();
  }

  bool isFacilitySelected(String facility) {
    return facilities.contains(facility);
  }

  void setFacility(facility) {
    if (!facilities.contains(facility)) {
      facilities.add(facility);
    } else
      facilities.remove(facility);
  }

  Future<void> selectMainImage() async {
    isLoadingMainImage.value = true;
    final media =
        await selectMediaWithSourceBottomSheet(message: "Choose Image Source");

    if (media == null) {
      isLoadingMainImage.value = false;
      Get.snackbar("Error", "No image selected");

      return;
    }

    if (media.bytes.lengthInBytes > 5120000) {
      Get.snackbar("Error", "File too large: Max 5MB");
      return;
    }

    try {
      final imageUrl = await uploadToStorage(media);
      Get.snackbar("Success", "Image added successfully");

      if (mainImage.value.isNotEmpty) {
        try {
          await deleteFromStorage(mainImage.value);
        } catch (err) {
          print("No file to delete");
        }
      }

      mainImage.value = imageUrl;
    } on Exception catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Error", "image upload failed");
    } finally {
      isLoadingMainImage.value = false;
    }
  }

  Future<void> selectShortVideo() async {
    isLoadingVideo.value = true;
    final media = await selectMediaWithSourceBottomSheet(
        allowPhoto: false, allowVideo: true, message: "Choose Video Source");

    if (media == null) {
      isLoadingVideo.value = false;
      return;
    }

    if (media.bytes.lengthInBytes > 5120000) {
      Get.snackbar("Error", "File too large");
      return;
    }

    try {
      final videoUrl = await uploadToStorage(media);

      shortVideo.value = videoUrl;

      videoController = VideoPlayerController.network(shortVideo.value);

      await videoController!.initialize();

      //delete previous file
      if (shortVideo.value.isNotEmpty) {
        try {
          await deleteFromStorage(shortVideo.value);
        } catch (err) {
          print("No file to delete");
        }
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Error", "video upload failed");
    }

    isLoadingVideo.value = false;
  }

  Future<void> selectImage([bool isRoomImage = false]) async {
    if (!isRoomImage && images.length == 15) {
      Get.snackbar("Error", "You cannot upload more than 15 images for a home");
      return;
    }
    if (!isRoomImage)
      isLoadingImage.value = true;
    else
      isLoadingRoomImage.value = true;
    final media =
        await selectMediaWithSourceBottomSheet(message: "Choose Image Source");

    if (media == null) {
      if (!isRoomImage)
        isLoadingImage.value = false;
      else
        isLoadingRoomImage.value = false;
      return;
    }

    if (media.bytes.lengthInBytes > 2048000) {
      Get.snackbar("Error", "File too large: Max 2MB");
      return;
    }

    try {
      final imageUrl = await uploadToStorage(media);

      if (!isRoomImage) {
        images.add(imageUrl);
      } else {
        roomImages.add(imageUrl);
      }
    } on Exception catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Error", "image upload failed");
    }

    if (!isRoomImage)
      isLoadingImage.value = false;
    else
      isLoadingRoomImage.value = false;
  }

  Future<void> removeImage(String? image,
      [bool isMain = false, bool isRoomImage = false]) async {
    final result = await Get.defaultDialog(
      title: "Delete image",
      middleText: "Are you sure you want to permanently delete this image?",
      onConfirm: () => Get.back(result: true),
      textConfirm: 'Yes',
      textCancel: 'No',
    );

    if (result != true) return;

    if (isMain)
      mainImage.value = "";
    else if (isRoomImage) {
      image != null && roomImages.remove(image);
    } else {
      image != null && images.remove(image);
    }

    try {
      //if image is deleted while upadting a room, we equally remove the image from the room's images array in the database
      if (isRoomImage &&
          roomToEdit.value != null &&
          roomToEdit.value!.images!.contains(image)) {
        await HomeRoom2.updateHomeRoom(
            roomToEdit.value!.id, {Config.firebaseKeys.images: roomImages});

        roomToEdit.update((val) {
          if (val != null) val.images = roomImages;
        });
      }
      await deleteFromStorage(isMain ? mainImage.value : image ?? '');

      Get.snackbar("Success", "Image removed");
    } catch (err) {
      Get.snackbar("Error", "Unable to delete image");
    }
  }

  Future<void> removeVideo() async {
    final temp = shortVideo.value;
    shortVideo.value = "";
    try {
      await deleteFromStorage(temp);
      Get.snackbar("Success", "video removed");
    } catch (err) {
      Get.snackbar("Error", "Unable to delete video");
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    await initLocation();
    mapController!.animateCamera(
      CameraUpdate.zoomBy(15),
    );
    moveMarker(LatLng(
        location.value.geoCoordinates?.latitude ?? defaultCoordinates.latitude,
        location.value.geoCoordinates?.longitude ??
            defaultCoordinates.longitude));

    refresh();
  }

  onMapTap(LatLng latlng) {
    location.update((loc) {
      if (loc != null) {
        loc.geoCoordinates = GeoPoint(latlng.latitude, latlng.longitude);
      }
    });
  }

  Future<List<HomeRoom2>> getHomeRooms(
      {Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>>)?
          queryBuilder}) {
    try {
      final homeRoomsRef =
          FirebaseFirestore.instance.collection(Config.firebaseKeys.homeRooms);
      final homesStream = queryCollection(homeRoomsRef,
          queryBuilder: (rooms) => rooms.where(Config.firebaseKeys.home,
              isEqualTo: homeToEdit.value!.record),
          objectBuilder: (homeRoomsMap) {
            return HomeRoom2.fromMap(homeRoomsMap);
          });

      var result = homesStream.first;
      log("homeRoom Fetch  $result");
      return result;
    } catch (e) {
      Get.snackbar("Error in homeRoom Fetch", e.toString());
      log("error in homeRoom Fetch, $e");
      rethrow;
    }
  }

  //Add/Edit room
  Future<void> addRoom() async {
    if (_roomKey.currentState == null || !_roomKey.currentState!.validate())
      return;

    currentHomeRef ??= isEditMode ? homeToEdit.value!.record : Home2().record;

    final result1 = await Get.defaultDialog<bool>(
        title: "Save Room Type",
        middleText: "Are you sure you want to save this information?",
        onConfirm: () => Get.back(result: true),
        textCancel: "No",
        textConfirm: "Yes");

    if (result1 != true) return;

    final result = await Get.showOverlay(
      loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary),
      asyncFunction: () async {
        final Map<String, dynamic> roomMap = {
          Config.firebaseKeys.id: roomToEdit.value?.id,
          Config.firebaseKeys.type: roomType.value,
          Config.firebaseKeys.description: roomDescriptionController.text,
          Config.firebaseKeys.price: double.parse(roomPriceController.text),
          Config.firebaseKeys.numberAvailable:
              int.parse(roomNumberController.text),
          Config.firebaseKeys.images: roomImages,
          Config.firebaseKeys.home: currentHomeRef
        };

        try {
          if (roomToEdit.value != null) {
            roomToEdit.update((r) {
              if (r != null) r.updateFromMap(roomMap);
            });

            // final updatedRoom = HomeRoom2.fromMap(roomMap);

            // final index = currentHomeRooms2
            // final index = currentHomeRooms
            //     .indexWhere((r) => r.id == roomToEdit.value?.id);

            // if (index > -1) {
            //   currentHomeRooms2.replaceRange(index, index + 1, [updatedRoom]);
            //   currentHomeRooms.replaceRange(index, index + 1, [updatedRoom]);
            //   print("room replaced");
            // }
          } else {
            //add the room type to the rooms array
            final newRoom = HomeRoom2.fromMap(roomMap);

            currentHomeRooms2.add(newRoom);
            // currentHomeRooms.add(newRoom);
          }

          return true;
        } on Exception catch (e) {
          print(e);
          Get.snackbar("Error", "An error occured while adding room type");
        }
        return false;
      },
    );

    if (result == true) {
      Get.snackbar("Success",
          "Room type successfully ${roomToEdit.value != null ? 'modified' : 'added'}");

      if (roomToEdit.value != null) {
        roomToEdit.value = null;
      }
      clearRoomFields();
      Get.back();
    } else {
      Get.snackbar("Error",
          "Unable to ${roomToEdit.value != null ? 'modify' : 'add'} room type :-(");
    }
  }

  Future<bool> cancelRoom() async {
    if (homeToEdit.value != null) {
      Get.back();
      return true;
    }

    final result = await Get.defaultDialog<bool>(
        title: "Cancel Room Type",
        middleText:
            "Do you really want to discard the information you added for this room type?",
        onConfirm: () => Get.back(result: true),
        textCancel: "No",
        textConfirm: "Yes");

    if (result == true) {
      await Get.showOverlay(
          asyncFunction: () async {
            try {
              for (String image in roomImages) {
                if (image.isNotEmpty) {
                  try {
                    await deleteFromStorage(image);
                  } catch (err) {
                    print("nothing to delete");
                  }
                }
              }

              clearRoomFields();
              Get.snackbar("Success", "Room type discarded");
            } on Exception catch (e) {
              print(e);
              Get.snackbar(
                  "Error", "An error occurred while deleting room images");
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));

      Get.back();
      return true;
    } else
      return false;
  }

  //method to set initial values for home room addition fields
  void initializeRoom(HomeRoom2 room) {
    roomType.value = room.type ?? "";
    roomDescriptionController.text = room.description ?? "";
    roomNumberController.text = room.numberAvailable?.toString() ?? "";
    roomImages = RxList(room.images ?? []);
    roomPriceController.text = room.price?.toString() ?? "";

    roomToEdit.update((val) {
      roomToEdit.value = room;
    });
  }

  Future<void> approveHome(String? homeId) async {
    if (!_createHomeFormKey.currentState!.validate()) {
      autoValidate(true);
      return;
    }
    await Get.showOverlay(
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary),
        asyncFunction: () async {
          try {
            isLoading.value = true;
            houseProvider.approve(homeId);
          } catch (e) {
          } finally {
            await clearFields();
            isLoading.value = false;
            Get.back();
          }
        });
  }

  //method to save the entered data in the database
  Future<void> addHome() async {
    if (!_createHomeFormKey.currentState!.validate()) {
      autoValidate(true);
      return;
    }

    await Get.showOverlay(
      loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary),
      asyncFunction: () async {
        try {
          isLoading.value = true;
          final locationMap = location.value.toMap();
          final now = DateTime.now();

          currentHomeRef ??=
              isEditMode ? homeToEdit.value!.record : Home2().record;

          final Map<String, dynamic> homeMap = {
            Config.firebaseKeys.id: currentHomeRef!.id,
            Config.firebaseKeys.name: nameController.text,
            Config.firebaseKeys.description: descriptionController.text,
            Config.firebaseKeys.mainImage: mainImage.value,
            Config.firebaseKeys.shortVideo: shortVideo.value,
            Config.firebaseKeys.images: images,
            Config.firebaseKeys.type: type.value,
            Config.firebaseKeys.facilities: facilities,
            Config.firebaseKeys.location: locationMap,
            Config.firebaseKeys.rating: 0.0,
            Config.firebaseKeys.dateAdded:
                isEditMode ? homeToEdit.value!.dateAdded : now,
            Config.firebaseKeys.dateModified: now,
            Config.firebaseKeys.basePrice: basePriceController.text.isEmpty
                ? null
                : double.parse(basePriceController.text),
            // Todo: add bottom line equivalent
            // Config.firebaseKeys.landlord: authController.currentUser.value!.record
          };

          final newHome = await Home2.updateHome(currentHomeRef!.id, homeMap);

          // save the room types to the database
          for (HomeRoom2 room in currentHomeRooms2) {
            await HomeRoom2.updateHomeRoom(room.id, room.toMap());
          }

          if (!isEditMode) await clearFields();

          Get.snackbar("Success",
              "Home ${isEditMode ? 'updated' : 'added'} successfully!");
        } catch (err) {
          print(err);
          Get.snackbar("Error",
              "An error occured while ${isEditMode ? 'updating' : 'adding'} new home");
        } finally {
          isLoading.value = false;
        }
      },
    );
  }

  clearFields() async {
    nameController.clear();
    descriptionController.clear();
    basePriceController.clear();
    mainImage.value = "";
    shortVideo.value = "";
    images.value = [];
    type.value = Config.firebaseKeys.availableAccomodations[0];
    facilities.value = [];
    currentHomeRef = null;
    currentHomeRooms2.clear();
    currentHomeRooms.clear();
    autoValidate(false);
  }

  clearRoomFields() {
    roomDescriptionController.clear();
    roomNumberController.clear();
    roomPriceController.clear();
    roomType.value = Config.firebaseKeys.roomTypes[0];
    roomImages = RxList<String>();
  }

  @override
  void onClose() {
    super.onClose();
    clearFields();
    clearRoomFields();
    videoController?.dispose();
  }

  @override
  void onReady() {
    super.onReady();
  }

  getFormKey() {
    return _createHomeFormKey;
  }

  getRoomKey() {
    return _roomKey;
  }
}
