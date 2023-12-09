class MissionariesAndCannibals{
  List<CurrentState> findParents(CurrentState? state){
    List<CurrentState> parents=[];
    while(state!=null){
      parents.add(state);
      state=state.parent;
    }
    return parents;
  }
  List<CurrentState> findSolutonByDFS(){
    final runTime=Stopwatch();
    runTime.start();

    List<CurrentState> discoverd=[];
    myStack stack=myStack();

    CurrentState state=CurrentState(3, 3, true,null);
    stack.push(state);
    while(!stack.isEmpty()){
      state=stack.pop();
      discoverd.add(state);
      if(state.isGoal()){
        runTime.stop();
        print(runTime.elapsedMicroseconds);
        return findParents(state);
      }
      if(state.isValid()){
        for(var child in Children(state)){
          if(!contain(child,discoverd) && !stack.contains(child)){
            stack.push(child);
          }
        }
      }
    }
    return [];
  }
  List<CurrentState> findSolutionByBFS() {
    final runtime = Stopwatch();
    runtime.start();

    myQueue queue = myQueue();
    List<CurrentState> discovered = [];


    CurrentState initialState = CurrentState(3, 3, true,null);
    queue.AddLast(initialState);
    while (!queue.isEmpty()) {
      CurrentState state = queue.RemoveFirst();
      discovered.add(state);

      if (state.isGoal()) {
        runtime.stop();
        print(runtime.elapsedMicroseconds);
        return findParents(state);
      }
      if (state.isValid()) {
        for (var child in Children(state)) {
          if (!contain(child, discovered) && !queue.contains(child)) {
            queue.AddLast(child);
          }
        }
      }
    }
    return [];
  }
  List<CurrentState> Children(CurrentState state){
    List<CurrentState> list=[];
    int sgin=state.boatAtRight?-1:1;
      if(state.boatAtRight?state.monster>=2:state.monster<2)
        list.add(CurrentState(state.human, state.monster+(2*sgin), !state.boatAtRight,state));
      if(state.boatAtRight?state.human>=1:state.human<3)
        list.add(CurrentState(state.human+(1*sgin), state.monster, !state.boatAtRight,state));
      if(state.boatAtRight?state.human>=2:state.human<2)
        list.add(CurrentState(state.human+(2*sgin), state.monster, !state.boatAtRight,state));
      if(state.boatAtRight?state.monster>=1:state.monster<3)
        list.add(CurrentState(state.human, state.monster+(1*sgin), !state.boatAtRight,state));
      if(state.boatAtRight?(state.monster>=1 && state.human>=1):(state.human<3 && state.monster<3))
        list.add(CurrentState(state.human+(1*sgin), state.monster+(1*sgin), !state.boatAtRight,state));

    return list;
  }
}
class myStack{
  List<CurrentState> queue=[];
  CurrentState pop(){
    return queue.removeAt(0);
  }
  void push(CurrentState state){
    queue.insert(0, state);
  }
  bool isEmpty(){
    return queue.isEmpty;
  }
  bool contains(CurrentState state){
    return contain(state,queue);
  }
}
class myQueue{
  List<CurrentState> queue=[];
  CurrentState RemoveFirst(){
    return queue.removeAt(0);
  }
  void AddLast(CurrentState state){
    queue.add(state);
  }
  bool isEmpty(){
    return queue.isEmpty;
  }
  bool contains(CurrentState state){
    return contain(state,queue);
  }
}

bool contain(CurrentState state,List list){
  for(var x in list){
    if(x.human==state.human && x.monster==state.monster && x.boatAtRight==state.boatAtRight)
      return true;
  }
  return false;
}
class CurrentState{
  CurrentState? parent=null;
  int human=3;
  int monster=3;
  bool boatAtRight=true;
  CurrentState(int human,int monster,bool boat,CurrentState? parent){
    this.parent=parent;
    this.human=human;
    this.monster=monster;
    this.boatAtRight=boat;
  }
  bool isGoal(){
    return human==0 && monster==0;
  }
  bool isValid(){
      return (human>=monster || human==0) && (3-human>=3-monster || human==3);
  }
}