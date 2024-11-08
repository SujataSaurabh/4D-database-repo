  //GetRACOTP

C_BLOB(dtJSON_BLOB)

  //$tUrl:="http://remote.als.lbl.gov:9000/get_otp/?alsid="+String(ALSWEB_ALSID)

$tUrl:="http://v-als-rac1.als.lbl.gov:9000/get_otp/?alsid="+String(ALSWEB_ALSID)

$funcResult:=HTTP Get($tUrl;dtJSON_BLOB)


If (String($funcResult)=<>HTTP_OK)
	
	$jsontext:=Convert to text(dtJSON_BLOB;"utf-8")
	C_OBJECT($json)
	$json:=JSON Parse($jsontext)
	
	otp:=OB Get($json;"otp")
	
	
End if 


$0:=otp