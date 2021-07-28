import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto1so/Objects/OS.dart';
import 'Menu2.dart';
import 'Objects/Memory.dart';
import 'Objects/ProcessList.dart';

class Settings extends StatefulWidget{
  /*final OS OperativeSystem;

  Settings(this.OperativeSystem);*/
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  TextEditingController V=TextEditingController(text: "");
  TextEditingController V2=TextEditingController(text: "");
  TextEditingController V3=TextEditingController(text: "");
  TextEditingController V4=TextEditingController(text: "");
  OS OperativeSystem;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      OperativeSystem=OS(0,0,0,
          ProcessList([]),
          ProcessList([]),
          MemoryList(0,ProcessList([])),
          ProcessList([]),0,5000,20);
      OperativeSystem.setConfigOS(25,2,1,5,20);
      V=TextEditingController(text: OperativeSystem.velocity.toString());
      V2=TextEditingController(text: OperativeSystem.Frequency.toString());
      V3=TextEditingController(text: OperativeSystem.Quantum.toString());
      V4=TextEditingController(text: OperativeSystem.TL.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text ("Configuración"),
        /*leading: IconButton(icon: Icon(Icons.arrow_back),
        onPressed:() =>Navigator.pop(context),),*/

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next,size: 40,color: Colors.white,),
        onPressed: (){
          setState(() {
            OperativeSystem.velocity=double.parse(V.text.trim());
            OperativeSystem.Quantum=double.parse(V3.text.trim());
            OperativeSystem.Frequency=int.tryParse(V2.text.trim());
            OperativeSystem.TL=double.parse(V4.text.trim());
          });
          Navigator.push(context, MaterialPageRoute(
              builder: (context)=>menu2(OperativeSystem))).then((value) {
            setState(() {
              OperativeSystem=OS(0,0,0,
                  ProcessList([]),
                  ProcessList([]),
                  MemoryList(0,ProcessList([])),
                  ProcessList([]),0,5000,20);
              OperativeSystem.setConfigOS(25,2,2,5,20);
            });
          });
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        child: ListView(
          children: [
            Divider(),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Selecciona Tipo de Algoritmo",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),),
            ),
            ListTile(
              selected: (OperativeSystem.Scheduling==0),
              selectedTileColor: Colors.blue[50],
              title: Text("FIFO"),
              onTap:(){
                setState(() {
                  OperativeSystem.setScheduling(0);
                });
              },
            ),
            ListTile(
              selected: (OperativeSystem.Scheduling==1),
              selectedTileColor: Colors.blue[50],
              title: Text("Shortest Job"),
              onTap:(){
                setState(() {
                  OperativeSystem.setScheduling(1);
                });
              },
            ),
            ListTile(
              selected: (OperativeSystem.Scheduling==2),
              selectedTileColor: Colors.blue[50],
              title: Text("Round Robin"),
              onTap:(){
                setState(() {
                  OperativeSystem.setScheduling(2);
                });
              },
            ),
            ListTile(
              selected: (OperativeSystem.Scheduling==3),
              selectedTileColor: Colors.blue[50],
              title: Text("Shortest Job Expulsive"),
              onTap:(){
                setState(() {
                  OperativeSystem.setScheduling(3);
                });
              },
            ),
            ListTile(
              selected: (OperativeSystem.Scheduling==4),
              selectedTileColor: Colors.blue[50],
              title: Text("Priority"),
              onTap:(){
                setState(() {
                  OperativeSystem.setScheduling(4);
                });
              },
            ),
            ListTile(
              selected: (OperativeSystem.Scheduling==5),
              selectedTileColor: Colors.blue[50],
              title: Text("Priority Expulsive"),
              onTap:(){
                setState(() {
                  OperativeSystem.setScheduling(5);
                });
              },
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Selecciona Modo de Entrada",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),),
            ),
            ListTile(
              selected: (OperativeSystem.Mode==0),
              selectedTileColor: Colors.blue[50],
              title: Text("Funcion (n/2)+5"),
              onTap:(){
                setState(() {
                  OperativeSystem.setMode(0);
                });
              },
            ),
            ListTile(
              selected: (OperativeSystem.Mode==1),
              selectedTileColor: Colors.blue[50],
              title: Text("Random"),
              onTap:(){
                setState(() {
                  OperativeSystem.setMode(1);
                });
              },
            ),
            ListTile(
              selected: (OperativeSystem.Mode==2),
              selectedTileColor: Colors.blue[50],
              title: Text("Manual"),
              onTap:(){
                setState(() {
                  OperativeSystem.setMode(2);
                });
              },
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Valor Maximo Ráfaga CPU",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),),
            ),
            TextField(
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: TextStyle(

              ),
              controller: V,
              onSubmitted: (text){
                if(double.parse(text)<=0){
                  setState(() {
                    V=TextEditingController(text: "1");
                  });
                }
                setState(() {
                  OperativeSystem.setVelocity(double.tryParse(V.text.trim()));
                });
              },
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Valor Maximo Tiempo de llegada(Modo Random)",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),),
            ),
            TextField(
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: TextStyle(

              ),
              controller: V4,
              onSubmitted: (text){
                if(double.parse(text)<=0){
                  setState(() {
                    V4=TextEditingController(text: "1");
                  });
                }
                setState(() {
                  OperativeSystem.setVelocity(double.tryParse(V.text.trim()));
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Ingresa cada cuanto se genera un proceso(Milisegundos)",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),),
            ),
            TextField(
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: TextStyle(

              ),
              controller: V2,
              onSubmitted: (text){
                if(double.parse(text)<=0){
                  setState(() {
                    V2=TextEditingController(text: "1");
                  });
                }
                setState(() {
                  OperativeSystem.setFrequency(int.tryParse(V2.text.trim()));
                });
              },
            ),
            Divider(),
            Container(
              padding: EdgeInsets.all(5),
              child: Text("Ingresa Quantum(RoundRobin)",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.blue
                ),),
            ),
            TextField(
              keyboardType: TextInputType.text,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              style: TextStyle(

              ),
              controller: V3,
              onSubmitted: (text){
                if(double.parse(text)<=0){
                  setState(() {
                    V3=TextEditingController(text: "1");
                  });
                }
                setState(() {
                  OperativeSystem.setQuantum(double.tryParse(V3.text.trim()));
                });
              },
            ),
            Divider(),
            SizedBox(height: 80,)
          ],
        ),
      ),
    );
  }
}