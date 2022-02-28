

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:sonnen_rennt/structs/run.dart';

import 'package:intl/intl.dart';

class RadioTileGroupWidget extends StatefulWidget {

  RadioTileGroupWidget({this.value, this.setGlobalType});

  RunType value;
  Function setGlobalType;

  @override
  _RadioTileGroupWidgetState createState() => _RadioTileGroupWidgetState(
    value: value,
    setGlobalType: setGlobalType,
  );
}

class _RadioTileGroupWidgetState extends State<RadioTileGroupWidget> {

  _RadioTileGroupWidgetState({this.value, this.setGlobalType});

  RunType value;
  Function setGlobalType;

  void setLocalType(RunType type) {
    value = type;
    setState(() {
      setGlobalType(type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white,),
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
        children: [
          RadioTileWidget(
            type: RunType.WALK,
            globalType: value,
            setGlobalType: setLocalType,
          ),
          RadioTileWidget(
            type: RunType.RUN,
            globalType: value,
            setGlobalType: setLocalType,
          ),
          RadioTileWidget(
            type: RunType.BIKE,
            globalType: value,
            setGlobalType: setLocalType,
          ),
          RadioTileWidget(
            type: RunType.E_BIKE,
            globalType: value,
            setGlobalType: setLocalType,
          ),
        ],
      ),
    );
  }
}

class RadioTileWidget extends StatelessWidget {

  RadioTileWidget({this.type, this.globalType, this.setGlobalType});

  RunType type, globalType;
  Function setGlobalType = () {};

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {
        setGlobalType(type);
      },
      child: ListTile(
        title: Text(
          Run.getTypeTitle(type),
          style: TextStyle(color: Colors.white),),
        leading: Radio<RunType>(
          value: type,
          activeColor: Colors.white,
          groupValue: globalType,
          focusColor: Colors.white,
          onChanged: (RunType value) {
            globalType = value;
            setGlobalType(value);
          },
        ),
      ),
    );
  }
}

// ============================================================================

class BasicDateTimeField extends StatefulWidget {

  BasicDateTimeField({this.value, this.setValue});

  DateTime value;
  Function setValue;

  @override
  _BasicDateTimeFieldState createState() => _BasicDateTimeFieldState(
    value: value,
    setValue: setValue,
  );

}

class _BasicDateTimeFieldState extends State<BasicDateTimeField> {

  _BasicDateTimeFieldState({this.value, this.setValue});

  DateTime value;
  Function setValue;

  final format = DateFormat("yyyy-MM-dd HH:mm");

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(children: <Widget>[
        SizedBox(height: 8,),
        Text('Startzeit (${format.pattern})', style: TextStyle(color: Colors.white),),
        DateTimeField(
          format: format,
          initialValue: value,
          cursorColor: Colors.white,
          resetIcon: Icon(Icons.close, color: Colors.white,),
          style: TextStyle(
              color: Colors.white,
              decorationColor: Colors.white),
          decoration: InputDecoration(
            fillColor: Colors.white,
            focusColor: Colors.white,
            hoverColor: Colors.white,
          ),
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2400));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              value = DateTimeField.combine(date, time);
            } else {
              value = currentValue;
            }
            setValue(value);
            return value;
          },
        ),
        SizedBox(height: 4,),
      ]),
    );
  }

}

// ============================================================================

class BasicDurationField extends StatefulWidget {

  BasicDurationField({this.value, this.setValue});

  Duration value;
  Function setValue;

  _BasicDurationFieldState lastState;

  @override
  _BasicDurationFieldState createState() {
    return _BasicDurationFieldState(
      duration: value,
      setValue: setValue,
    );
  }
}

class _BasicDurationFieldState extends State<BasicDurationField> {

  _BasicDurationFieldState({this.duration, this.setValue});

  Duration duration = Duration(minutes: 20);
  Function setValue;

  static durationToString(Duration d) {
    if (d == null) return "";
    int hours = d.inHours % 24;
    int minutes = d.inMinutes % 60;
    int seconds = d.inSeconds % 60;
    return hours.toString() + "h "
        + minutes.toString() + "min";
    // + seconds.toString() + "sek";
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () async {
        Duration resultingDuration = await showDurationPicker(
          context: context,
          initialTime: duration,
          snapToMins: 1.0,
        );
        if (resultingDuration != null) {
          setValue(resultingDuration);
          setState(() {
            duration = resultingDuration;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Container(
          child: Column(children: <Widget>[
            SizedBox(height: 8,),
            Text('Dauer', style: TextStyle(color: Colors.white),),
            Container(
              child: Row(
                children: [
                  Icon(Icons.timer, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text(durationToString(duration), style: TextStyle(color: Colors.white),),
                ],
              ),
            ),
            SizedBox(height: 14,),
          ]),
        ),
      ),
    );
  }
}
