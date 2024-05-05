import 'package:apitask/utils/global/values.dart';
import 'package:flutter/material.dart';

class PlaceListTile extends StatelessWidget {
  final String placeName;
  final String longLat;

  const PlaceListTile({
    super.key,
    required this.placeName,
    required this.longLat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          backgroundBlendMode: BlendMode.color, color: Colors.grey.shade300),
      child: ListTile(
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(0),
          side: BorderSide(
            strokeAlign: 1,
            color: appColorPrimary!,
          ),
        ),
        title: Text(placeName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Coordinates : $longLat'),
          ],
        ),
        trailing: Icon(color: appColorPrimary, Icons.location_on),
      ),
    );
  }
}
