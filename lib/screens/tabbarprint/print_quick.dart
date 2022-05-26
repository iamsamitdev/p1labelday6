// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:p1label/components/elevated_full_button.dart';
import 'package:p1label/screens/tabbarprint/data_print_quick.dart';
import 'package:p1label/services/api.dart';
import 'package:p1label/themes/colors.dart';
import 'package:p1label/utils/constants.dart';

class PrintQuickScreen extends StatefulWidget {
  const PrintQuickScreen({Key? key}) : super(key: key);

  @override
  State<PrintQuickScreen> createState() => _PrintQuickScreenState();
}

class _PrintQuickScreenState extends State<PrintQuickScreen> {
  
  bool ckSF = false;
  bool ckBS = true;

  final FocusNode _focusNode = FocusNode();

  // สร้างตัวแปรไว้รับคียร์ที่กด
  List<LogicalKeyboardKey> keys = [];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  // Enter จัดเก็บ
  void saveLabel(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: blueColor,
      content: Text('บันทึกรายการนี้แล้ว', textAlign: TextAlign.center,)
    ));
  }

  // Shift + P สั่งพิมพ์
  void printLabel(){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      backgroundColor: dartGreenColor,
      content: Text('สั่งปริ้นรายการนี้แล้ว', textAlign: TextAlign.center,)
    ));
  }

  // Shift + Q ฟังก์ชันกลับหน้า home
  void backtoHome(){
    Navigator.pushNamed(context, '/home');
  }
  // shift + p = พิมพ์
  // enter = จัดเก็บ
  // shift + q = ออก

  List product = [];

  void scanProduct(barcode) async {
    // print(barcode);
    var data = await CallAPI().readProduct(barcode);
    // ฟิลเตอร์ barcode ที่รับเข้ามา
    setState(() {
      product = data.where((map)=>map["barcode"]==barcode).toList();
    });
    inspect(product);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: _focusNode,
      onKey: (event){
        final key = event.logicalKey; // ตัวแปรรับค่า key ที่กดเข้ามา
        if(event is RawKeyDownEvent){
          // เช็คว่ามีการกด keys เดิมไปหรือยัง
          if(keys.contains(key)) return;

          // Enter จัดเก็บ
          if(event.isKeyPressed(LogicalKeyboardKey.keyS)){
            print('You press enter');
            saveLabel();
          }
          
          // Shift + P พิมพ์
          if(event.isKeyPressed(
            LogicalKeyboardKey.f1) || 
            (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) && 
            event.isKeyPressed(LogicalKeyboardKey.keyP))){
              printLabel();
          }

          // Shift + Q ออก
          if(event.isKeyPressed(
            LogicalKeyboardKey.f4) || 
            (event.isKeyPressed(LogicalKeyboardKey.shiftLeft) && 
            event.isKeyPressed(LogicalKeyboardKey.keyQ))){
              backtoHome();
          }

          setState(() {keys.add(key);});
        }else{
          // ลบ key เดิมออกจาก list
          setState(() {keys.remove(key);});
        }
      },
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top:10.0, left: 10, right: 10),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                child: dataPrintQuick(
                  ckSF: ckSF,
                  onChangedSF: (val) {
                    setState(() {
                      ckSF = val!;
                      if (kDebugMode) {
                        print('Check SF: $ckSF');
                      }
                    });
                  },
                  ckBS: ckBS,
                  onChangedBS: (val) {
                    setState(() {
                      ckBS = val!;
                      if (kDebugMode) {
                        print('Check BS: $ckBS');
                      }
                    });
                  },
                  data: product,
                ),
              ),
      
              // Button
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                child: ElevatedFullButton(
                  icon: Icons.settings_outlined,
                  iconColor: white_color,
                  iconSize: TEXT_SIZE_Normal,
                  name: 'กำหนดเครื่องพิมพ์ กดปุ่มนี้',
                  fontSize: TEXT_SIZE_SMedium,
                  height: 35,
                  textColor: white_color,
                  btnColor: primaryColor,
                  onPressed: (){
                    if (kDebugMode) {
                      print('Setting');
                      // _handleKeyEvent();
                    }
                  },
                ),
              ),
      
              // Button Group
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ElevatedFullButton(
                        name: 'พิมพ์',
                        icon: Icons.print_outlined,
                        iconColor: white_color,
                        iconSize: TEXT_SIZE_Medium,
                        textColor: white_color,
                        btnColor: greenColor,
                        onPressed: printLabel,
                        height: 30,
                        fontSize: TEXT_SIZE_SMedium,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedFullButton(
                      name: 'จัดเก็บ',
                      icon: Icons.save_outlined,
                      iconColor: white_color,
                      iconSize: TEXT_SIZE_Medium,
                      textColor: white_color,
                      btnColor: Colors.purple,
                      onPressed: saveLabel,
                      height: 30,
                      fontSize: TEXT_SIZE_SMedium,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: ElevatedFullButton(
                        name: 'ออก',
                        icon: Icons.exit_to_app,
                        iconColor: white_color,
                        iconSize: TEXT_SIZE_Medium,
                        textColor: white_color,
                        btnColor: Colors.grey,
                        onPressed: (){
                          Navigator.popAndPushNamed(context, '/home');
                        },
                        height: 30,
                        fontSize: TEXT_SIZE_SMedium,
                      ),
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}