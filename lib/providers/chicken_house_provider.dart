// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/model/auth_token.dart';
import 'package:mksc/model/chicken_house_data.dart';
import 'package:mksc/navigator_key.dart';
import 'package:mksc/services/chicken_house/chicken_house_local_services.dart';
import 'package:mksc/services/chicken_house/chicken_house_online_services.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/initiatial_services.dart';
import 'package:mksc/storage/token_storage.dart';

class ChickenHouseProvider with ChangeNotifier {
  InitiatialServices initiatialServices = InitiatialServices();
  TokenStorage tokenStorage = TokenStorage();

  List<ChickenHouseData> _chickenHouseDataList = [];
  List<ChickenHouseData> get chickenHouseDataList => _chickenHouseDataList;
  bool isFetchingChickenHouseData = false;
  int _localChickenHouseDataStatus = 0;
  int get localChickenHouseDataStatus => _localChickenHouseDataStatus;

  // Fetch all chicken houses data online and offline
  Future<void> fetchChickenHouseDataOnlineAndOffline({
    required BuildContext context,
    required String title,
    required String date,
  }) async {
    isFetchingChickenHouseData = true;

    List<ChickenHouseData> offlineData = [];
    List<ChickenHouseData> onlineData = [];

    // Fetch offline data
    offlineData = await _fetchOfflineData(context, date);

    notifyListeners();
    
    // Check for internet connection
    if (await initiatialServices.checkInternetConnectionBool()) {
      // Validate token
      if (await validToken(title: title)) {
        AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);
        // Fetch online data
        onlineData = await _fetchOnlineData(context, authToken, title, date);
      }
    }

    // Merge offline and online data
    final List<ChickenHouseData> mergedData = [
      ...offlineData,
      ...onlineData,
    ];

    _chickenHouseDataList = mergedData;
    isFetchingChickenHouseData = false;

    fetchChickenHouseDataStatus();
    
    notifyListeners();
  }

  Future<List<ChickenHouseData>> _fetchOfflineData(BuildContext context, String date) async {
    try {
      List<ChickenHouseData> localDataList = await ChickenHouseLocalServices.fetchChickenHousesLocalData(
        context: context,
        date: date,
      );
      // Update each item's `isLocal` property
      localDataList = localDataList
        .map(
          (chickenHouseLocalData) => chickenHouseLocalData.copyWith(isLocal: true)
        ).toList();

      return localDataList;
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider._fetchOfflineData",
        );
      }
      return List<ChickenHouseData>.empty();
    }
  }

  Future<List<ChickenHouseData>> _fetchOnlineData(
    BuildContext context, 
    AuthToken authToken,
    String title, 
    String date,
  ) async {
    try {
      List<ChickenHouseData> onlineDataList = await ChickenHouseOnlineServices.fetchChickenHouseOnlineData(
        context: context,
        token: authToken.token,
        date: date,
      );
      return onlineDataList;
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider._fetchOnlineData",
        );
      }
      return List<ChickenHouseData>.empty();
    }
  }

  // Save a new chicken house record
  Future<void> saveChickenHouse({
    required BuildContext context,
    required String title,
    required String item,
    required int number,
    required String date,
  }) async {
    try {
      // Check for internet and token validity
      if (await initiatialServices.checkInternetConnectionBool() && await validToken(title: title)) {
        AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);
        ChickenHouseData savedData = await ChickenHouseOnlineServices.saveChickenHouseData(
          context: context,
          item: item,
          number: number,
          token: authToken.token,
          date: date,
        );
        _chickenHouseDataList.add(savedData);
        notifyListeners();
      } else {
        await _saveLocallyAndRefresh(context, item, number, date, title);
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider.saveChickenHouseLocalData",
        );
      }
      await _saveLocallyAndRefresh(context, item, number, date, title);
    }
  }

  Future<void> _saveLocallyAndRefresh(
    BuildContext context,
    String item,
    int number,
    String date,
    String title,
  ) async {
    try {
      await ChickenHouseLocalServices.saveChickenHouseLocalData(
        context: context,
        item: item,
        number: number,
        date: date,
      );
      if (context.mounted) {
        await fetchChickenHouseDataOnlineAndOffline(
          context: context,
          date: date,
          title: title,
        );
      }
      notifyListeners();
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider._saveLocallyAndRefresh",
        );
      }
    }
  }

  // Edit an existing chicken house record
  Future<void> editChickenHouse({
    required BuildContext context,
    required ChickenHouseData chickenHouseData,
    required String title,
    required int number,
  }) async {
    try {

      // Skip editing online if the record is local

      if (chickenHouseData.isLocal) {
        await _editLocallyAndRefresh(
          context: context,
          chickenHouseData: chickenHouseData,
          title: title,
          number: number,
        );
        return;
      }

      // Check for internet and token validity
      if (
        await initiatialServices.checkInternetConnectionBool() && 
        await validToken(title: title) &&
        !chickenHouseData.isLocal // if only the data in online
      ) {
        AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);

        // Edit record online
        ChickenHouseData updatedData = await ChickenHouseOnlineServices.editChickenHouseData(
          context: context,
          chickenHouseData: chickenHouseData,
          number: number,
          token: authToken.token,
        );

        // Update local state with the updated data
        _updateLocalData(updatedData);
        notifyListeners();
      } else {
        // Fallback to offline editing
        await _editLocallyAndRefresh(
          context: context,
          chickenHouseData: chickenHouseData,
          title: title,
          number: number,
        );
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider.editChickenHouse",
        );
      }
      // Fallback to offline editing
      await _editLocallyAndRefresh(
        context: context,
        chickenHouseData: chickenHouseData,
        title: title,
        number: number,
      );
    }
  }

  Future<void> _editLocallyAndRefresh({
    required BuildContext context,
    required ChickenHouseData chickenHouseData,
    required String title,
    required int number,
  }) async {
    // Return early if the data is not local
    if (!chickenHouseData.isLocal) return;

    try {
      // Edit data locally
      await ChickenHouseLocalServices.editChickenHouseLocalData(
        context: context,
        chickenHouseData: chickenHouseData,
        number: number,
      );

      // Refresh data after editing
      if (context.mounted) {
        await fetchChickenHouseDataOnlineAndOffline(
          context: context,
          title: title,
          date: chickenHouseData.created_at ?? "",
        );
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider._editLocallyAndRefresh",
        );
      }
    }
  }

  void _updateLocalData(ChickenHouseData updatedData) {
    // Update the local list with the modified data
    final index = _chickenHouseDataList.indexWhere((data) => data.id == updatedData.id);
    if (index != -1) {
      _chickenHouseDataList[index] = updatedData;
    }
    notifyListeners();
  }

  // Delete a chicken house record
  Future<void> deleteChickenHouseLocalData({
    required BuildContext context,
    required ChickenHouseData chickenHouseData,
    required String title
  }) async {
    try {
      await ChickenHouseLocalServices.deleteChickenHouseLocalData(
        context: context,
        chickenHouseData: chickenHouseData,
      );
      // Refresh data after deletion
      if (!context.mounted) return;
      await fetchChickenHouseDataOnlineAndOffline(
        context: context,
        title: title,
        date: chickenHouseData.created_at ?? "",
      );
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception,
        context: context,
        location: "ChickenHouseProvider.deleteChickenHouseLocalData",
      );
    }
  }


  Future<void> uploadAndDeleteLocalData({
    required BuildContext context,
    required String title,
  }) async {
    try {
      // Step 1: Fetch all local data
      List<ChickenHouseData> localDataList = await ChickenHouseLocalServices.fetchChickenHousesAllLocalData(
        context: context,
      );

      if (localDataList.isEmpty) {
        // No local data to upload
        return;
      }

      // Step 2: Check if the device has internet connection
      if (!await initiatialServices.checkInternetConnectionBool()) {
        if (context.mounted) {
          HandleException.handleExceptions(
            exception: Exception("No internet connection available."),
            context: context,
            location: "ChickenHouseProvider.uploadAndDeleteLocalData",
          );
        }
        return;
      }

      // Step 3: Get the authorization token
      AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);

      // Step 4: Fetch online data for the past seven days
      List<ChickenHouseData> onlineDataList = await ChickenHouseOnlineServices.fetchChickenHouseData7Days(
        context: context,
        token: authToken.token
      );

      // Step 5: Make Conflicting data in local data list
      
      String formatDateTime(String dateTimeString) {
        DateTime dateTime = DateTime.parse(dateTimeString);
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        return formatter.format(dateTime);
      }

      for (var onlineData in onlineDataList) {
        for (var localData in localDataList) {
          if (
            onlineData.item == localData.item &&
            formatDateTime(localData.created_at!) == formatDateTime(onlineData.created_at!)
          ) {
            localData = localData.copyWith(
              isConflict: true
            );
            // Update the local list with the conflict data
            final index = localDataList.indexWhere(
              (data) {
                return data.id == localData.id;
              }
            );
            if (index != -1) {
              localDataList[index] = localData;
            }

            // Delete the conflicting data locally
            await ChickenHouseLocalServices.deleteChickenHouseLocalDataAfterUpload(
              chickenHouseData: localData,
            );
          }
        }
      }

      // Step 6: Upload each chicken house data record
      for (var chickenHouseData in localDataList) {
        if (chickenHouseData.isConflict) continue; // Skip conflicting records

        try {
          // Upload the data to the server
          await ChickenHouseOnlineServices.uploadChickenHouseData(
            context: context,
            item: chickenHouseData.item,
            number: chickenHouseData.number,
            token: authToken.token,
            date: chickenHouseData.created_at ?? "",
          );

          // Delete the uploaded data locally
          await ChickenHouseLocalServices.deleteChickenHouseLocalDataAfterUpload(
            chickenHouseData: chickenHouseData,
          );
        } on  Exception catch (exception) {
          // If an error occurs while uploading or deleting, log the exception but continue with the rest of the data
          if (context.mounted) {
            HandleException.handleExceptions(
              exception: exception,
              context: context,
              location: "ChickenHouseProvider.uploadAndDeleteLocalData",
            );
          }
        }
      }
    } on  Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider.uploadAndDeleteLocalData",
        );
      }
    }
  }

  Future<void> uploadSingleLocalData({
    required BuildContext context,
    required String title,
    required ChickenHouseData localData,
  }) async {
    try {
      // Step 1: Check if the device has internet connection
      if (!await initiatialServices.checkInternetConnectionBool()) {
        if (context.mounted) {
          HandleException.handleExceptions(
            exception: Exception("No internet connection available."),
            context: context,
            location: "ChickenHouseProvider.uploadSingleLocalData",
          );
        }
        return;
      }

      // Step 2: Get the authorization token
      AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);

      // Step 3: Fetch online data for the past seven days
      List<ChickenHouseData> onlineDataList = await ChickenHouseOnlineServices.fetchChickenHouseData7Days(
        context: context,
        token: authToken.token,
      );

      // Step 4: Check if the local data conflicts with online data

      String formatDateTime(String dateTimeString) {
        DateTime dateTime = DateTime.parse(dateTimeString);
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        return formatter.format(dateTime);
      }

      for (var onlineData in onlineDataList) {
        if (
          localData.item.toLowerCase() == onlineData.item.toLowerCase() && 
          formatDateTime(localData.created_at!) == formatDateTime(onlineData.created_at!)
        ) {
          localData = localData.copyWith(
            isConflict:  true
          );

          // Update the local list with the conflict data
          final index = _chickenHouseDataList.indexWhere(
            (data) => data.id == localData.id
          );
          if (index != -1) {
            _chickenHouseDataList[index] = localData;
          }
          notifyListeners();

          // Delete the conflicting data locally
          await ChickenHouseLocalServices.deleteChickenHouseLocalDataAfterUpload(
            chickenHouseData: localData,
          );
          return;
        }
      }

      if (localData.isConflict) {
        if (context.mounted) {
          HandleException.handleExceptions(
            exception: Exception("Conflict detected: This record already exists online."),
            context: context,
            location: "ChickenHouseProvider.uploadSingleLocalData",
          );
        }
        return; // Skip uploading if there's a conflict
      }

      // Step 5: Upload the data to the server
      await ChickenHouseOnlineServices.uploadChickenHouseData(
        context: context,
        item: localData.item,
        number: localData.number,
        token: authToken.token,
        date: localData.created_at ?? "",
      );

      // Step 6: Delete the uploaded data locally
      await ChickenHouseLocalServices.deleteChickenHouseLocalDataAfterUpload(
        chickenHouseData: localData,
      );

      // Step 7: Refresh data if necessary
      await fetchChickenHouseDataOnlineAndOffline(
        context: context,
        date: localData.created_at ?? "",
        title: title,
      );
    } on Exception catch (exception) {
      // Handle any errors that occur
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "ChickenHouseProvider.uploadSingleLocalData",
        );
      }
    }
  }


  // Fetch the status of chicken house data
  Future<void> fetchChickenHouseDataStatus() async {
    _localChickenHouseDataStatus = await ChickenHouseLocalServices.fetchChickenHouseDataStatus();
    notifyListeners();
  }
}
