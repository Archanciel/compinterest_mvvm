import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// Model
class CompoundInterestModel {
  double principal = 1000.0;
  double rate = 5.0;
  int time = 10;

  double get compoundInterest => principal * pow(1 + rate / 100, time);
}

// ViewModel
class CompoundInterestViewModel {
  final CompoundInterestModel model;
  final StreamController<double> _principalController =
      StreamController<double>();
  final StreamController<double> _rateController = StreamController<double>();
  final StreamController<int> _timeController = StreamController<int>();

  CompoundInterestViewModel(this.model) {
    _principalController.add(model.principal);
    _rateController.add(model.rate);
    _timeController.add(model.time);
  }

  Stream<double> get principalStream => _principalController.stream;
  Stream<double> get rateStream => _rateController.stream;
  Stream<int> get timeStream => _timeController.stream;
  Stream<double> get compoundInterestStream => Rx.combineLatest3(
      principalStream,
      rateStream,
      timeStream,
      (p, r, t) => p * pow(1 + (r / 100), t));

  void updatePrincipal(double value) {
    model.principal = value;
    _principalController.add(value);
  }

  void updateRate(double value) {
    model.rate = value;
    _rateController.add(value);
  }

  void updateTime(int value) {
    model.time = value;
    _timeController.add(value);
  }

  int get time => model.time;

  void dispose() {
    _principalController.close();
    _rateController.close();
    _timeController.close();
  }
}

class CompoundInterestCalculator extends StatefulWidget {
  @override
  _CompoundInterestCalculatorState createState() =>
      _CompoundInterestCalculatorState();
}

class _CompoundInterestCalculatorState
    extends State<CompoundInterestCalculator> {
  final CompoundInterestViewModel _viewModel =
      CompoundInterestViewModel(CompoundInterestModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<double>(
            stream: _viewModel.principalStream,
            initialData: _viewModel.model.principal,
            // TextFormField enables using initialValue
            builder: (context, snapshot) => TextFormField(
              onChanged: (value) =>
                  _viewModel.updatePrincipal(double.parse(value)),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Montant principal'),
              initialValue: snapshot.data.toString(),
            ),
          ),
          StreamBuilder<double>(
            stream: _viewModel.rateStream,
            initialData: _viewModel.model.rate,
            builder: (context, snapshot) => TextFormField(
              onChanged: (value) => _viewModel.updateRate(double.parse(value)),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Taux'),
              initialValue: snapshot.data.toString(),
            ),
          ),
          StreamBuilder<int>(
            stream: _viewModel.timeStream,
            initialData: _viewModel.model.time,
            builder: (context, snapshot) => TextFormField(
              style: const TextStyle(fontSize: 20.0),
              onChanged: (value) => _viewModel.updateTime(int.parse(value)),
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Durée',
                labelStyle: TextStyle(fontSize: 20.0),
              ),
              initialValue: snapshot.data.toString(),
            ),
          ),
          StreamBuilder<double>(
            stream: _viewModel.compoundInterestStream,
            initialData: _viewModel.model.compoundInterest,
            builder: (context, snapshot) => Text(
              'Intérêts composés: ${snapshot.data}',
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: CompoundInterestCalculator(),
  ));
}
