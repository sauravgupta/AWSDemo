Class Demo.Messages.Schedule Extends Ens.Request
{

Property TaskType As %String(VALUELIST = ",Daily,HistoricDate,LastNDays");

Property HistoricDate As %String;

Property LastNDays As %String;

Property ServiceName As %String;

Property ImageDate As %String;

Storage Default
{
<Data name="ScheduleDefaultData">
<Subscript>"Schedule"</Subscript>
<Value name="1">
<Value>TaskType</Value>
</Value>
<Value name="2">
<Value>HistoricDate</Value>
</Value>
<Value name="3">
<Value>LastNDays</Value>
</Value>
<Value name="4">
<Value>ServiceName</Value>
</Value>
<Value name="5">
<Value>ImageDate</Value>
</Value>
</Data>
<DefaultData>ScheduleDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
