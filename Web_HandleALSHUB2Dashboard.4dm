//Web_HandleALSHUB2Dashboard
//
// Receives a call from ALSHUB2 which looks as follows:
//
// 
//https://alsusweb3.lbl.gov:1024/DashProposalsMenu?AUD=xxxxxx
// which will invoke the proposals menu.
//for now the call will be:
// https://alsusweb3.lbl.gov:1024/DashProposalsMenu?Alsid=17016
//
//
// Submit a Proposal
// https://alsusweb.lbl.gov:1024/DashProposalsMenu?Alsid=17016
//
// Review Proposals
// https://alsusweb.lbl.gov:1024/DashProposalsRating?Alsid=17016
//
// ALS Scheduler Menu
// https://alsusweb.lbl.gov:1024/DashSchedulerMenu?Alsid=17016
//
// ALS ESAF
// https://alsusweb.lbl.gov:1024/DashALSESAF?Alsid=17016
//
// Complete Training
// https://alsusweb.lbl.gov:1024/DashCompleteTraining?Alsid=17016
//
// User Satisfaction Survey 
// https://alsusweb.lbl.gov:1024/DashSurveyMenu?Alsid=17016
// or (anonymous)
// https://alsusweb.lbl.gov:1024/4DCGI/WEB_GetForm/ALSSurvey1.shtml/Initialize
//
// Publications Menu  
// https://alsusweb.lbl.gov:1024/DashPublicationsMenu?Alsid=17016
//
// StaffMenu
// https://alsusweb3.lbl.gov:1024/DashStaffMenu?Alsid=17016
//
// ALS ORCID
// https://alsusweb.lbl.gov:1024/DashALSOrcidRetrieve?Alsid=17016
//
// ALS TEST 1
// https://alsusweb.lbl.gov:1024/DashALSProposalsMenuT?Token=
//
// ALS TEST 2
// https://alsusweb.lbl.gov:1024/DashALSRACT?Token=
//

C_TEXT($1;$tUrl;$2;$postText)

$tUrl:=$1
$postText:=$2

C_LONGINT($funcResult)
C_BLOB(dtJSON_BLOB)

$len:=Length("Dash")
$questionpos:=Position("?";$tURL)
$howmuch:=$questionpos-$len
WebAction:=Substring($tURL;$len+1;$howmuch-1)
ALSWEB_ALSID:=0
$TokenPassed:=False

$code:="?Alsid"
$CodePosition:=Position($code;$tUrl)
If ($CodePosition>0)
  vInValue:=Substring($tUrl;$CodePosition+Length($code)+1)
  ALSWEB_ALSID:=Num(vInValue)
  $TokenPassed:=False
End if 


$code:="?Token"
$CodePosition:=Position($code;$tUrl)
If ($CodePosition>0)
  vInValue:=Substring($tUrl;$CodePosition+Length($code)+1)
  $TokenPassed:=True
End if 

$ServerIP:=Util_ServerIpAddress 

If ((($ServerIP=<>QASERVERIP) | ($ServerIP=<>DEVELOPSERVERIP)) & ((WebAction="ALSRACTEST") | (WebAction="ALSToken")))
  
	//https://alsusweb3.lbl.gov:1024/DashALSRACTest? - for this call go to:
  
	//https://alsusweb3.lbl.gov:1024/DashALSToken? 
	//C_OBJECT($root)
	//$errormessage:="You reached here with this action: ("+WebAction+")"
	//OB SET($root;"error";$errormessage)
	//$jsontext:=JSON Stringify($root;*)
	//jsonOutput ($jsonText;$error)
	//If (WebAction="ALSRACTEST")
  
  
	// this would be in json handle now for receiving data from alsrac
	//parse the posttext
  
	//C_TEXT($alsidblobtxt;$function)
  
	//C_OBJECT($root)
	//$root:=JSON Parse($PostText)
	//$alsidblobtxt:=OB Get($root;"alsidblob")
	//$function:=OB Get($root;"function")
  
	//C_BLOB($targetBlob)
	//BASE64 DECODE($alsidblobtxt;$targetBlob)
  
	//C_BLOB($publicKey;$encryptedMessage)
	//DOCUMENT TO BLOB("PublicKeyQA.txt";$publicKey)
	//DOCUMENT TO BLOB("encrypted.data";$encryptedMessage)
	//DECRYPT BLOB($targetBlob;$publicKey)  // decrypt message 
	//$alsidblobtxt:=BLOB to text($targetBlob;6)
  
  
	//$tUrl:="http://bl832viz5x.als.lbl.gov:8080/rac/index.jsp"
	//AddToAccessLog ("WEB";<>STAFFACCESS;"BL 8.3.2 app"+"by User ID:"+String(ALSWEB_ALSID))
	//WEB SEND HTTP REDIRECT($tUrl;*)
  
	//tReplyFormName:="SubmitAlertHome.shtml"
	//tErrorMessage:="Receive ALS RAC with ALSID: ("+$alsidblobtxt+")"
	//WEB_GetForm (tReplyFormName)
  
	//now encode the alsid and call RAC
  
	//Else 
  
	//If ($ServerIP=<>DEVELOPSERVERIP)
	//J_ReceiveJWT ($tUrl;$postText)
	//Else 
	//T_TestSendJWT 
	//End if 
End if 


//Else 


If (vInValue="")
  
  $funcResult:=204
  
  If (False)
		//THis is where we used to handle handshake token 
	  
		//Currently done with a handshaked token
	  
	  ON ERR CALL("ALSHUB_ErrHandler")
	  HTTP AUTHENTICATE(<>AUTHUSER;<>AUTHPASS;<>AUTHBASIC)
	  ON ERR CALL("")
	  
	  TOKEN:=vInValue
	  $tUrl:=<>ALSHUBServerURL+"/api/UserIdToken/"+TOKEN
	  LogTransaction:=$tUrl
	  
		//ON ERR CALL("ALSHUB_ErrHandler")
	  $funcResult:=HTTP Get($tUrl;dtJSON_BLOB)
		//ON ERR CALL("")
	  
	  If (String($funcResult)=<>HTTP_OK)
			//used by old handshake in ALSHUB to get ALSID token back, may yet to be used
			// again
			//$json:=Convert to text(dtJSON_BLOB;"utf-8")
			//$root:=JSON Parse text ($json)
			//$node:=JSON Get child by name ($root;"userId";JSON_CASE_SENSITIVE)
			//ALSWEB_ALSID:=Num(JSON Get text ($node))
			//JSON CLOSE ($json)
		  If (False)
			  $jsontext:=Convert to text(dtJSON_BLOB;"utf-8")
			  C_OBJECT($root)
			  $root:=JSON Parse($jsontext)
			  ALSWEB_ALSID:=OB Get($root;"userId")
		  End if 
		  
	  End if 
	  
  End if 
  
  
Else 
  $funcResult:=200
  
End if 

Case of 
	  
  : (String($funcResult)=<>HTTP_OK)
		//Continue
	  
  : (String($funcResult)=<>HTTP_NO_CONTENT)
		//204: token is invalid, just redirect immediately to alshub.als.lbl.gov
	  WEB SEND HTTP REDIRECT("https://alshub.als.lbl.gov")
	  
  Else 
		//Sorry, we experienced a problem. Please go to http:  //alshub.als.lbl.gov and log in again.
	  WEB SEND HTTP REDIRECT("https://alshub.als.lbl.gov")
	  
End case 


$ErrorMessageUnathorized:="Expired or unauthorized session. Please log in again to ALSHUB."


If ((ALSWEB_ALSID=0) & ($TokenPassed=False))
  tReplyFormName:="SubmitAlertClose.shtml"
  tErrorMessage:="Validation Error - Please log back in to https://alshub.als.lbl.gov to proceed"
  WEB_GetForm (tReplyFormName)
Else 
  
  AddToAccessLog ("ALSHUB";WebAction;"Launch")
  
  Case of 
	  : (WebAction="ProposalsMenu")
		  
		  AddToAccessLog ("WEB";<>PROPSUBMITLOGIN;"From ALSHUB")
		  WebDisplayProposalSubmitMenu 
		  WEB_GetForm (tReplyFormName)
		  
	  : (WebAction="ProposalsMenuT")
		  
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValue
			  AddToAccessLog ("WEB";<>PROPSUBMITLOGIN;"From ALSHUB")
			  WebDisplayProposalSubmitMenu 
			  WEB_GetForm (tReplyFormName)
		  Else 
			  tReplyFormName:="SubmitAlertError.shtml"
			  tErrorMessage:=$ErrorMessageUnathorized
			  WEB_GetForm (tReplyFormName)
		  End if 
		  
		  
	  : (WebAction="CompleteTraining")
		  AddToAccessLog ("WEB";WebAction;"From ALSHUB2")
		  WebDisplayUserTraining 
		  WEB_GetForm (tReplyFormName)
		  
	  : (WebAction="CompleteTrainingT")
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValue
			  AddToAccessLog ("WEB";WebAction;"From ALSHUB")
			  WebDisplayUserTraining 
		  Else 
			  tReplyFormName:="SubmitAlertError.shtml"
			  tErrorMessage:=$ErrorMessageUnathorized
		  End if 
		  WEB_GetForm (tReplyFormName)
		  
	  : (WebAction="ProposalsRating")
		  tReplyFormName:="SubmitAlertClose.shtml"
		  QUERY([People];[People]ALSID=ALSWEB_ALSID)
		  PRSearchString:=""
			//always true for new link from alshub
		  $fOK:=True
			//$fOK:=CheckWebUserAccess ("GSProposalRating")
		  UNLOAD RECORD([People])
		  If ($fOK)
			  AddToAccessLog ("WEB";<>PROPRATINGLOGIN;"From ALSHUB2")
			  WebProposalRatingReview 
		  End if 
		  WEB_GetForm (tReplyFormName)
		  
	  : (WebAction="ProposalsRatingT")
		  
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValue
			  QUERY([People];[People]ALSID=ALSWEB_ALSID)
			  PRSearchString:=""
				//always true for new link from alshub
			  $fOK:=True
				//$fOK:=CheckWebUserAccess ("GSProposalRating")
			  UNLOAD RECORD([People])
			  
				//tReplyFormName:="SubmitAlertClose.shtml"
				//verify if we need this below?
				//QUERY([People];[People]ALSID=ALSWEB_ALSID)
				//PRSearchString:=""
				//always true for new link from alshub
				//$fOK:=True
				//$fOK:=CheckWebUserAccess ("GSProposalRating")
				//UNLOAD RECORD([People])
				//If ($fOK)
			  AddToAccessLog ("WEB";WebAction;"From ALSHUB")
			  WebProposalRatingReview 
				//End if 
		  Else 
			  tReplyFormName:="SubmitAlertError.shtml"
			  tErrorMessage:=$ErrorMessageUnathorized
		  End if 
		  WEB_GetForm (tReplyFormName)
		  
	  : (WebAction="ALSOrcidRetrieve")
		  
		  WebSetupAuthenticateOrcid 
		  WEB_GetForm2 (tReplyFormName)
		  
	  : (WebAction="ALSOrcidRetrieveT")
		  
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValue
			  AddToAccessLog ("WEB";WebAction;"From ALSHUB")
			  WebSetupAuthenticateOrcid 
		  Else 
			  tReplyFormName:="SubmitAlertError.shtml"
			  tErrorMessage:=$ErrorMessageUnathorized
		  End if 
		  WEB_GetForm2 (tReplyFormName)
		  
	  : (WebAction="StaffMenu")  //<>STAFFACCESS
		  tReplyFormName:="SubmitAlertClose.shtml"
		  QUERY([People];[People]ALSID=ALSWEB_ALSID)
		  $Count:=Records in selection([People])
		  UNLOAD RECORD([People])
		  If ($Count=0)
			  tErrorMessage:="You are not ALS Staff"
		  Else 
			  $fOK:=CheckWebUserAccess ("BSPass")
			  If ($fOK)
				  AddToAccessLog ("WEB";<>STAFFACCESS;"From ALSHUB2")
				  WebDisplayALSStaffMenu 
			  End if 
		  End if 
		  WEB_GetForm (tReplyFormName)
		  
	  : (WebAction="StaffMenuT")
		  
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValue
			  tReplyFormName:="SubmitAlertClose.shtml"
			  QUERY([People];[People]ALSID=ALSWEB_ALSID)
			  $Count:=Records in selection([People])
			  UNLOAD RECORD([People])
			  If ($Count=0)
				  tErrorMessage:="You are not ALS Staff"
			  Else 
				  $fOK:=CheckWebUserAccess ("BSPass")
				  If ($fOK)
					  AddToAccessLog ("WEB";WebAction;"From ALSHUB")
					  WebDisplayALSStaffMenu 
				  End if 
			  End if 
		  Else 
			  tReplyFormName:="SubmitAlertError.shtml"
			  tErrorMessage:=$ErrorMessageUnathorized
		  End if 
		  WEB_GetForm (tReplyFormName)
		  
		  
		  
	  : (WebAction="PublicationsMenu")
		  AddToAccessLog ("WEB";"Publications Menu";"From ALSHUB2")
		  WebDisplayPublicationMenu 
		  WEB_GetForm2 (tReplyFormName)
		  
	  : (WebAction="ALSScheduler")  // Direct call to scheduler or to intermediate menu
		  
		  If (False)
				//this call is now made with a token which then calls the scheduler
			  $code:="/token="
			  $CodePosition:=Position($code;$tUrl)
			  If ($CodePosition>0)
				  $StringStart:=Substring($tUrl;$CodePosition+Length($code))
				  ALSID_TOKEN:=Substring($StringStart;1;Position("/";$StringStart)-1)
			  End if 
			  
			  QUERY([TokenLog];[TokenLog]TokenUUID=ALSID_TOKEN)
			  If (Records in selection([TokenLog])=1)
				  ALSWEB_ALSID:=[TokenLog]ALSID
			  Else 
					//there is an error
			  End if 
			  UNLOAD RECORD([TokenLog])
			  
			  AddToAccessLog ("WEB";"ALS Scheduler";"From ALSHUB2 by alsid="+String(ALSWEB_ALSID))
			  
			  $tUrl:=<>ALSSchedServer+"/Account/AlsHubLogin/?token"+"="+ALSID_TOKEN
			  $ALSSchedulerLink:=$tUrl
			  WEB SEND HTTP REDIRECT($ALSSchedulerLink;*)
			  
				//allow my servers to make this call for testing
			  
				//once the scheduler received the token back, they can figure out the ALSID sent?
		  End if 
		  
		  AddToAccessLog ("WEB";"ALS Scheduler";"From ALSHUB2 by alsid="+String(ALSWEB_ALSID))
		  $tUrl:=<>ALSSchedServer+"/Account/AlsHubLogin/?ALSID"+"="+String(ALSWEB_ALSID)
		  $ALSSchedulerLink:=$tUrl
		  WEB SEND HTTP REDIRECT($ALSSchedulerLink;*)
		  
	  : (WebAction="ALSESAF")  // Direct call to esaf or to intermediate menu
		  AddToAccessLog ("WEB";"ALS ESAF";"From ALSHUB2 by alsid="+String(ALSWEB_ALSID))
		  $tUrl:=<>ALSESAFServer+"/Account/AlsHubLogin/?ALSID"+"="+String(ALSWEB_ALSID)
		  $ALSSchedulerLink:=$tUrl
		  WEB SEND HTTP REDIRECT($ALSSchedulerLink;*)
		  
	  : (WebAction="ESAFMenu")  // no longer done from ALSHUB
		  AddToAccessLog ("WEB";"ALS ESAF";"From ALSHUB by alsid="+String(ALSWEB_ALSID))
		  $tUrl:=<>ALSESAFServer+"/Account/AlsHubLogin/?ALSID"+"="+String(ALSWEB_ALSID)
		  $ALSESAFLink:=$tUrl
		  WEB SEND HTTP REDIRECT($ALSESAFLink;*)
		  
	  : (WebAction="SchedulerMenu")  // no longer done from ALSHUB
		  AddToAccessLog ("WEB";"ALS Scheduler";"From ALSHUB by alsid="+String(ALSWEB_ALSID))
		  $tUrl:=<>ALSSchedServer+"/Account/AlsHubLogin/?ALSID"+"="+String(ALSWEB_ALSID)
		  $ALSSchedulerLink:=$tUrl
		  WEB SEND HTTP REDIRECT($ALSSchedulerLink;*)
		  
		  
		  
	  : (WebAction="AppMenu")
		  AddToAccessLog ("WEB";"App Menu";"From ALSHUB2")
		  WebDisplayALSAppMenu 
		  WEB_GetForm2 (tReplyFormName)
		  
	  : (WebAction="ALSRACT")
		  AddToAccessLog ("WEB";WebAction;"From ALSHUB")
		  
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValue
			  $otp:=GetRACOTP 
			  $tUrl:="https://remote.als.lbl.gov/?token="+$otp
			  WEB SEND HTTP REDIRECT($tUrl;*)
		  Else 
			  tReplyFormName:="SubmitAlertError.shtml"
			  tErrorMessage:=$ErrorMessageUnathorized
			  WEB_GetForm (tReplyFormName)
		  End if 
			// Sujata Test App Start
	  : (WebAction="HelloWorldAppV1")
		  AddToAccessLog ("WEB";WebAction;"From ALSHUB")
		  
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValues
			  $name:="No First Name"
			  QUERY([People];[People]ALSID=ALSWEB_ALSID)
			  If (Records in selection([People])=1)
				  $name:=[People]FirstName
			  End if 
			  UNLOAD RECORD([People])
			  WEB SEND TEXT("<html><head></head><body> Hello "+$name+", current time is: "+String(Current time)+".</body></html>")
		  Else 
			  WEB SEND TEXT("<html><head></head><body> Hello Guest, current time is: "+String(Current time)+".</body></html>")
		  End if 
		  
		  
	  : (WebAction="HelloWorldApp")
		  AddToAccessLog ("WEB";WebAction;"From ALSHUB")
		  
		  ALSWEB_ALSID:=ValidateToken (vInValue)
		  If (ALSWEB_ALSID>0)
			  ALSWEB_Token:=vInValue
			  C_BLOB(dtJSON_BLOB)
			  HTTP SET OPTION(HTTP timeout;5)
			  $tUrl:="http://131.243.88.243:8000/token?user_id="+String(ALSWEB_ALSID)
			  $funcResult:=HTTP Get($tUrl;dtJSON_BLOB)
			  If (String($funcResult)=<>HTTP_OK)
				  $jsontext:=Convert to text(dtJSON_BLOB;"utf-8")
				  C_OBJECT($json)
				  $json:=JSON Parse($jsontext)
				  $otp:=OB Get($json;"otp")
				  $tUrl:="http://131.243.88.243:8000/validate?token="+$otp
				  WEB SEND HTTP REDIRECT($tUrl;*)
			  Else 
				  WEB SEND TEXT("<html><head></head><body> HTTP REQUEST FAILED - Hello Guest, current time is: "+String(Current time)+".</body></html>")
			  End if 
		  Else 
			  WEB SEND TEXT("<html><head></head><body> Hello Guest, current time is: "+String(Current time)+".</body></html>")
		  End if 
			//Sujata Test App End
		  
	  : (WebAction="ALSRAC")
		  
		  $otp:=GetRACOTP 
		  
			//$tUrl:="https://remote.als.lbl.gov/?token="+$base64Text
		  $tUrl:="https://remote.als.lbl.gov/?token="+$otp
			//AddToAccessLog ("WEB";<>STAFFACCESS;"BL 8.3.2 app"+"by User ID:"+String(ALSWEB_ALSID))
		  WEB SEND HTTP REDIRECT($tUrl;*)
		  
		  If (False)
			  If ($ServerIP=<>PRODUCTIONSERVERIP)
					//old way
				  $tUrl:="http://bl832viz5x.als.lbl.gov:8080/rac/index.jsp"+"?ALSID="+String(ALSWEB_ALSID)
				  AddToAccessLog ("WEB";<>STAFFACCESS;"BL 8.3.2 app"+"by User ID:"+String(ALSWEB_ALSID))
				  WEB SEND HTTP REDIRECT($tUrl;*)
				  
			  Else 
				  
				  If ($ServerIP=<>DEVELOPSERVERIP)
						// trying this way
						//https://alsusweb2.lbl.gov:1024/DashALSRAC?Alsid=57743
					  tErrorMessage:="Receive ALS RAC with ALSID: ("+String(ALSWEB_ALSID)+")"
					  ALSID_TOKEN:=EncryptToken (String(ALSWEB_ALSID);"RAC")
					  tReplyFormName:="SubmitAlertRAC.shtml"
					  tErrorMessage:="Receive ALS RAC with ALSID("+String(ALSWEB_ALSID)+") Token="+ALSID_TOKEN
					  WEB_GetForm (tReplyFormName)
				  Else 
					  J_CallALSRac (String(ALSWEB_ALSID))
				  End if 
				  
			  End if 
			  
		  End if 
		  
  End case 
End if 