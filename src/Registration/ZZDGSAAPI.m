ZZDGSAAPI ;RGI/VSL Unit Tests - Sharing Agreement API; 5/31/13
 ;;1.0;UNIT TEST;;05/28/2012;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGSAAPI")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT
 D LOGON^ZZRGUTCM
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZDGPMSE()
 Q
 ;
SHUTDOWN ;
 Q
 ;
LSTACAT ;
 N RETURN,%,AREG,R
 S AREG=1
 S %=$$ADDSASC^DGSAAPI(.R,"Category 2")
 S %=$$ADDACAT^DGSAAPI(.R,1,+R)
 ;Invalid param type
 S %=$$LSTACAT^DGSAAPI(.RETURN)
 D CHKEQ^XTMUNIT(RETURN(0),"INVPARM^Invalid parameter value - AREG","Expected error: INVPARAM")
 ;Undefined admitting regulation
 S %=$$LSTACAT^DGSAAPI(.RETURN,99999)
 D CHKEQ^XTMUNIT(RETURN(0),"AREGNFND^Admitting regulation not found.","Expected error: AREGNFND")
 S %=$$LSTACAT^DGSAAPI(.RETURN,AREG)
 D CHKEQ^XTMUNIT(RETURN(0),"2","Invalid 0 node")
 D CHKEQ^XTMUNIT(RETURN(1,"ID"),1,"Invalid appt subtype ID 1")
 D CHKEQ^XTMUNIT(RETURN(1,"SUBCAT"),"1^Category 1 updated","Invalid sub-categ 1")
 D CHKEQ^XTMUNIT(RETURN(1,"STATUS"),"1^YES","Invalid status 1")
 D CHKEQ^XTMUNIT(RETURN(2,"ID"),2,"Invalid appt subtype ID 2")
 D CHKEQ^XTMUNIT(RETURN(2,"SUBCAT"),"2^Category 2","Invalid sub-categ 1")
 D CHKEQ^XTMUNIT(RETURN(2,"STATUS"),"^","Invalid status 2")
 ;Active only
 S %=$$LSTACAT^DGSAAPI(.RETURN,AREG,1)
 D CHKEQ^XTMUNIT(RETURN(0),1,"Invalid no of entries - active")
 D CHKEQ^XTMUNIT(RETURN(1,"ID"),1,"Invalid category ID - active")
 D CHKEQ^XTMUNIT(RETURN(1,"SUBCAT"),"1^Category 1 updated","Invalid sub-categ - active")
 D CHKEQ^XTMUNIT(RETURN(1,"STATUS"),"1^YES","Invalid status - active")
 ;Inactive admitting regulation
 S %=$$LSTACAT^DGSAAPI(.RETURN,2,1)
 D CHKEQ^XTMUNIT(RETURN(0),"AREGINAC^Admitting regulation 'POTENTIAL ELIGIBILITY' is inactive.","AREGINAC")
 Q
ADDSASC ; Add sharing agreement sub-category
 N RE,NAME
 ;Invalid param NAME
 S %=$$ADDSASC^DGSAAPI(.RE)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCINV","Expected error: SASCINV")
 S NAME="tw",%=$$ADDSASC^DGSAAPI(.RE,NAME)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCINV","Expected error: SASCINV")
 S NAME="A" F IN=1:1:30 S NAME=NAME_"A"
 S %=$$ADDSASC^DGSAAPI(.RE,NAME)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCINV","Expected error: SASCINV")
 ;Ok
 S NAME="Category 1"
 S %=$$ADDSASC^DGSAAPI(.RE,NAME),SASC=+RE
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(NAME,$G(^DG(35.2,+RE,0)),"Incorrect name")
 ;Already exists
 S NAME="Category 1"
 S %=$$ADDSASC^DGSAAPI(.RE,NAME)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCAEX","Expected error: SASCINV")
 Q
UPDSASC ; Update sharing agreement sub-category
 N RE,NAME
 ;Invalid param IFN
 S %=$$UPDSASC^DGSAAPI(.RE)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Expected error: INVPARM")
 ;Sub-category not found
 S %=$$UPDSASC^DGSAAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCNFND","Expected error: SASCNFND")
 ;Invalid param NAME
 S %=$$UPDSASC^DGSAAPI(.RE,SASC_U)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCINV","Expected error: SASCINV")
 S NAME="tw",%=$$UPDSASC^DGSAAPI(.RE,SASC_U,NAME)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCINV","Expected error: SASCINV")
 S NAME="A" F IN=1:1:30 S NAME=NAME_"A"
 S %=$$UPDSASC^DGSAAPI(.RE,SASC_U,NAME)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCINV","Expected error: SASCINV")
 ;Ok
 S NAME="Category 1 updated"
 S %=$$UPDSASC^DGSAAPI(.RE,SASC_U,NAME)
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(NAME,$G(^DG(35.2,+SASC,0)),"Incorrect name")
 Q
ADDACAT ; Add sharing agreement category
 N RE,AREG,SUBCAT,STAT
 ;Invalid param TYPE
 S %=$$ADDACAT^DGSAAPI(.RE),AREG=9999
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Expected error: INVPARM")
 ;Admitting regulation not found
 S %=$$ADDACAT^DGSAAPI(.RE,AREG_U),AREG=1
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^AREGNFND","Expected error: AREGNFND")
 ;Invalid param SUBCAT
 S %=$$ADDACAT^DGSAAPI(.RE,AREG_U)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Expected error: INVPARM")
 ;Sub-category not found
 S %=$$ADDACAT^DGSAAPI(.RE,AREG_U,9999)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^SASCNFND","Expected error: SASCNFND")
 ;Invalid param STATUS
 S %=$$ADDACAT^DGSAAPI(.RE,AREG_U,SASC_U,2)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Expected error: INVPARM")
 ;Ok
 S %=$$ADDACAT^DGSAAPI(.RE,AREG_U,SASC_U,1_U)
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+AREG_";DIC(43.4,^"_+SASC_"^1",$G(^DG(35.1,+RE,0)),"Incorrect name")
 Q
UPDCAT ; Update sharing agreement category
 N RE,SACAT,STAT
 ;Invalid param TYPE
 S %=$$UPDCAT^DGSAAPI(.RE),SACAT=9999
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARM^Invalid parameter value - SACAT","Expected error: INVPARM")
 ;Admitting regulation not found
 S %=$$UPDCAT^DGSAAPI(.RE,SACAT_U),SACAT=1
 D CHKEQ^XTMUNIT($G(RE(0)),"SACNFND^Sharing Agreement Category not found.","Expected error: SACNFND")
 ;Invalid param STATUS
 S %=$$UPDCAT^DGSAAPI(.RE,SACAT_U,2)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Expected error: INVPARM")
 ;Ok
 S %=$$UPDCAT^DGSAAPI(.RE,SACAT_U,1_U)
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+SACAT_";DIC(43.4,^"_+SASC_"^1",$G(^DG(35.1,+RE,0)),"Incorrect name")
 S %=$$UPDCAT^DGSAAPI(.RE,SACAT_U,0_U)
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+SACAT_";DIC(43.4,^"_+SASC_"^0",$G(^DG(35.1,+RE,0)),"Incorrect name")
 Q
XTENT ;
 ;;ADDSASC;Add Sub-category 
 ;;UPDSASC;Update Sub-category
 ;;ADDACAT;Add Admitting Category
 ;;LSTACAT;List Sub-categories
 ;;UPDCAT;Update Admitting Category
