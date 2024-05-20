class Tarefas{
	static int id=0;
	int? childId;
	int preferencia;
	String tarefa,data;
	Function? remove,update;
	Tarefas(this.tarefa,this.data,this.preferencia,{this.childId,this.remove,update});
}
