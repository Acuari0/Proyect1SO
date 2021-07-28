
import 'package:simple_timer/simple_timer.dart';

class Process {
  double ATime,PTime,Memory;
  String name;
  bool status,status2,hasbeenblocked,status3;
  int priority;
  TimerController AController,PController;
  Process(this.name,
      this.ATime,
      this.PTime,
      this.Memory,
      this.status,
      this.AController,
      this.PController,
      this.status2,this.hasbeenblocked,this.status3,this.priority);

  void setATime(double num)=>this.ATime=num;
  void setPTime(double num)=>this.PTime=num;
  void setMemory(double num)=>this.Memory=num;
  void setName(String name)=>this.name=name;
  void setStatus(bool status)=>this.status=status;
  double getATime()=>this.ATime;
  double getPTime()=>this.PTime;
  double getMemory()=>this.Memory;
  String getName()=>this.name;
  bool getStatus()=>this.status;

  Init(){
    this.ATime=0;
    this.PTime=0;
    this.Memory=0;
    this.name=" ";
    this.status=false;
  }
}