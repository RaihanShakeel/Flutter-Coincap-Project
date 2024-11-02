import "dart:convert";


import "package:coin_cap/pages/details_page.dart";
import "package:coin_cap/services/http_service.dart";
import "package:flutter/material.dart";
import "package:get_it/get_it.dart";


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;

  String? _selectedCoin = 'bitcoin';
  
  HttpService? _http;

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HttpService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropdown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> coins = ['bitcoin', 'ethereum', 'tether', 'solana', 'ripple'];
    List<DropdownMenuItem<String>>  items = coins.map(
      (e) => DropdownMenuItem(
        value: e,
        child: Text(
          e,
          style: const TextStyle(
             color: Colors.white,
             fontSize: 40,
             fontWeight: FontWeight.bold
          ),
        ),
      )
    ).toList();
    return DropdownButton(
      value: _selectedCoin,
      items: items,
      onChanged: (value){
        setState(() {
          _selectedCoin = value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets(){
    return FutureBuilder(
      future: _http!.get('coins/$_selectedCoin'),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.hasData){
          Map data = jsonDecode(
            snapshot.data.toString(),
          );
          num usdPrice = data['market_data']['current_price']['usd'];
          num change24h = data['market_data']['price_change_percentage_24h'];
          Map exchangeRates = data['market_data']['current_price'];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context){
                        return DetailsPage(rates: exchangeRates,);
                      },
                    )
                  );
                },
                child: _coinImageWidget(data['image']['large'])
              ),
              _currentPriceWidget(usdPrice),
              _percentageChangeWidget(change24h),
              _coinDescriptionWidget(data['description']['en']),
              
            ],
          );
        }else{
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }
    );
  }

  Widget _currentPriceWidget(num price){
    return Text(
      "${price.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _percentageChangeWidget(num change){
    return Text(
      "${change.toString()} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w400
      ),
    );
  }

  Widget _coinImageWidget(String imageUrl){
    return Container(
      padding: EdgeInsets.symmetric(vertical: _deviceHeight!*0.02),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            imageUrl
          )
        )
      ),
    );
  }
  
  Widget _coinDescriptionWidget(String description){
    return Container(
      height: _deviceHeight! *0.45,
      width: _deviceWidth!* 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight!*0.05),
      padding: EdgeInsets.symmetric(vertical: _deviceHeight!*0.05, horizontal:_deviceHeight!*0.05),
      color: const Color.fromRGBO(83, 88, 206, 1.0),
      child:  SingleChildScrollView(
        child: Text(
          description,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
      ),
    );
  }
}