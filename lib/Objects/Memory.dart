import 'package:proyecto1so/Objects/ProcessList.dart';

class MemoryList{
  ProcessList Ready_List;
  double MemorySize;

  MemoryList(this.MemorySize,this.Ready_List);

  void setMemorySize(double num)=>this.MemorySize=num;
  double getMemorySize()=>this.MemorySize;
  bool isFull()=>(this.MemorySize==0);

  Init(){
    this.MemorySize=0;
    this.Ready_List.Init();
  }
}