import 'Process.dart';

class ProcessList{
  List<Process>list;

  ProcessList(this.list);
  void setProcessList(List<Process> list)=>this.list=list;
  getProcessList()=>this.list;
  void addProcess(Process process)=>this.list.add(process);

  Init(){
    list=[];
  }
}