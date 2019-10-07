Class Demo.BS.ImageDownloadService Extends Ens.BusinessService
{

Parameter ADAPTER = "Ens.InboundAdapter";

Property TargetConfigName As %String;

Parameter SETTINGS = "TargetConfigName";

Method OnProcessInput(pInput As Demo.Messages.Schedule, Output pOutput As %RegisteredObject) As %Status
{
	set tSC=$$$OK
	If (pInput.TaskType="Daily") {
		set ImageDate=$ZDATE($H-1,3)
		set pInput.ImageDate=ImageDate
		
		set tSC= ..SendRequestAsync(..TargetConfigName,pInput)
		///Task History
		set tSC=##class(Demo.Analytics.Utils).CreateOrUpdateTaskHistory(pInput.ServiceName,$ZDATETIME($H,3),$ZDATEH(pInput.ImageDate,5),"STARTED")
	
	
	}
	ElseIf (pInput.TaskType="HistoricDate"){
		set pInput.ImageDate=pInput.HistoricDate
		set tSC= ..SendRequestAsync(..TargetConfigName,pInput)
		///Task History
		set tSC=##class(Demo.Analytics.Utils).CreateOrUpdateTaskHistory(pInput.ServiceName,$ZDATETIME($H,3),$ZDATEH(pInput.ImageDate,5),"STARTED")

	}		
	ElseIf (pInput.TaskType="LastNDays"){
		set NoOfDays="",ImageDate="",i=""
		set NoOfDays= pInput.LastNDays
		for i=1:1:NoOfDays{
			
			set tRequest=$$$NULLOREF
			set tRequest=##class(Demo.Messages.Schedule).%New()
			set tRequest.HistoricDate=pInput.HistoricDate
			set ImageDate=$ZDATE($H-i,3)
			set tRequest.ImageDate=ImageDate
			set tRequest.LastNDays=pInput.LastNDays
			set tRequest.ServiceName=pInput.ServiceName
			set tRequest.TaskType=pInput.TaskType
			set tSC= ..SendRequestAsync(..TargetConfigName,tRequest)
			///Task History
			set tSC=##class(Demo.Analytics.Utils).CreateOrUpdateTaskHistory(pInput.ServiceName,$ZDATETIME($H,3),$ZDATEH(tRequest.ImageDate,5),"STARTED")
		
			
		}	
	}	
	Quit tSC
}

}
