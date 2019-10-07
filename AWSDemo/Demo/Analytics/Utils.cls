Class Demo.Analytics.Utils Extends %RegisteredObject
{

ClassMethod CreateOrUpdateTaskHistory(TaskName As %String, TaskRunDate As %TimeStamp, TaskDate As %Date, Status As %String) As %Status
{
	set tSC=$$$OK
	set oTaskID=##class(Demo.Analytics.TaskHistory).%OpenId(TaskName_"||"_TaskDate)
	If '$IsObject(oTaskID){
		set tTask=##class(Demo.Analytics.TaskHistory).%New()
		set tTask.Status=Status
		set tTask.TaskRunDate=TaskRunDate
		set tTask.TaskName=TaskName
		set tTask.DateForWhichTaskRun=TaskDate
		do tTask.%Save()
	}Else{
		set oTaskID.Status=Status
		do oTaskID.%Save()
	}
	///Build DeepSee Cubes
	set tSC=##class(%DeepSee.Utils).%BuildCube("TaskHistory")	
	Quit tSC
}

}
