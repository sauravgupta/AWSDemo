/// 
Class Demo.BP.WebApIProcess Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.API.ImageRequest' response='Demo.API.ImageStreamResponse' height='2000' width='2000' >
<context>
<property name='Type' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='50' />
</parameters>
</property>
<property name='OperationName' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='100' />
</parameters>
</property>
<property name='ImageURL' type='%String' instantiate='0' >
<parameters>
<parameter name='MAXLEN'  value='200' />
</parameters>
</property>
</context>
<sequence xend='200' yend='1150' >
<assign name="Assign the Context" property="context.Type" value="request.Type" action="set" xpos='200' ypos='250' />
<rule name='Determine the API Operation' rule='Demo.BP.WebAPIRule'  resultLocation='context.OperationName' xpos='200' ypos='350' >
</rule>
<switch name='Check API Call' xpos='200' ypos='450' xend='200' yend='1050' >
<case condition='request.Type="ImageRecord"' name='GetDetails' >
<call name='Call API ' target='@context.OperationName' async='0' xpos='335' ypos='600' >
<request type='Demo.Messages.ImageRecordDetailsRequest' >
<assign property="callrequest.Date" value="request.Date" action="set" />
</request>
<response type='Demo.Messages.ImageResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.Type="ImageDownload"' name='ImageDownload' >
<call name='Call NASA Processing' target='NASAImageProcessing' async='0' xpos='605' ypos='600' >
<request type='Demo.Messages.Schedule' >
<assign property="callrequest.ImageDate" value="request.Date" action="set" />
</request>
<response type='Demo.Messages.SQLImageResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.Type="ImageStatus"' name='GetImageStatus' >
<call name='Call Task Status' target='@context.OperationName' async='0' xpos='875' ypos='600' >
<request type='Demo.Messages.ImageStatusRequest' >
<assign property="callrequest.Date" value="request.Date" action="set" />
<assign property="callrequest.ServiceName" value="request.ServiceName" action="set" />
</request>
<response type='Demo.Messages.ImageStatusResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</case>
<case condition='request.Type="Image"' name='GetPicture' >
<call name='Call API Operation' target='SQLOperation' async='0' xpos='1145' ypos='600' >
<request type='Demo.Messages.ImageRecordDetailsRequest' >
<assign property="callrequest.Date" value="request.Date" action="set" />
</request>
<response type='Demo.Messages.ImageResponse' >
<assign property="context.ImageURL" value="callresponse.URL" action="set" />
</response>
</call>
<if name='Check if Image Exists' condition='context.ImageURL&apos;=""' xpos='1145' ypos='700' xend='1145' yend='950' >
<true>
<call name='Get Image from Cloud' target='@context.OperationName' async='0' xpos='1280' ypos='850' >
<request type='Demo.API.ImageGetRequest' >
<assign property="callrequest.URL" value="context.ImageURL" action="set" />
<assign property="callrequest.CredentialName" value="&quot;AWSS3Access&quot;" action="set" />
<assign property="callrequest.SSLConfig" value="&quot;AWS&quot;" action="set" />
</request>
<response type='Demo.API.ImageStreamResponse' >
<assign property="response.ImageStream" value="callresponse.ImageStream" action="set" />
</response>
</call>
</true>
</if>
</case>
<default/>
</switch>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
