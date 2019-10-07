Class Demo.BO.TaskStatusOperation Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method GetTaskStatus(pRequest As Demo.Messages.ImageStatusRequest, Output pResponse As Demo.Messages.ImageStatusResponse) As %Status
{
	set tSC=$$$OK
	
	try
	{
		set pResponse=##class(Demo.Messages.ImageStatusResponse).%New()
		set tTaskStatusQuery = "SELECT Error,Status FROM %SYS_Task.History WHERE Name=? and DisplayLogDate=? ORDER BY DisplaylogDate DESC"
  		set tTaskStatusStatement = ##class(%SQL.Statement).%New()
  		set tSC = tTaskStatusStatement.%Prepare(tTaskStatusQuery)
   		set rset = tTaskStatusStatement.%Execute(pRequest.ServiceName,pRequest.Date)
  		Do rset.%Next(.sc)
  		If sc{
			set tStatus=rset.%Get("Status")
			set tResult=rset.%Get("Error")
  		}
  		Else{
	  		set tStatus=""
	  		set tResult=""
  		}	
		$$$TRACE("Status"_tStatus)
		$$$TRACE("Result"_tResult)
		set pResponse.Date=pRequest.Date
		set pResponse.ServiceName=pRequest.ServiceName
		set pResponse.Status=$SELECT(tStatus=1:"Completed",tStatus="":"Not Available",1:tStatus)
		set pResponse.Description=tResult
			
	} catch ex {
		s tSC = ex.AsStatus()
	}
	
	Quit tSC
}

XData MessageMap
{
<MapItems>
<MapItem MessageType="Demo.Messages.ImageStatusRequest"> 
		<Method>GetTaskStatus</Method>
</MapItem>
</MapItems>
}

}
