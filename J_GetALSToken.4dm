  // J_GetALSToken
  //
  // examples:
  //https://alsusweb2.lbl.gov/GetALSToken/?ai=15685
  //


C_TEXT($1;$tUrl)
$tUrl:=$1
$error:=<>HTTP_OK
$alsid:=$1
C_OBJECT($json)


If (CheckInternalIP (<>WebClientIP))
	  //If ((<>WebClientIP=<>ALSHUBSERVERIP) | (<>WebClientIP=<>QASERVERIP) | (<>WebClientIP=<>DEVELOPSERVERIP))
	
	$identifier:=Position("ai=";$tUrl)
	If ($identifier<1)
		$error:=<>HTTP_BADREQUEST
		
	Else 
		$tUrl:=Substring($tUrl;$identifier+3)
		If ($tUrl="")
			$error:=<>HTTP_BADREQUEST
		Else 
			$alsid:=$tUrl
			  //make sure it exists, don't need to do this
			  //QUERY([People];[People]ALSID=$alsid)
			  //If (Records in selection([People])=0)
			  //$error:=<>HTTP_NOTFOUND
			  //Else 
			$Token:=GenerateToken (Num($alsid))
			OB SET($json;"Token";$Token)
			
			$jsontext:=JSON Stringify($json;*)
			jsonOutput ($jsonText;$error)
			
		End if 
		
	End if 
	
Else 
	$error:=<>HTTP_BADREQUEST
End if 

If ($error#<>HTTP_OK)
	jsonOutput ($jsonText;$error)
End if 

$Area:="ALSGetToken"
If ($error#<>HTTP_OK)
	$errorMessage:="Error: "+$error
Else 
	$errorMessage:=""
End if 
$Action:=$errorMessage+" ALSID: "+$ALSID
AddToAccessLog ("JSON";$Area;$Action)
