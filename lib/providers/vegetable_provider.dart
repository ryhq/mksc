// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mksc/model/auth_token.dart';
import 'package:mksc/model/vegetable.dart';
import 'package:mksc/navigator_key.dart';
import 'package:mksc/services/handle_exception.dart';
import 'package:mksc/services/initiatial_services.dart';
import 'package:mksc/services/vegetable/vegetable_local_data_services.dart';
import 'package:mksc/services/vegetable/vegetable_online_data_services.dart';
import 'package:mksc/storage/token_storage.dart';

class VegetableProvider with ChangeNotifier{
  InitiatialServices initiatialServices = InitiatialServices();
  TokenStorage tokenStorage = TokenStorage();
  
  List<Vegetable> _vegetablesList = [];
  List<Vegetable> get vegetablesList => _vegetablesList;
  bool isFetchingVegetableData = false;
  int _localVegetableDataStatus = 0;
  int get localVegetableDataStatus => _localVegetableDataStatus;

  Future<void> fetchVegetableData ({
    required BuildContext context,
    required String title,
    required String date,
  }) async{
    try {
      isFetchingVegetableData = true;

      // All local vegetable base data
      final List<Vegetable> vegetableBaseLocalData = await VegetableLocalDataServices.fetchVegetableBaseData(
        context: context
      );

      notifyListeners();

      // All local vegetable data by date
      final List<Vegetable> vegetableLocalDataByDate = await VegetableLocalDataServices.fetchVegetableData(
        context: context,
        date: date
      );

      // Mark all items in vegetableLocalDataByDate as offline
      final List<Vegetable> updatedLocalDataByDate = vegetableLocalDataByDate.map(
        (localByDate) {
          return localByDate.copyWith(isLocal: true);
        }
      ).toList();

      // Merge the data

      // Create a map from the base data for efficient lookups
      final Map<String, Vegetable> vegetableMap = {
        // Creating a map of String as key because the id changes every time the app initializes vegetable
        for (var vegetable in vegetableBaseLocalData) vegetable.name.toLowerCase(): vegetable,
      };

      // Merge updatedLocalDataByDate into vegetableMap
      for (var localByDate in updatedLocalDataByDate) {
        // If the Map is not null for this vegetable then replace only its value
        if (vegetableMap[localByDate.name.toLowerCase()] != null) { 
          vegetableMap[localByDate.name.toLowerCase()] = vegetableMap[localByDate.name.toLowerCase()]!.copyWith(
            number: localByDate.number,
            unit: localByDate.unit,
            isLocal: localByDate.isLocal,
            isConflict: localByDate.isConflict,
            created_at: localByDate.created_at,
          );
        } else {
          vegetableMap[localByDate.name.toLowerCase()] = localByDate; // else add the data to the map
        }
      }

      // Initialize the list to hold online data
      
      List<Vegetable> onlineData = [];

      // Check for internet connection and fetch online data if available
      if (await initiatialServices.checkInternetConnectionBool()) {
        // Validate token
        if (await validToken(title: title)) {
          AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);
          // Fetch online data
          onlineData = await _fetchOnlineData(context, authToken, title, date);
        }
      }

      // Convert the map back to a list and update the provider's data
      _vegetablesList = vegetableMap.values.toList();

      // Step 1: Create a map from onlineData for quick lookups
      final Map<String, Vegetable> onlineDataMap = {
        for (var vegetable in onlineData) vegetable.name.toLowerCase(): vegetable,
      };

      // Step 2: Prepare a list for merged data
      List<Vegetable> mergedVegetableList = [];

      // Step 3: Iterate through _vegetablesList and merge
      for (var localVegetable in _vegetablesList) {
        // Add the local vegetable to the merged list
        mergedVegetableList.add(localVegetable);

        // Check if online data exists for this vegetable
        final onlineVegetable = onlineDataMap[localVegetable.name.toLowerCase()];
        if (onlineVegetable != null) {
          
          // Check if the online vegetable has valid data
          if (
            (onlineVegetable.number?.isNotEmpty ?? false) &&
            (onlineVegetable.unit?.isNotEmpty ?? false)
          ) {

            // Check the previous localVegetable data if is valid
            if (
              (localVegetable.number?.isNotEmpty ?? false) &&
              (localVegetable.unit?.isNotEmpty ?? false)
            ) {
              // Add online data just below the local data
              mergedVegetableList.add(onlineVegetable.copyWith(
                image: localVegetable.image
              ));
              // Since online data comes with some missing properties we'll 
              // copy some from local leaving number and units
            } else {
              // if the local data have not valid data remove it and add online data
              mergedVegetableList.remove(localVegetable);
              // Add online data replacing the null one
              mergedVegetableList.add(onlineVegetable.copyWith(
                image: localVegetable.image
              ));
            }
          }
          // Remove the vegetable from onlineDataMap after merging
          onlineDataMap.remove(localVegetable.name.toLowerCase());
        }
      }

      // Step 4: Add any remaining items from onlineDataMap
      for (var onlineVegetable in onlineDataMap.values) {
        // Add only if the vegetable has valid data
        if ((onlineVegetable.number?.isNotEmpty ?? false) &&
            (onlineVegetable.unit?.isNotEmpty ?? false)) {
          mergedVegetableList.add(onlineVegetable);
        }
      }

      // Step 5: Update the provider's vegetables list
      _vegetablesList = mergedVegetableList;

      // Update the provider's vegetables list
      _vegetablesList = mergedVegetableList;
      isFetchingVegetableData = false;
      fetchVegetableDataStatus();
      notifyListeners();
    }  on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.editLaundryDataByDate"
      );
    }
  }

  Future<List<Vegetable>> _fetchOnlineData(
    BuildContext context, 
    AuthToken authToken,
    String title, 
    String date,
  ) async {
    try {
      List<Vegetable> onlineDataList = await VegetableOnlineDataServices.fetchVegetableDataByDate(
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
          location: "VegetableProvider._fetchOnlineData",
        );
      }
      return List<Vegetable>.empty();
    }
  }

  Future<void> saveVegetableData({
    required BuildContext context,
    required String title,
    required String number,
    required String unit,
    required String date,
    required String item,
  }) async{
    try {
      // Check for internet and token validity
      bool isInternetAvailable = await initiatialServices.checkInternetConnectionBool();

      if (isInternetAvailable) {
        bool isTokenValid = await validToken(title: title);
        if (isTokenValid) {
          AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);
          Vegetable savedData = await VegetableOnlineDataServices.saveVegetableData(
            context: context, 
            token: authToken.token, 
            number: number, 
            unit: unit, 
            date: date, 
            item: item
          );

          // Update list if vegetable exists, otherwise fetch the updated data
          _updateLocalData(
            context: context, 
            vegetable: savedData, 
            title: title, 
            date: date
          );
        } else {
          return;
        }
      } else {
        // Save locally when offline or token is invalid
        await _saveLocallyAndRefresh(context, number, unit, date, item, title);
      }
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.saveVegetableData"
      );
      await _saveLocallyAndRefresh(context, number, unit, date, item, title);
    }
  }

  Future<void> _saveLocallyAndRefresh(BuildContext context, String number, String unit, String date, String item, String title) async {
    try {
      await VegetableLocalDataServices.saveVegetableData(
        context: context, 
        number: number, 
        unit: unit, 
        date: date, 
        item: item
      );
      if (context.mounted) {
        await fetchVegetableData(
          context: context,
          date: date,
          title: title
        );
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "VegetableProvider._saveLocallyAndRefresh",
        );
      }
    }
  }

  Future<void> editVegetableData({
    required BuildContext context,
    required String title,
    required Vegetable vegetable,
    required String number,
    required String unit,
    required String date,
  }) async {
    try {
      // Skip editing online if the record is local
      if (vegetable.isLocal) {
        await _editLocallyAndRefresh(
          context: context,
          vegetable: vegetable,
          title: title,
          number: number,
          unit: unit,
          date: date,
        );
        return;
      }

      // Check for internet and token validity
      if (await initiatialServices.checkInternetConnectionBool()) {
        if(await validToken(title: title)){
          AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);

          // Edit data online
          Vegetable updatedData = await VegetableOnlineDataServices.editVegetableData(
            context: context,
            vegetable: vegetable,
            number: number,
            unit: unit,
            token: authToken.token,
          );

          // Update local state with the updated data
          _updateLocalData(
            context: context, 
            vegetable: updatedData, 
            title: title, 
            date: date
          );
          notifyListeners();
        } else {
          return;
        }
      } else {
        // Fallback to offline editing
        await _editLocallyAndRefresh(
          context: context,
          vegetable: vegetable,
          title: title,
          number: number,
          unit: unit,
          date: date,
        );
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "VegetableProvider.editVegetableData",
        );
      }
      // Fallback to offline editing
      await _editLocallyAndRefresh(
        context: context,
        vegetable: vegetable,
        title: title,
        number: number,
        unit: unit,
        date: date,
      );
    }
  }

  Future<void> _editLocallyAndRefresh({
    required BuildContext context,
    required Vegetable vegetable,
    required String title,
    required String number,
    required String unit,
    required String date,
  }) async {
    // Return early if the data is not local
    if (!vegetable.isLocal) return;

    try {
      // Edit data locally
      await VegetableLocalDataServices.editVegetableData(
        context: context,
        vegetable: vegetable,
        number: number,
        unit: unit,
      );

      // Refresh data after editing
      if (context.mounted) {
        await fetchVegetableData(
          context: context,
          date: date,
          title: title,
        );
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "VegetableProvider._editLocallyAndRefresh",
        );
      }
    }
  }

  void _updateLocalData({
    required BuildContext context,
    required Vegetable vegetable,
    required String title,
    required String date,
  }) async {
    int index = _vegetablesList.indexWhere(
      (vegetableFromList) => vegetableFromList.name.toLowerCase() == vegetable.name.toLowerCase(),
    );
    if (index != -1) {
      // Update vegetable to have image url
      vegetable = vegetable.copyWith(
        image: _vegetablesList[index].image
      );
      _vegetablesList[index] = vegetable;
      notifyListeners();
    } else {
      await fetchVegetableData(
        context: context,
        date: date,
        title: title,
      );
    }
  }

  Future<void> deleteVegetableData({
    required BuildContext context, 
    required Vegetable vegetable, 
    required String title,
    required String date,
  }) async{
    try {
      await VegetableLocalDataServices.deleteVegetableData(context, vegetable: vegetable);
      if (context.mounted) {
        await fetchVegetableData(
          context: context,
          date: date,
          title: title
        );
      }
    } on Exception catch (exception) {
      if (!context.mounted) return;
      HandleException.handleExceptions(
        exception: exception, 
        context: context, 
        location: "VegetableProvider.deleteVegetableData"
      );
    }
  }

  Future<void> uploadAndDeleteLocalData({
    required BuildContext context,
    required String title,
  }) async {
    try {
      // Step 1: Fetch all local data
      List<Vegetable> localDataList = await VegetableLocalDataServices.fetchVegetableAllData(context);

      if (localDataList.isEmpty) {
        // No local data to upload
        return;
      }

      // Step 2: Check for internet connection
      if (!await initiatialServices.checkInternetConnectionBool()) {
        if (context.mounted) {
          HandleException.handleExceptions(
            exception: Exception("No internet connection available."),
            context: context,
            location: "VegetableProvider.uploadAndDeleteLocalData",
          );
        }
        return;
      }

      // Step 3: Get the authorization token
      AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);

      // Step 4: Fetch online data for conflict detection
      List<Vegetable> onlineDataList = await VegetableOnlineDataServices.fetchVegetableData7Days(
        context: context,
      );

      // Step 5: Detect conflicts
      String formatDateTime(String dateTimeString) {
        DateTime dateTime = DateTime.parse(dateTimeString);
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        return formatter.format(dateTime);
      }
      for (var localData in localDataList) {
        for (var onlineData in onlineDataList) {
          if (
            onlineData.name.toLowerCase() == localData.name.toLowerCase() &&
            formatDateTime(onlineData.created_at!) == formatDateTime(localData.created_at!)
          ) {
            // Mark local data as conflicting
            localData = localData.copyWith(isConflict: true);

            // Update local list
            int index = localDataList.indexWhere(
              (data) => data.name.toLowerCase() == localData.name.toLowerCase()
            );
            if (index != -1) {
              localDataList[index] = localData;
            }

            // Delete conflicting local data 
            await VegetableLocalDataServices.deleteLocalVegetableDataAfterUpload(
              vegetable: localData,
            );
          }
        }
      }

      // Step 6: Upload non-conflicting local data
      for (var vegetable in localDataList) {
        if (vegetable.isConflict) continue;

        try {
          // Upload to the server
          await VegetableOnlineDataServices.uploadVegetableData(
            context: context,
            token: authToken.token,
            item: vegetable.name,
            unit: vegetable.unit ?? "",
            number: vegetable.number ?? "",
            date: vegetable.created_at ?? "",
          );

          // Delete local data after upload
          await VegetableLocalDataServices.deleteLocalVegetableDataAfterUpload(
            vegetable: vegetable,
          );
        } on Exception catch (exception) {
          if (context.mounted) {
            HandleException.handleExceptions(
              exception: exception,
              context: context,
              location: "VegetableProvider.uploadAndDeleteLocalData",
            );
          }
        }
      }
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "VegetableProvider.uploadAndDeleteLocalData",
        );
      }
    }
  }

  Future<void> uploadSingleLocalData({
    required BuildContext context,
    required String title,
    required Vegetable localData,
  }) async {
    try {
      // Step 1: Check for internet connection
      if (!await initiatialServices.checkInternetConnectionBool()) {
        if (context.mounted) {
          HandleException.handleExceptions(
            exception: Exception("No internet connection available."),
            context: context,
            location: "VegetableProvider.uploadSingleLocalData",
          );
        }
        return;
      }

      // Step 2: Get the authorization token
      AuthToken authToken = await tokenStorage.getTokenDirect(tokenKey: title);

      // Step 3: Fetch online data for conflict detection
      List<Vegetable> onlineDataList = await VegetableOnlineDataServices.fetchVegetableData7Days(
        context: context,
      );

      // Step 4: Check for conflicts
      String formatDateTime(String dateTimeString) {
        DateTime dateTime = DateTime.parse(dateTimeString);
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        return formatter.format(dateTime);
      }

      for (var onlineData in onlineDataList) {
        if (
          onlineData.name.toLowerCase() == localData.name.toLowerCase() &&
          formatDateTime(onlineData.created_at!) == formatDateTime(localData.created_at!)
        ) {
          // Mark as conflicting
          localData = localData.copyWith(isConflict: true);

          // Notify listeners if necessary
          int index = _vegetablesList.indexWhere((data) => data.name.toLowerCase() == localData.name.toLowerCase());
          if (index != -1) {
            _vegetablesList[index] = localData;
          }
          notifyListeners();

          // Delete conflicting local data 
          await VegetableLocalDataServices.deleteLocalVegetableDataAfterUpload(
            vegetable: localData,
          );
          return;
        }
      }
      if (localData.isConflict) {
        if (context.mounted) {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Conflict detected: This record already exists online",
              ),
              backgroundColor: Colors.red,
            )
          );

          HandleException.handleExceptions(
            exception: Exception("Conflict detected: This record already exists online."),
            context: context,
            location: "VegetableProvider.uploadSingleLocalData",
          );
        }
        return;
      }

      // Step 5: Upload the record to the server
      await VegetableOnlineDataServices.uploadVegetableData(
        context: context,
        token: authToken.token,
        item: localData.name,
        unit: localData.unit ?? "",
        number: localData.number ?? "",
        date: localData.created_at  ?? "",
      );

      // Step 6: Delete local data
      await VegetableLocalDataServices.deleteLocalVegetableDataAfterUpload(
        vegetable: localData,
      );

      // Refresh data after upload
      await fetchVegetableData(
        context: context,
        date: localData.created_at ?? "",
        title: title,
      );
    } on Exception catch (exception) {
      if (context.mounted) {
        HandleException.handleExceptions(
          exception: exception,
          context: context,
          location: "VegetableProvider.uploadSingleLocalData",
        );
      }
    }
  }



  Future<void> fetchVegetableDataStatus() async{
    _localVegetableDataStatus = await VegetableLocalDataServices.fetchVegetableDataStatus();
    notifyListeners();
  }

  // Method called during app initialization step
  Future<void> fetchVegetableBaseData(BuildContext context) async{
    List<Vegetable> vegetableList = await VegetableOnlineDataServices.fetchVegetableData(
      context : context
    );
    await VegetableLocalDataServices.deleteAllVegetableBaseData();
    for (var vegetable in vegetableList) {
      await VegetableLocalDataServices.saveVegetableBaseData(vegetable: vegetable);
    }
  }
}