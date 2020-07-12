import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_titleController.text == null || _amountController.text == null) {
      return;
    }

    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((dateInput) {
      if (dateInput != null) {
        setState(() {
          _selectedDate = dateInput;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final titleTextField = Platform.isIOS
        ? CupertinoTextField(
            placeholder: 'Title',
            controller: _titleController,
            onSubmitted: (_) => _submitData(),
          )
        : TextField(
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            controller: _titleController,
            onSubmitted: (_) => _submitData(),
          );

    final amountTextField = Platform.isIOS
        ? CupertinoTextField(
            placeholder: 'Amount',
            controller: _amountController,
            onSubmitted: (_) => _submitData(),
          )
        : TextField(
            decoration: InputDecoration(
              labelText: 'Amount',
            ),
            controller: _amountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onSubmitted: (_) => _submitData(),
          );

    final datePickerField = Container(
      height: 70,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(_selectedDate == null
                ? 'No date chosen!'
                : 'Selected date: ${DateFormat.yMd().format(_selectedDate)}'),
          ),
          Platform.isIOS
              ? CupertinoButton(
                  child: Text(
                    'Choose Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )
                  ),
                  onPressed: _presentDatePicker,
                )
              : FlatButton(
                  onPressed: _presentDatePicker,
                  child: Text(
                    'Choose Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textColor: Theme.of(context).primaryColor,
                ),
        ],
      ),
    );

    final addTransButton = Platform.isIOS
        ? CupertinoButton(
            child: Text('Add Transaction'),
            onPressed: _submitData,
            color: Theme.of(context).primaryColor,
          )
        : RaisedButton(
            onPressed: _submitData,
            child: Text('Add Transaction'),
            color: Theme.of(context).primaryColor,
            textColor: Theme.of(context).buttonColor,
          );

    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (Platform.isIOS) Container(height: 10),
              titleTextField,
              if (Platform.isIOS) Container(height: 15),
              amountTextField,
              datePickerField,
              addTransButton,
            ],
          ),
        ),
      ),
    );
  }
}
