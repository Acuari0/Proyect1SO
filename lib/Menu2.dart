import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto1so/Add.dart';
import 'package:proyecto1so/Objects/OS.dart';
import 'package:proyecto1so/Objects/Process.dart';
import 'package:simple_timer/simple_timer.dart';


class menu2 extends StatefulWidget{
  OS SystemOperative;
  menu2(this.SystemOperative);
  @override
  _menu2State createState() => _menu2State();
}

class _menu2State extends State<menu2> with TickerProviderStateMixin {
  bool isSimulating=false,isExecuting=false,Block_process=false,go=false;

  int Time=-1,auxsubs=0,selected=-1,total_time=0, num_process=0,tota_process=0,
      total_blocks=0,selected_work=-1,selected_ready=-1;
  double count_quantum=0;
  Timer _timer,_timer2,_timer3;
  String aux="";
  var rng = new Random(),rng2 = new Random();


  double Funtion(){
    return tota_process/2+5;
  }

  Process getaProcess(){
    if(widget.SystemOperative.getMode()==0){
      return Process(
          "Proceso $tota_process",Funtion(),
          rng.nextInt(15).roundToDouble()+1,1,false,
          TimerController(this),
          TimerController(this),
          false,false,false,rng.nextInt(4)+1
      );
    }
    return Process(
        "Proceso $tota_process",rng.nextInt(widget.SystemOperative.getTL().round())
        .roundToDouble(),
        rng.nextInt(widget.SystemOperative.getVelocity().round()).roundToDouble()+1,1,false,
        TimerController(this),
        TimerController(this),
        false,false,false,rng.nextInt(4)+1
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _timer3.cancel();
    _timer2.cancel();
    _timer.cancel();
    widget.SystemOperative.Executing.list.forEach((element) {
      element.AController.dispose();
      element.PController.dispose();
    });
    widget.SystemOperative.Memory.Ready_List.list.forEach((element) {
      element.AController.dispose();
      element.PController.dispose();
    });
    widget.SystemOperative.Block_List.list.forEach((element) {
      element.AController.dispose();
      element.PController.dispose();
    });
    widget.SystemOperative.Works_List.list.forEach((element) {
      element.AController.dispose();
      element.PController.dispose();
    });
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    setState(() {

      for(int i=0;i<5;i++){
        widget.SystemOperative.Works_List.addProcess(getaProcess());
        tota_process++;
      }
    });
  }


  void SetAutomaticProcess (){
    //const  oneSec =  const Duration(milliseconds: 5000);
    _timer3 = new Timer.periodic(
      Duration(milliseconds: widget.SystemOperative.getFrequency()),
          (Timer timer) {
        setState(() {
          if(isSimulating){
            setState(() {
              widget.SystemOperative.Works_List.addProcess(getaProcess());
              tota_process++;
            });
          }
        });
      },
    );
  }

  void startTotalTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer2 = new Timer.periodic(
      oneSec,
          (Timer timer) {

          if(isSimulating&&(widget.SystemOperative.Works_List.list.length>num_process
              ||widget.SystemOperative.Memory.Ready_List.list.isNotEmpty
              ||widget.SystemOperative.Block_List.list.isNotEmpty
              ||widget.SystemOperative.Executing.list.isNotEmpty)){

              total_time+=1;



          }
          else{
            if(widget.SystemOperative.getMode()==2)
              isSimulating=false;
          }

      },
    );
  }
  void startTimer(int start,int end,TimerController a) {
    const oneSec = const Duration(milliseconds: 1000);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == end|| a.isCompleted) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            if(isSimulating){
              start+=(1000).round();
              Future.delayed(Duration(milliseconds: 100),
                  (){
                    a.start(useDelay: false,startFrom: Duration(milliseconds: end*1000-start));
                  });

              if(widget.SystemOperative.getScheduling()==2){
                if(start==widget.SystemOperative.getQuantum().round()*1000){
                  Block_process=true;
                }

              }
              if(widget.SystemOperative.getScheduling()==3){
                if(widget.SystemOperative.isShortinMemory(Duration(milliseconds: end*1000-start).inSeconds)){
                  Block_process=true;
                }
              }
              if(widget.SystemOperative.getScheduling()==5){
                if(widget.SystemOperative.isPriorityinMemory()&&widget.SystemOperative.Executing.list.last.status3==false){
                  Block_process=true;
                  print("BLOQUEO");
                }
              }
            }
            else{
              a.pause();
            }

          });
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Planificador a corto Plazo"),
        ),
        backgroundColor: Colors.grey[200],
        bottomNavigationBar: Container(color: Colors.blue,
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                child: Text("Promedio\nTiempo de Llegada:\n"+widget.SystemOperative.PromedyRL().toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(

                    color: Colors.white,
                  ),),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text("Promedio\nTiempo de Ejecución:\n"+widget.SystemOperative.PromedyE().toStringAsFixed(2)+
                    " ("+widget.SystemOperative.CompareTimes()+")",
                  textAlign: TextAlign.center,
                  style: TextStyle(

                    color: Colors.white,
                  ),),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text("Promedio\nInstrucción Bloqueada:\n"+widget.SystemOperative.PromedyBI(total_blocks).toStringAsFixed(2),
                  textAlign: TextAlign.center,
                  style: TextStyle(

                    color: Colors.white,
                  ),),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Text("Algoritmo:\n"+widget.SystemOperative.getNameScheduling(),
                  textAlign: TextAlign.center,
                  style: TextStyle(

                    color: Colors.white,
                  ),),
              )
            ],
          ),),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(selected==-1&&selected_work==-1){
              setState(() {
                isSimulating=!isSimulating;

                if(!go){
                  startTotalTimer();
                  if(widget.SystemOperative.getMode()!=2)
                    SetAutomaticProcess();
                  go=true;
                }


              });
            }
            else{
              setState(() {
                if(selected_work==0){
                  widget.SystemOperative.Works_List.list.removeAt(selected);
                }
                if(selected_work==1){
                  widget.SystemOperative.Block_List.list.removeAt(selected);
                }
                if(selected_work==2){
                  widget.SystemOperative.Memory.Ready_List.list.removeAt(selected);
                }
                selected_work=-1;
                selected=-1;
              });
            }

          },
          child: (selected>-1&&selected_work>-1)?Icon(Icons.delete,color: Colors.white,size: 50,):((isSimulating)?Icon(Icons.pause,color: Colors.white,size: 50,):
          Icon(Icons.play_arrow,color: Colors.white,size: 50,)),

        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: StreamBuilder(
            stream: Stream.periodic(Duration(milliseconds: 1)),
            builder: (context, snapshot){
              if(selected_work==2&&selected>=widget.SystemOperative.Memory.Ready_List.list.length){
                selected=-1;
                selected_work=-1;
              }
              if(selected_work==1&&selected>=widget.SystemOperative.Block_List.list.length){
                selected=-1;
                selected_work=-1;
              }
              if(isSimulating){
                Future.delayed(Duration(milliseconds: 1),(){
                }).then((value) {
                  widget.SystemOperative.doScheduling();
                });
              }
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children:<Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //Cola de Trabajo
                            Container(
                              height: MediaQuery.of(context).size.height-180,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1
                                  )
                              ),

                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text("Cola de Trabajo",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue
                                        ),),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      physics: ScrollPhysics(),
                                      itemCount: widget.SystemOperative.Works_List.list.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context,int index){
                                        // ignore: non_constant_identifier_names
                                        final process =widget.SystemOperative
                                            .Works_List.list[index];
                                        final Controller=widget.SystemOperative
                                            .Works_List.list[index].AController;

                                        if(isSimulating&&process.status2==false) {
                                          Future.delayed(Duration(seconds: 1), Controller.start);
                                          process.status2=true;
                                        }
                                        if(!isSimulating&&process.status2==true){
                                          Future.delayed(Duration(seconds: 1), Controller.pause);
                                          process.status2=false;
                                        }
                                        if(process.status==false)
                                          return  Column(
                                            children: [
                                              ListTile(
                                                selected: (index==selected&&selected_work==0),
                                                selectedTileColor: Colors.blue[50],
                                                onTap: (){
                                                  setState(() {
                                                    if(selected!=index){
                                                      selected=index;
                                                      selected_work=0;
                                                    }
                                                    else {
                                                      selected = -1;
                                                      selected_work=-1;
                                                    }
                                                  });
                                                },
                                                dense: true,
                                                tileColor: Colors.transparent,
                                                trailing: Column(
                                                  children: [
                                                    Container(
                                                        width: 70,
                                                        height: 40,
                                                        child: SimpleTimer(
                                                          duration:Duration(milliseconds:(process.ATime*1000).round(),),
                                                          controller: Controller,
                                                          onStart: (){
                                                            setState(() {

                                                            });

                                                          },
                                                          onEnd: (){
                                                            setState(()  {
                                                              widget.SystemOperative.Memory.Ready_List.addProcess(process);
                                                              //widget.SystemOperative.Works_List.list.remove(process);
                                                              process.status=true;
                                                              num_process++;
                                                              if(index==selected&&selected_work==0){
                                                                selected=-1;
                                                              }
                                                            });
                                                          },
                                                        )
                                                    )
                                                  ],
                                                ),
                                                title: Text(process
                                                    .getName(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.blue
                                                  ),),
                                                subtitle: Text("CPU: "+process.PTime.toString()+"\nPrioridad: "+process.priority.toString() ),
                                              ),
                                              Divider(),
                                            ],
                                          );
                                        return SizedBox();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Cola Block
                            Container(
                              height: MediaQuery.of(context).size.height-180,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1
                                  )
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text("Cola de Bloqueo",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue
                                        ),),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      physics: ScrollPhysics(),
                                      itemCount: widget.SystemOperative.Block_List.list.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context,int index){
                                        final process=widget.SystemOperative.Block_List.list[index];

                                        return  Column(
                                          children: [
                                            ListTile(
                                              dense: true,
                                              selected: (index==selected&&selected_work==1),
                                              selectedTileColor: Colors.blue[50],
                                              onTap: (){
                                                setState(() {
                                                  if(selected!=index){
                                                    selected=index;
                                                    selected_work=1;
                                                  }
                                                  else {
                                                    selected = -1;
                                                    selected_work=-1;
                                                  }
                                                });
                                              },
                                              tileColor: Colors.transparent,
                                              trailing: Text("Bloqueado",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.red
                                                ),),
                                              title: Text(process.getName(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.blue
                                                ),),
                                              subtitle: Text("CPU: "+process.PTime.toString()+"\nPrioridad: "+process.priority.toString()),
                                            ),
                                            Divider(),

                                          ],
                                        );
                                      },
                                    ),
                                    (selected>=0&&selected_work==1)?
                                    Container(
                                      width: 200,
                                      child: ElevatedButton(
                                          onPressed: (){
                                            setState(() {
                                              setState(()  {
                                                widget.SystemOperative.Memory.Ready_List.addProcess(
                                                    widget.SystemOperative.Block_List.list[selected]);
                                                widget.SystemOperative.Block_List.list.removeAt(selected);
                                                selected=-1;
                                                widget.SystemOperative.Memory.Ready_List.list.last.PController.reset();
                                              });
                                            });

                                          }, child: Text("Reanudar")),
                                    ):SizedBox()
                                  ],
                                ),
                              ),
                            ),
                            //Cola Listo
                            Container(
                              height: MediaQuery.of(context).size.height-180,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: Colors.blue,
                                      width: 1
                                  )
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5),
                                      child: Text("Cola Listo",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Colors.blue
                                        ),),
                                    ),
                                    Divider(),
                                    ListView.builder(
                                      physics: ScrollPhysics(),
                                      itemCount: widget.SystemOperative.Memory.Ready_List.list.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context,int index){
                                        final process1=widget.SystemOperative.Memory.Ready_List.list[index];

                                        return  Column(
                                          children: [
                                            ListTile(
                                              dense: true,
                                              tileColor: Colors.transparent,
                                              selected: (index==selected&&selected_work==2),
                                              selectedTileColor: Colors.blue[50],
                                              onTap: (){
                                                setState(() {
                                                  if(selected!=index){
                                                    selected=index;
                                                    selected_work=2;
                                                  }
                                                  else {
                                                    selected = -1;
                                                    selected_work=-1;
                                                  }
                                                });
                                              },
                                              trailing: Container(
                                                alignment: Alignment.center,
                                                width: 55,
                                                child: Container(
                                                  child: Row(
                                                    children: [
                                                      Text("Listo",
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.w700,
                                                            color: Colors.green
                                                        ),),
                                                      Icon(Icons.check_circle,color: Colors.green,)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              title: Text(process1
                                                  .getName(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.blue
                                                ),),
                                              subtitle: Text("CPU: "+process1.PTime.toString()+"\nPrioridad: "+process1.priority.toString()),
                                            ),
                                            Divider(),
                                          ],
                                        );

                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //En Ejcucion
                            Container(
                              height: MediaQuery.of(context).size.height-180,
                              width: 200,
                              child: Column(
                                children: [
                                  Container(
                                    width: 200,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.blue,
                                            width: 1
                                        )
                                    ),
                                    child: Column(children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        alignment: Alignment.topCenter,
                                        child: Text("Tiempo de Simulación",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue
                                          ),),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(Duration(seconds:total_time).toString().split('.')[0],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Colors.blue,
                                              fontSize: 25
                                          ),),
                                      ),
                                    ],),
                                  ),
                                  SizedBox(height: 50,),
                                  Container(
                                    width: 200,
                                    alignment: Alignment.topCenter,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Colors.blue,
                                            width: 1
                                        )
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text("En Ejecución",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.blue
                                            ),),
                                        ),
                                        Divider(),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Text(
                                              ((widget.SystemOperative.getScheduling()==2)?("Quantum: "+
                                          widget.SystemOperative.getQuantum().toString()):""),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.blue
                                            ),),
                                        ),
                                        Divider(),
                                        ListView.builder(
                                            physics: ScrollPhysics(),
                                            itemCount: widget.SystemOperative.Executing.list.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context,int index){

                                              final process=widget.SystemOperative.Executing.list[index];
                                              //process.PController=TimerController(this);
                                              if(process.getName()!=""&& isSimulating&&
                                                  !isExecuting&&process.status3==false){
                                                Future.delayed(Duration(milliseconds: 1),
                                                    process.PController.start).then((value) {
                                                });
                                                //process.PController.start();
                                                isExecuting=true;
                                              }

                                              if(index==widget.SystemOperative.Executing.list.length-1)
                                                return Column(
                                                children: [
                                                  ListTile(
                                                    dense: true,
                                                    tileColor: Colors.transparent,
                                                    trailing: Column(
                                                      children: [
                                                        Container(
                                                          width: 70,
                                                          height: 40,
                                                          child: SimpleTimer(
                                                            onStart: (){
                                                              if(isSimulating)

                                                                Future.delayed(Duration(milliseconds: 1),
                                                                    (){
                                                                      startTimer(0, process.PTime.round(), process.PController);
                                                                    });
                                                            },
                                                            valueListener: (time){
                                                              if(Block_process&&process.status3==false&&widget.SystemOperative.Memory.Ready_List.list.isNotEmpty){
                                                                setState(() {
                                                                  if(!widget.SystemOperative.Executing.list.last.hasbeenblocked){
                                                                    widget.SystemOperative.Executing.list.last.hasbeenblocked=true;
                                                                    total_blocks++;
                                                                  }
                                                                  if((widget.SystemOperative.Executing.list.last.PTime-time.inMilliseconds/1000).roundToDouble()==0){

                                                                  }
                                                                  else{
                                                                    widget.SystemOperative.Executing.list.last.PTime=((widget.SystemOperative.Executing.list.last.PTime-time.inMilliseconds/1000).roundToDouble());
                                                                    widget.SystemOperative.Block_List.addProcess(widget.SystemOperative.Executing.list.last);

                                                                  }
                                                                  widget.SystemOperative.Executing.list.last.status3=true;
                                                                  //process.PController.dispose();

                                                                  widget.SystemOperative.Executing.list.last.PController.pause();
                                                                  /*Future.delayed(Duration(milliseconds: 1),
                                                                          (){
                                                                            //widget.SystemOperative.Executing.list.last.PController.subtract(Duration(seconds: time.inSeconds));

                                                                          });*/
                                                                  isExecuting=false;
                                                                  Block_process=false;

                                                                });

                                                              }

                                                            },
                                                            duration:Duration(milliseconds: (process.PTime*1000).round(),),
                                                            controller: process.PController,
                                                            onEnd: (){
                                                              setState(() {
                                                                process.status3=true;
                                                                isExecuting=false;
                                                              });
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    title: Text(process
                                                        .getName(),
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.blue
                                                      ),),
                                                    subtitle: Text("CPU: "+process.PTime.toString()+"\nPrioridad: "+process.priority.toString()),
                                                  ),
                                                  Container(
                                                    width: 200,

                                                    child: ElevatedButton(
                                                        onPressed: (){
                                                          setState(() {
                                                            Block_process=true;

                                                          });
                                                        }, child: Text("Bloquear")),
                                                  )
                                                ],
                                              );
                                              return(SizedBox());

                                            }

                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  ElevatedButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context)=>Add(widget.SystemOperative))).then((value) {
                                      setState(() {

                                      });
                                    });
                                  }, child: Text("Añadir Proceso")),
                                  SizedBox(height: 30,),
                                  ElevatedButton(onPressed: (){
                                    setState(() {
                                      isSimulating=false;
                                      isExecuting=false;
                                      widget.SystemOperative.Init();
                                      for(int i=0;i<5;i++){
                                        widget.SystemOperative.Works_List.addProcess(getaProcess());
                                        tota_process++;
                                      }
                                      Time=-1;
                                      auxsubs=0;selected=-1;
                                      total_time=0;
                                      num_process=0;
                                      tota_process=0;
                                      total_blocks=0;selected_work=-1;
                                      selected_ready=-1;
                                      _timer.cancel();
                                      _timer2.cancel();
                                      _timer3.cancel();

                                    });
                                  }, child: (Text("Reset"))),
                                  
                                ],
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  )
              );
            }
        )
    );
  }
}