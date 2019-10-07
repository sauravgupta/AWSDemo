/// 
Class Demo.BP.DailyImageProcessing Extends Ens.BusinessProcessBPL
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.Messages.Schedule' response='Demo.Messages.SQLImageResponse' height='2000' width='2000' >
<context>
<property name='ImageDetails' type='Demo.Messages.ImageResponse' instantiate='0' />
<property name='AWSResponse' type='Demo.Messages.AWSResponseMessage' instantiate='0' />
<property name='ImageStream' type='Demo.Messages.ImageStreamResponse' instantiate='0' />
</context>
<sequence xend='200' yend='1150' >
<call name='Get Image Details' target='NASARESTOperation' async='0' xpos='200' ypos='250' >
<request type='Demo.Messages.Schedule' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Demo.Messages.ImageResponse' >
<assign property="context.ImageDetails" value="callresponse" action="set" />
</response>
</call>
<if name='Check URL was retrieved' condition='context.ImageDetails.URL&apos;=""' xpos='200' ypos='350' xend='200' yend='1050' >
<true>
<call name='Get Image Stream' target='NASARESTOperation' async='0' xpos='335' ypos='500' >
<request type='Demo.Messages.RetrieveImageRequest' >
<assign property="callrequest.URL" value="context.ImageDetails.URL" action="set" />
</request>
<response type='Demo.Messages.ImageStreamResponse' >
<assign property="context.ImageStream.FileStream" value="callresponse.FileStream" action="set" />
</response>
</call>
<call name='Copy the Image ' target='AWSS3Storage' async='0' xpos='335' ypos='600' >
<annotation><![CDATA[Copy the Image to BLOB Storage]]></annotation>
<request type='Demo.Messages.AWSRequestMessage' >
<assign property="callrequest.SSLConfig" value="&quot;AWS&quot;" action="set" />
<assign property="callrequest.Service" value="&quot;s3&quot;" action="set" />
<assign property="callrequest.BucketName" value="&quot;irisawss3integration&quot;" action="set" />
<assign property="callrequest.Region" value="&quot;eu-west-1&quot;" action="set" />
<assign property="callrequest.CredentialName" value="&quot;AWSS3Access&quot;" action="set" />
<assign property="callrequest.FileStream" value="context.ImageStream.FileStream" action="set" />
<assign property="callrequest.FileName" value="context.ImageDetails.Date_&quot;.jpg&quot;" action="set" />
</request>
<response type='Demo.Messages.AWSResponseMessage' >
<assign property="context.AWSResponse" value="callresponse" action="set" />
</response>
</call>
<if name='Check HTTP response' condition='context.AWSResponse.HTTPResponseCode="200"' xpos='335' ypos='700' xend='335' yend='950' >
<true>
<call name='SQL Insert' target='SQLOperation' async='0' xpos='470' ypos='850' >
<request type='Demo.Messages.SQLImageRequest' >
<assign property="callrequest.Date" value="context.ImageDetails.Date" action="set" />
<assign property="callrequest.Explanation" value="context.ImageDetails.Explanation" action="set" />
<assign property="callrequest.HDURL" value="context.ImageDetails.HDURL" action="set" />
<assign property="callrequest.MediaType" value="context.ImageDetails.MediaType" action="set" />
<assign property="callrequest.ServiceVersion" value="context.ImageDetails.ServiceVersion" action="set" />
<assign property="callrequest.Title" value="context.ImageDetails.Title" action="set" />
<assign property="callrequest.OriginalURL" value="context.ImageDetails.URL" action="set" />
<assign property="callrequest.BucketName" value="&quot;irisawss3integration&quot;" action="set" />
<assign property="callrequest.Service" value="&quot;s3&quot;" action="set" />
<assign property="callrequest.Extension" value="&quot;jpg&quot;" action="set" />
<assign property="callrequest.Region" value="&quot;eu-west-1&quot;" action="set" />
<assign property="callrequest.Copyright" value="context.ImageDetails.Copyright" action="set" />
<assign property="callrequest.ServiceName" value="request.ServiceName" action="set" />
</request>
<response type='Demo.Messages.SQLImageResponse' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</true>
</if>
</true>
</if>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
