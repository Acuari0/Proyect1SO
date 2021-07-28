import 'package:proyecto1so/Objects/Memory.dart';
import 'package:proyecto1so/Objects/Process.dart';
import 'package:proyecto1so/Objects/ProcessList.dart';
import 'package:simple_timer/simple_timer.dart';

class OS{
  double Quantum,velocity,TL;
  int Scheduling,Mode,Frequency;
  ProcessList Works_List, Block_List;
  MemoryList Memory;
  ProcessList Executing;

  OS(this.Scheduling,
      this.velocity,
      this.Quantum,
      this.Works_List,
      this.Block_List,
      this.Memory,
      this.Executing,this.Mode,this.Frequency,this.TL);

  //Set/get
  void setQuantum(double num)=>this.Quantum=num;
  double getQuantum()=>this.Quantum;
  void setVelocity(double num)=>this.velocity=num;
  double getVelocity()=>this.velocity;
  void setScheduling(int num)=>this.Scheduling=num;
  int getScheduling()=>this.Scheduling;
  void setMode(int num)=>this.Mode=num;
  int getMode()=>this.Mode;
  void setTL(double num)=>this.TL=num;
  double getTL()=>this.TL;
  void setFrequency(int num)=>this.Frequency=num;
  int getFrequency()=>this.Frequency;
  void ClearExecuting()=>this.Executing.Init();


  void setConfigOS(double velocity,double quantum,int scheluding,double memory_size,double TL){
    this.velocity=velocity;
    this.Scheduling=scheluding;
    this.Quantum=quantum;
    this.Memory.setMemorySize(memory_size);
    this.TL=TL;
  }
  //PromedytoReadyList
  double PromedyRL(){
    double prom=0;
    this.Works_List.list.forEach((element) {
      prom+=element.ATime;
    });
    return prom/this.Works_List.list.length;
  }
  //PromedytoExcute
  double PromedyE(){
    double prom=0;
    this.Works_List.list.forEach((element) {
      prom+=element.PTime;
    });
    return prom/this.Works_List.list.length;
  }
  String CompareTimes(){
    if(PromedyRL()==PromedyE()){
      return "Iguales";
    }
    if(PromedyRL()>PromedyE()){
      return "Menor";
    }
    return "Mayor";
  }
  double PromedyBI(int quanty){

    return quanty/this.Works_List.list.length;
  }
  String getNameScheduling(){
    if(this.Scheduling==0)
      return "FIFO";
    if(this.Scheduling==1)
      return "Shortest Job";
    if(this.Scheduling==3)
      return "Shortest Job Expulsive";
    if(this.Scheduling==4)
      return("Priority");
    if(this.Scheduling==5)
      return("Priority Expulsive");
    return "Round Robin";
  }
  //doScheluding
  void doScheduling(){
    if(Scheduling==0)
      FIFO();
    if(Scheduling==1){
      ShortestJob();
    }
    if(Scheduling==2){
      RoundRobin();
    }
    if(Scheduling==3){
      ShortestJobExpulsive();
    }
    if(Scheduling==4){
      Priority();
    }
    if(Scheduling==5){
      PriorityExpulsive();
    }
  }
  //FIFO
  void FIFO(){
    if((this.Executing.list.isEmpty)&&this.Memory.Ready_List.list.isNotEmpty){
      this.Executing.addProcess(this.Memory.Ready_List.list.first);
      this.Memory.Ready_List.list.removeAt(0);

    }
    if(this.Executing.list.isNotEmpty){
      if((this.Executing.list.last.status3)&&this.Memory.Ready_List.list.isNotEmpty){
        this.Memory.Ready_List.list.first.status3=false;
        Future.delayed(Duration(milliseconds: 1),this.Memory.Ready_List.list.first.PController.reset);
        this.Executing.addProcess(this.Memory.Ready_List.list.first);
        this.Memory.Ready_List.list.removeAt(0);
      }
    }
  }
  //Shortest Job
  void ShortestJob(){
    if(this.Executing.list.isEmpty&&this.Memory.Ready_List.list.isNotEmpty){
      double lessCPU=this.Memory.Ready_List.list.first.PTime;
      int index=0, i=0;
      this.Memory.Ready_List.list.forEach((element) {
        if(element.getPTime()<lessCPU){
          lessCPU=element.getPTime();
          index=i;
        }
        i++;
      });
      this.Executing.addProcess(this.Memory.Ready_List.list[index]);
      this.Memory.Ready_List.list.removeAt(index);
    }
    if(this.Executing.list.isNotEmpty){
      if(this.Executing.list.last.status3&&this.Memory.Ready_List.list.isNotEmpty){
        double lessCPU=this.Memory.Ready_List.list.first.PTime;
        int index=0, i=0;
        this.Memory.Ready_List.list.forEach((element) {
          if(element.getPTime()<lessCPU){
            lessCPU=element.getPTime();
            index=i;
          }
          i++;
        });
        this.Memory.Ready_List.list[index].status3=false;
        Future.delayed(Duration(milliseconds: 1),this.Memory.Ready_List.list.first.PController.reset);
        this.Executing.addProcess(this.Memory.Ready_List.list[index]);
        this.Memory.Ready_List.list.removeAt(index);
      }
    }
  }
  //Round&Rolling
  void RoundRobin(){
    if(this.Executing.list.isEmpty&&this.Memory.Ready_List.list.isNotEmpty){
      FIFO();
    }
    if(this.Executing.list.isNotEmpty){
      if(this.Executing.list.last.status3&&this.Memory.Ready_List.list.isNotEmpty){
        FIFO();
      }
    }

    if(this.Block_List.list.isNotEmpty&&this.Memory.Ready_List.list.isEmpty){
      this.Memory.Ready_List.addProcess(this.Block_List.list.first);
      this.Block_List.list.removeAt(0);
    }
  }

  void ShortestJobExpulsive(){
    ShortestJob();
    if(this.Block_List.list.isNotEmpty){
      this.Memory.Ready_List.addProcess(this.Block_List.list.first);
      this.Block_List.list.removeAt(0);
    }
  }
  void Priority(){
    if(this.Executing.list.isEmpty&&this.Memory.Ready_List.list.isNotEmpty){
      int lessCPU=this.Memory.Ready_List.list.first.priority;
      int index=0, i=0;
      this.Memory.Ready_List.list.forEach((element) {
        if(element.priority<lessCPU){
          lessCPU=element.priority;
          index=i;
        }
        i++;
      });
      this.Executing.addProcess(this.Memory.Ready_List.list[index]);
      this.Memory.Ready_List.list.removeAt(index);
    }
    if(this.Executing.list.isNotEmpty){
      if(this.Executing.list.last.status3&&this.Memory.Ready_List.list.isNotEmpty){
        int lessCPU=this.Memory.Ready_List.list.first.priority;
        int index=0, i=0;
        this.Memory.Ready_List.list.forEach((element) {
          if(element.priority<lessCPU){
            lessCPU=element.priority;
            index=i;
          }
          i++;
        });
        this.Memory.Ready_List.list[index].status3=false;
        Future.delayed(Duration(milliseconds: 1),this.Memory.Ready_List.list.first.PController.reset);

        this.Executing.addProcess(this.Memory.Ready_List.list[index]);
        this.Memory.Ready_List.list.removeAt(index);
        print("PIRORI");
        Future.delayed(Duration(milliseconds: 1),this.Executing.list.last.PController.reset);

      }
    }
  }

  void PriorityExpulsive(){
    Priority();
    if(this.Block_List.list.isNotEmpty){
      this.Memory.Ready_List.addProcess(this.Block_List.list.first);
      this.Block_List.list.removeAt(0);
    }
  }

  bool isPriorityinMemory(){
    // num=(num/1000).round();
     if((this.Memory.Ready_List.list.last.priority<this.Executing.list.last.priority)){
       return true;
      }
     return false;


  }

  bool isShortinMemory(int num){
   // num=(num/1000).round();
    if(this.Memory.Ready_List.list.last.PTime<num){
      return true;
    }
    return false;
  }

  void FinishExecute(){
    this.Executing.list.clear();
  }

  Init(){
    this.Works_List.Init();
    this.Block_List.Init();
    this.Memory.Init();
    this.Executing.Init();
  }

}