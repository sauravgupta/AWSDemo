/// 
Class Demo.BP.WebAPIRule Extends Ens.Rule.Definition
{

Parameter RuleAssistClass = "Ens.Rule.GeneralBusinessRuleAssist";

XData RuleDefinition [ XMLNamespace = "http://www.intersystems.com/rule" ]
{
<ruleDefinition alias="" context="Demo.BP.WebApIProcess.Context" production="">
<ruleSet name="" effectiveBegin="" effectiveEnd="">
<rule name="" disabled="false">
<when condition="Type=&quot;ImageRecord&quot;">
<assign property="OperationName" value="&quot;SQLOperation&quot;"></assign>
<return>OperationName</return>
</when>
<when condition="Type=&quot;Image&quot;">
<assign property="OperationName" value="&quot;AWSS3Storage&quot;"></assign>
<return>OperationName</return>
</when>
<when condition="Type=&quot;ImageDownload&quot;">
<assign property="OperationName" value="&quot;SQLOperation&quot;"></assign>
<return>OperationName</return>
</when>
<when condition="Type=&quot;ImageStatus&quot;">
<assign property="OperationName" value="&quot;TaskStatusOperation&quot;"></assign>
<return>OperationName</return>
</when>
</rule>
</ruleSet>
</ruleDefinition>
}

}
