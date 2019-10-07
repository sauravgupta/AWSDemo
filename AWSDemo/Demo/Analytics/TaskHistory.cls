Class Demo.Analytics.TaskHistory Extends %Persistent
{

Parameter DSTIME = "AUTO";

Parameter DSINTERVAL = 5;

Property TaskName As %String(MAXLEN = 100);

Property TaskRunDate As %TimeStamp;

Property DateForWhichTaskRun As %Date;

Property Status As %String(VALUELIST = ",STARTED,COMPLETED");

Index TaskHistoryPKIndex On (TaskName, DateForWhichTaskRun) [ IdKey, PrimaryKey, Unique ];

Storage Default
{
<Data name="TaskHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TaskRunDate</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^Demo.Analytics.TaskHistoryD</DataLocation>
<DefaultData>TaskHistoryDefaultData</DefaultData>
<IdLocation>^Demo.Analytics.TaskHistoryD</IdLocation>
<IndexLocation>^Demo.Analytics.TaskHistoryI</IndexLocation>
<StreamLocation>^Demo.Analytics.TaskHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
