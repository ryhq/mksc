import 'package:flutter/material.dart';
import 'package:mksc/model/data.dart';
import 'package:mksc/services/population_data_services.dart';
import 'package:mksc/widgets/ball_pulse_indicator.dart';

class TodayUploadedData extends StatefulWidget {
  const TodayUploadedData({super.key});

  @override
  State<TodayUploadedData> createState() => _TodayUploadedDataState();
}

class _TodayUploadedDataState extends State<TodayUploadedData> {
  List<Data> data = [];
  bool _isLoading = true;
  @override
  void initState() {
    fetchTodayData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today Uploaded Data",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        
        _isLoading ? const BallPulseIndicator() :
        data.isEmpty ? Center(
          child: Text(
          'No data available',
          style: Theme.of(context).textTheme.bodyLarge,
          )
        ):
        ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            var dat = data[index];
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
                  dat.number,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Text(
                  dat.id.toString(),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> fetchTodayData()async{
    List<Data> fetchedData = await PopulationDataServices.fetchTodayData(context);
    for (var data in fetchedData) {
      debugPrint("${data.id} : ${data.item} :${data.number}");
    }
    setState(() {
      data = fetchedData;
      _isLoading = false;
    });
  }
}