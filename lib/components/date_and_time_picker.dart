import 'package:flutter/material.dart';

class DateAndTimePicker{
  DateTime _date= DateTime.now();
  TimeOfDay _time= TimeOfDay.now();

  Future<DateTime> choosedate(context) async
  {
    final DateTime picked = await showDatePicker(
        context: context,
        selectableDayPredicate: (datetime){
          if(datetime.day==10)return false;

          return true;
        },
        initialDatePickerMode:  DatePickerMode.day,
        initialDate: _date,
        firstDate: DateTime(2012,12),
        lastDate: DateTime(2025,12)
    );
    return picked;
  }

  Future<TimeOfDay> chooseTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context
        , initialTime: _time);
    return picked;

  }

}