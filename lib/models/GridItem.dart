import 'package:flutter/material.dart';
import 'package:flutter_interview_test/models/GridItemData.dart';
import '../functions/format_currency.dart';

class GridItem extends StatelessWidget {
  final GridItemData data;
  const GridItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Bàn ${data.id}',
            style: const TextStyle(color: Colors.black, fontSize: 14),
          ),
          if (data.state != "Bàn trống" && data.time != null)
            Text(
            data.time != null ? '${data.time!.hour}:${data.time!.minute.toString().padLeft(2, '0')}' : '',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Text(
            data.state,
            style: TextStyle(
              color: data.state == 'Bàn trống'
                  ? Colors.yellow.shade700
                  : data.state == 'Gọi món'
                  ? Colors.red
                  : data.state == 'Chờ món'
                  ? Colors.orange
                  : Colors.green,
              fontSize: 14,
              fontWeight: FontWeight.bold,

            ),
          ),
          Text(
            data.price != null ? '${formatCurrency(data.price)}đ' : '',
            style: const TextStyle(color: Colors.black, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}