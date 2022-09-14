import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';

class SelectCityScreen extends StatefulWidget {
  SelectCityScreen(
      {Key? key,
      required this.onCountryChnaged,
      required this.onStateChanged,
      required this.onCityChnaged})
      : super(key: key);
  final Function(String) onCountryChnaged;
  final Function(String) onStateChanged;
  final Function(String) onCityChnaged;
  @override
  State<SelectCityScreen> createState() => _SelectCityScreenState();
}

class _SelectCityScreenState extends State<SelectCityScreen> {
  String countryValue = '';
  String stateValue = '';
  String cityValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 30,
                height: MediaQuery.of(context).size.height / 10,
                margin: const EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: const Image(
                  image: AssetImage('assets/icon/text.png'),
                ),
              ),
              // SizedBox(height: 25),
              // Container(
              //   alignment: Alignment.centerLeft,
              //   child: Column(
              //     children: [
              //       Text(
              //         'Your Location',
              //         style: Theme.of(context).textTheme.headline3,
              //       ),
              //     ],
              //   ),
              // )
            ],
          ),
        ),
        SizedBox(height: 30),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 300,
            child: Column(
              children: [
                SelectState(
                  onCountryChanged: (country) {
                    setState(() {
                      countryValue = country;
                    });
                    widget.onCountryChnaged(country);
                  },
                  onStateChanged: (state) {
                    setState(() {
                      stateValue = state;
                    });
                    widget.onStateChanged(state);
                  },
                  onCityChanged: (city) {
                    setState(() {
                      cityValue = city;
                    });
                    widget.onCityChnaged(city);
                  },
                ),
                InkWell(
                  onTap: () {
                    print('country selected is $countryValue');
                    print('country selected is $stateValue');
                    print('country selected is $cityValue');
                  },
                  child: Text(' Check',
                      // selectionColor: Colors.black,
                      style: TextStyle(color: Colors.black)),
                )
              ],
            )),
      ],
    );
  }
}
