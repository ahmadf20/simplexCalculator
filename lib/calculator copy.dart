import 'package:flutter/material.dart';

int totalVar = 0;
int totalConstaint = 0;

///[0] -> variable
///[1] -> constant
List<List<dynamic>> targetData = List(2);

List<TextEditingController> listTargetTC = [];
List<List<TextEditingController>> listTC = [];

List<String> valOp = [];

class CalculatorScreen extends StatefulWidget {
  CalculatorScreen({Key key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  TextEditingController varTC = TextEditingController();
  TextEditingController conTC = TextEditingController();

  List listType = ['Max', 'Min'];
  String valType = 'Max';

  List listOp = ['>=', '<=', '='];

  bool isTableShown = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Simplex Calculator')),
      ),
      body: Center(
        child: Container(
          child: ListView(
            padding: EdgeInsets.all(25),
            children: [
              Row(
                children: [
                  Text('Total Variabel = '),
                  Container(
                    width: 50,
                    child: TextFormField(
                      controller: varTC,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelStyle: TextStyle(height: 0.75),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('Total Kendala = '),
                  Container(
                    width: 50,
                    child: TextFormField(
                      controller: conTC,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5)),
                        labelStyle: TextStyle(height: 0.75),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: 50,
                    height: 40,
                    child: FlatButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        totalVar = int.parse(varTC.text);
                        totalConstaint = int.parse(conTC.text);

                        listTC.clear();
                        listTargetTC.clear();

                        isTableShown = false;

                        //prepare TC for contraints & target
                        for (var i = 0; i < totalConstaint; i++) {
                          listTC.add(List<TextEditingController>());
                          for (var j = 0; j < totalVar; j++) {
                            listTC[i].add(TextEditingController());
                            listTargetTC.add(TextEditingController());
                          }
                          listTC[i].add(TextEditingController());
                        }

                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Divider(thickness: 1),
              ),
              totalVar == 0 || totalConstaint == 0
                  ? Container()
                  : Container(
                      height: 50,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: target(totalVar),
                      ),
                    ),
              totalVar == 0 || totalConstaint == 0
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: Text(
                        'Subject to',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              totalVar == 0 || totalConstaint == 0
                  ? Container()
                  : ListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: kendala(totalConstaint, totalVar),
                    ),
              Container(
                height: 40,
                margin: EdgeInsets.only(top: 20),
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Hitung',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    isTableShown = true;
                    setState(() {});
                  },
                ),
              ),
              SizedBox(height: 30),
              !isTableShown ? Container() : StepTable(),
              // (data.isNotEmpty) ? stepTable() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> kendala(int conts, int variable) {
    List<Widget> listConstraint = [];

    for (var i = 0; i < conts; i++) {
      valOp.add('<=');

      List<Widget> list = [];
      for (var j = 0; j < variable; j++) {
        list.add(
          Container(
            width: 50,
            child: TextFormField(
              controller: listTC[i][j],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
        list.add(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('X${j + 1} ${(j < variable - 1) ? '+' : ''}'),
          ),
        );
      }
      list.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton(
            underline: Container(),
            value: valOp[i],
            items: listOp.map((value) {
              return DropdownMenuItem(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                valOp[i] = value;
              });
            },
          ),
        ),
      );
      listTC[i].add(TextEditingController());
      list.add(
        Container(
          width: 50,
          child: TextFormField(
            controller: listTC[i][variable],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      listConstraint.add(
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: list,
            ),
          ),
        ),
      );
    }

    return listConstraint;
  }

  List<Widget> target(int n) {
    List<Widget> list = [
      DropdownButton(
        underline: Container(),
        value: valType,
        items: listType.map((value) {
          return DropdownMenuItem(
            child: Text(value),
            value: value,
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            valType = value;
          });
        },
      ),
      Container(
        margin: EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text('Z = '),
      ),
    ];

    for (var i = 0; i < n; i++) {
      list.add(
        Container(
          width: 50,
          child: TextFormField(
            controller: listTargetTC[i],
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
      list.add(
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text('X${i + 1} ${(i < n - 1) ? '+' : ''}'),
        ),
      );
    }
    return list;
  }
}

class StepTable extends StatefulWidget {
  const StepTable({Key key}) : super(key: key);

  @override
  _StepTableState createState() => _StepTableState();
}

class _StepTableState extends State<StepTable> {
  ///[0] -> variable
  ///[1] -> constant
  List<double> targetBarData = [];
  List<List<dynamic>> basisList = List(2);
  List<List<double>> data = [];

  double optimal = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];
    initialize();

    int limit = 0;

    list.add(printTable());
    do {
      iteration();
      list.add(printTable());
      limit++;
    } while (targetBarData.every(
            (element) => double.parse(element.toString()) > 0 ? true : false) &&
        limit < 10);

    iteration();
    list.add(printTable());

    list.add(
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Text(
          'Nilai Optimum',
        ),
      ),
    );

    list.add(
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          'Z = ${optimal.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );

    list.add(
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 10),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: totalVar,
          itemBuilder: (context, index) {
            var val = data[index].last;
            return Text(
              '${targetData[0][index]} = ${val.toStringAsFixed(2)}    ',
              textAlign: TextAlign.center,
            );
          },
        ),
      ),
    );

    return Column(children: list);
  }

  void iteration() {
    //find the entering variable (column)
    //TODO: implement min
    var enteringVarIndex = 0;
    double tempCjBar = -9999;

    for (var i = 0; i < targetBarData.length; i++) {
      if (targetBarData[i] > tempCjBar) {
        tempCjBar = targetBarData[i];
        enteringVarIndex = i;
      }
    }

    //find the leaving variable (row)
    var leavingVarIndex = 0;
    double rowRatio = 9999;

    for (var i = 0; i < basisList[0].length; i++) {
      var ratio = data[i].last / data[i][enteringVarIndex];

      if (rowRatio > ratio && ratio >= 0) {
        rowRatio = ratio;
        leavingVarIndex = i;
      }
    }

    //OBE column pivot
    var pivot = data[leavingVarIndex][enteringVarIndex];
    for (var i = 0; i < data[leavingVarIndex].length; i++) {
      data[leavingVarIndex][i] /= pivot;
    }

    for (var i = 0; i < basisList[0].length; i++) {
      if (i != leavingVarIndex) {
        var divider = data[i][enteringVarIndex];

        for (var j = 0; j < data[i].length; j++) {
          if (divider < 0) {
            data[i][j] += data[leavingVarIndex][j] * divider.abs();
          } else if (divider > 0) {
            data[i][j] -= data[leavingVarIndex][j] * divider.abs();
          }
        }
      }
    }

    //change the basis to the entering variable
    basisList[0][leavingVarIndex] = targetData[0][enteringVarIndex];
    basisList[1][leavingVarIndex] = targetData[1][enteringVarIndex];
    //update cj bar
    for (var i = 0; i < targetBarData.length; i++) {
      var temp = 0.0;
      for (var j = 0; j < basisList[1].length; j++) {
        temp += basisList[1][j] * data[j][i];
      }
      targetBarData[i] = targetBarData[i] - temp;
    }
  }

  void initialize() {
    data = [];
    //transfering the data from the forms to the data
    for (var i = 0; i < totalConstaint; i++) {
      data.add([]);
      for (var j = 0; j <= totalVar; j++) {
        data[i].add(double.parse(listTC[i][j].text));
      }
    }

    //membuat bentuk standar
    for (var i = 0; i < totalConstaint; i++) {
      if (valOp[i] != '=') {
        for (var j = 0; j < totalConstaint; j++) {
          if (i == j) {
            data[j].insert(data[j].length - 1, (valOp[j] == '>=') ? -1 : 1);
          } else {
            data[j].insert(data[j].length - 1, 0);
          }
        }
      }
    }

    //storing target cj data
    targetData[0] = [];
    targetData[1] = [];
    for (var i = 0; i < data[0].length - 1; i++) {
      if (i < totalVar) {
        targetData[1].add(double.parse(listTargetTC[i].text));
      } else {
        targetData[1].add(0.0);
      }
      targetData[0].add('X${i + 1}');
    }
    targetBarData = <double>[...targetData[1]];

    //TODO: consider other cases
    //storing inisial basis &
    basisList[0] = [];
    basisList[1] = [];
    for (var i = totalVar; i < data[0].length - 1; i++) {
      basisList[0].add('X${i + 1}');
      basisList[1].add(targetData[1][i]);
    }

    print(data);
    print(targetData);
    setState(() {});
  }

  Widget printTable() {
    //TODO: condiser big M method and some other case
    // - when target doesnt consist of all the variables
    // - minimalization
    // - one(s) of the variables is <= which mankes the 1 to be negative

    TableRow cells(prefix1, prefix2, suffix, List list) {
      List<Widget> listWidget = [];

      list.forEach((element) {
        listWidget.add(Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            (list[0] is double || list[0] is int)
                ? element.toStringAsFixed(2)
                : element.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
      });

      return TableRow(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(prefix1),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(prefix2),
          ),
          ...listWidget,
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(suffix),
          ),
        ],
      );
    }

    List<Widget> dataCells(int row) {
      List<Widget> list = [];
      for (var i = 0; i < data[row].length; i++) {
        list.add(
          Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            child: Text(
              data[row][i].toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
      return list;
    }

    List<TableRow> rowCells() {
      List<TableRow> list = [];
      for (var i = 0; i < data.length; i++) {
        list.add(
          TableRow(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(basisList[1][i].toString()),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(basisList[0][i].toString()),
              ),
              ...dataCells(i),
            ],
          ),
        );
      }
      return list;
    }

    //find z
    double z = 0;
    for (var i = 0; i < basisList[0].length; i++) {
      z += basisList[1][i] * data[i].last;
    }

    optimal = z;

    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Table(
        border: TableBorder.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 1,
        ),
        children: [
          cells('', 'CJ', '', targetData[1]),
          cells('Cb', 'Basis', 'Const', targetData[0]),
          ...rowCells(),
          cells('', 'CJ\'', '${z.toStringAsFixed(2)}', targetBarData),
        ],
      ),
    );
  }
}
