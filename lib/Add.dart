import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto1so/Objects/OS.dart';
import 'package:proyecto1so/Objects/Process.dart';
import 'package:simple_timer/simple_timer.dart';

class Add extends StatefulWidget{
  final OS SystemOperative;
  Add(this.SystemOperative);
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> with TickerProviderStateMixin{
  TextEditingController V=TextEditingController(text: "");
  TextEditingController V2=TextEditingController(text: "");
  TextEditingController V3=TextEditingController(text: "");
  TextEditingController V4=TextEditingController(text: "");
  List<Process>TheProcess=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
     return Scaffold(
       appBar: AppBar(title: Text("Añade Procesos"),),
       floatingActionButton: FloatingActionButton(
         child: Icon(Icons.save,color: Colors.white,size: 40,),
         onPressed:(){
           setState(() {
             widget.SystemOperative.Works_List.list.addAll(TheProcess);
             Navigator.pop(context);
           });

         },
       ),
       body: Padding(
         padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),


           child: Center(
             child: Container(
               height: MediaQuery.of(context).size.height-180,

               width: 300,
               padding: EdgeInsets.all(10),
               decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(20),
                   border: Border.all(
                       color: Colors.blue,
                       width: 1
                   )
               ),
               child: ListView(
                 children: [

                  
                   Container(
                     padding: EdgeInsets.all(5),
                     child: Text("Nombre",
                       style: TextStyle(
                           fontWeight: FontWeight.w700,
                           color: Colors.blue
                       ),),
                   ),
                   TextField(
                     keyboardType: TextInputType.text,

                     style: TextStyle(

                     ),
                     controller: V,
                   ),
                   Container(
                     padding: EdgeInsets.all(5),
                     child: Text("Valor Tiempo de llegada",
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
                   ),

                   Container(
                     padding: EdgeInsets.all(5),
                     child: Text("Valor Ráfaga CPU",
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
                   ),
                   Container(
                     padding: EdgeInsets.all(5),
                     child: Text("Prioridad",
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
                   ),
                   SizedBox(height: 20,),
                   ElevatedButton(onPressed: (){
                     setState(() {
                       TheProcess.add(Process(
                           V.text,double.tryParse(V2.text.trim()),
                           double.tryParse(V3.text.trim()),1,false,
                           TimerController(this),
                           TimerController(this),
                           false,false,false,int.tryParse(V4.text)
                       ));
                     });

                   }, child: Text("Añadir")),
                   Divider(),
                   Container(

                     width: 200,
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(20),
                         border: Border.all(
                             color: Colors.blue,
                             width: 1
                         )
                     ),
                     child: ListView.builder(
                         physics: ScrollPhysics(),
                         itemCount: TheProcess.length,
                         shrinkWrap: true,
                         itemBuilder: (context,int index){
                           final process=TheProcess[index];
                           return Column(
                             children: [
                               ListTile(
                                 dense: true,
                                   title: Text(process
                                       .getName(),
                                     style: TextStyle(
                                         fontWeight: FontWeight.w700,
                                         color: Colors.blue
                                     ),),
                                   subtitle: Text("CPU: "+process.PTime.toString()+
                                   "\nTL: "+process.ATime.toString()),
                                 trailing: IconButton(icon: Icon(Icons.delete,
                                 color: Colors.red,size: 30,),
                                 onPressed: (){
                                   setState(() {
                                     TheProcess.removeAt(index);
                                   });
                                 },),
                               ),
                               Divider(),
                             ],
                           );
                         }
                     ),
                   )
                 ],
               ),
             ),
           ),
         ),

     );
  }
}