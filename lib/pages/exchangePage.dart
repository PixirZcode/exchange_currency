import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:exchange_currency/api/Exchange.dart';
import 'widgetBox.dart';
import 'package:intl/intl.dart';

class exchangePage extends StatefulWidget {
  const exchangePage({Key? key}) : super(key: key);

  @override
  State<exchangePage> createState() => _exchangePageState();
}

class _exchangePageState extends State<exchangePage> {

  late Exchange _dataFromAPI;
  final number = TextEditingController();
  var textMes = '';
  double resultNum = 0;

  @override
  void initState(){
    super.initState();
    getExchangeRate();
  }

  Future <Exchange> getExchangeRate() async{
    var url = Uri.parse("https://api.exchangerate-api.com/v4/latest/THB");
    var response = await http.get(url);
    _dataFromAPI = exchangeFromJson(response.body); // Json to dart obj.
    return _dataFromAPI;
  }

  void calcuLate(){
    var input = double.tryParse(number.text);

    if (input == null) {
      setState(() {
        textMes = 'ใส่ค่าที่ต้องการแปลง';
      });
    } else {
      setState((){
        resultNum = input;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exchange Rate'),
      ),

      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('assets/images/bg.jpg'),
        fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: getExchangeRate(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
            // ถ้าดึงข้อมูลจาก getExchange มาได้ครบ
            if(snapshot.connectionState == ConnectionState.done){
              var result = snapshot.data;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue, borderRadius: BorderRadius.circular(10)),
                  height: 125,

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "สกุลเงิน(THB) ",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),

                      Expanded(
                        child: TextField(
                          controller: number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'ใส่จำนวนเงิน'
                          ),
                        ),
                      ),
                      
                      TextButton(
                          style: ButtonStyle(foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                          onPressed: calcuLate ,
                          child:const Text("แปลง",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25)),
                      ),

                      SizedBox(height: 5),
                    ],
                  ),
                ),
                    SizedBox(height: 5),
                    widgetBox("USD", resultNum*result.rates["USD"], Colors.green, 100),
                    SizedBox(height: 5,),
                    widgetBox("EUR", resultNum*result.rates["EUR"], Colors.redAccent, 100),
                    SizedBox(height: 5,),
                    widgetBox("AED", resultNum*result.rates["AED"], Colors.pinkAccent, 100),
                    SizedBox(height: 5,),
                    widgetBox("JPY", resultNum*result.rates["JPY"], Colors.orangeAccent, 100),
                    SizedBox(height: 5,),
                    widgetBox("AUD", resultNum*result.rates["AUD"], Colors.black, 100),
                    SizedBox(height: 5,),
                    widgetBox("TWD", resultNum*result.rates["TWD"], Colors.yellow, 100),
                    SizedBox(height: 5,),
                    widgetBox("KRW", resultNum*result.rates["KRW"], Colors.purpleAccent, 100),
                  ],
                ),
              );
            }
            return LinearProgressIndicator();
        }
  ,),
      )
    );
  }
}
