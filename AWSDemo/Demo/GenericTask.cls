Class Demo.GenericTask Extends %SYS.Task.Definition
{

Parameter TaskName = "GenericTasks";

Property TaskType As %String(VALUELIST = ",Daily,HistoricDate,LastNDays");

Property HistoricDate As %String;

Property LastNDays As %String;

Property ServiceName As %String;

Method OnTask() As %Status
{
	set tSC=$$$OK
	set tSC = ..RunDailyTask(..TaskType,..HistoricDate,..LastNDays,..ServiceName)
	Quit tSC
}

ClassMethod RunDailyTask(TaskType As %String, HistoricDate As %String, LastNDays As %String, ServiceName As %String) As %Status
{
	
	Set tSC = ##class(Ens.Director).CreateBusinessService(ServiceName,.tService)

	If ($IsObject(tService)) {
   		Set schedule = ##class(Demo.Messages.Schedule).%New()
   		Set schedule.ServiceName = ServiceName
   		set schedule.TaskType= TaskType
   		set schedule.HistoricDate= HistoricDate
   		set schedule.LastNDays = LastNDays
   		set schedule.ImageDate=$ZDATE($H,3)
   		Set tSC = tService.ProcessInput(schedule,.output) 

	}

	quit tSC
}

}
