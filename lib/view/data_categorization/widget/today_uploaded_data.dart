import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/provider/data_provider.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';
import 'package:provider/provider.dart';

class TodayUploadedData extends StatefulWidget {

  final List<String> selectedCategories;

  final bool isLoadingTodayData;

  const TodayUploadedData({super.key, required this.selectedCategories, required this.isLoadingTodayData});

  @override
  State<TodayUploadedData> createState() => _TodayUploadedDataState();
}

class _TodayUploadedDataState extends State<TodayUploadedData> {
  // bool _isLoading = true;
  @override
  void initState() {
    // fetchTodayData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Data> filteredTodayData =  Provider.of<DataProvider>(context).filteredData(widget.selectedCategories);
    List<Data> data =  Provider.of<DataProvider>(context).dataList;
    // _isLoading = widget.isLoadingTodayData;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.isLoadingTodayData ? const SizedBox() :
          
          // Text(
          //   "Today Uploaded Data (${filteredTodayData.length})",
          //   style: Theme.of(context).textTheme.bodyLarge,
          // ),
          
          widget.isLoadingTodayData ? const BallPulseIndicator() :
          data.isEmpty ? Center(
            child: Text(
            'No data available',
            style: Theme.of(context).textTheme.bodyLarge,
            )
          ):
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            reverse: true,
            itemCount: filteredTodayData.length,
            itemBuilder: (BuildContext context, int index) {
              var dat = filteredTodayData[index];
              return Card(
                elevation: 3,
                shape: const  RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))
                ),
                child: ListTile(
                  title: Text(
                    dat.item,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    dat.id.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  trailing: Text(
                    dat.number,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> fetchTodayData()async{
    await Provider.of<DataProvider>(context, listen: false).fetchTodayData(context);
    setState(() {
      // _isLoading = false;
    });
  }
}