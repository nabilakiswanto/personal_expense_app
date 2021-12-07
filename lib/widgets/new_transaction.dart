import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/adaptive_flat_button.dart';


class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _noteController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredNote = _noteController.text;
    final enteredAmount = double.parse(_amountController.text);
    //validation if theres some thing empty cant be added
    if (enteredNote.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return; //die
    }

    widget.addTx(
      enteredNote,
      enteredAmount,
      _selectedDate,
    );
    //automatic close after add transaction
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.only(top:10,left:10,right: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10 ,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Note'),
                controller: _noteController,
                onSubmitted: (_) => _submitData,
                // (val) {
                //   noteInput = val;
                // },
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData,
                // (val) => amountInput = val,
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ?if :else
                    Text('Date : '),
                    Text(
                           _selectedDate == null
                          ? 'No Date Chosen'
                          : DateFormat('dd-MMMM-yyyy').format(_selectedDate),
                    ),
                    AdaptiveFlatButton('choose date', _presentDatePicker),
                      
                  ],
                ),
              ),
              Platform.isIOS
              ? new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoButton(
                        color: Colors.green,
                        child: Text('Add', textAlign: TextAlign.center,),
                        onPressed: _submitData,
                      ),
                ],
              )
              : Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 3.0, color: Colors.teal),
                  ),
                  onPressed: _submitData,
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
