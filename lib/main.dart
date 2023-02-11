import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

// Model
class CompoundInterestModel {
  double principal = 0.0;
  double rate = 0.0;
  int time = 0;

  double get compoundInterest => principal * pow(1 + rate / 100, time);
}

// ViewModel
class CompoundInterestViewModel {
  final CompoundInterestModel _model;
  StreamController<CompoundInterestModel> _modelStreamController =
      StreamController<CompoundInterestModel>();

  CompoundInterestViewModel(this._model) {
    _modelStreamController.add(_model);
  }

  Stream<CompoundInterestModel> get modelStream =>
      _modelStreamController.stream;

  void updatePrincipal(double principal) {
    _model.principal = principal;
    _modelStreamController.add(_model);
  }

  void updateRate(double rate) {
    _model.rate = rate;
    _modelStreamController.add(_model);
  }

  void updateTime(int time) {
    _model.time = time;
    _modelStreamController.add(_model);
  }

  void dispose() {
    _modelStreamController.close();
  }
}

// View (main.dart)
class CompoundInterestCalculator extends StatefulWidget {
  @override
  State<CompoundInterestCalculator> createState() => _CompoundInterestCalculatorState();
}

class _CompoundInterestCalculatorState extends State<CompoundInterestCalculator> {
  final CompoundInterestViewModel _viewModel = CompoundInterestViewModel(CompoundInterestModel(),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intérêts composés'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<CompoundInterestModel>(
          stream: _viewModel.modelStream,
          initialData: CompoundInterestModel(),
          builder: (context, snapshot) {
            return Column(
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Montant'),
                  keyboardType: TextInputType.number,
                  onChanged: (text) =>
                      _viewModel.updatePrincipal(double.parse(text)),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Taux'),
                  keyboardType: TextInputType.number,
                  onChanged: (text) =>
                      _viewModel.updateRate(double.parse(text)),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Temps (en années)'),
                  keyboardType: TextInputType.number,
                  onChanged: (text) =>
                      _viewModel.updateTime(int.parse(text)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                      'Intérêts composés: ${snapshot.data!.compoundInterest}'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CompoundInterestCalculator(),
  ));
}