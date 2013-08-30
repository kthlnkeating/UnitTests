ZZRGUSD3 ;Unit Tests - Clinic API; 8/13/13
 ;;1.0;UNIT TEST;;05/28/2012;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD3")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT
 D LOGON^ZZRGUSDC
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZRGUSDC()
 Q
 ;
SHUTDOWN ;
 Q
 ;
CHKAPP ;
 N RETURN,%
 S ^DPT(+DFN,.35)=DT
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN,.LVL)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: PATDIED")
 D CHKEQ^XTMUNIT(RETURN(0),"PATDIED^PATIENT HAS DIED.^1","Expected error: PATDIED")
 S ^DPT(+DFN,.35)=""
 S ^SC(+SC,"SDPROT")="Y"
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNURGT")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNURGT","Expected error: CLNURGT")
 S ^SC(+SC,"SDPRIV",DUZ,0)=DUZ
 S TMP=$G(^SC(+SC,"ST",DT,1)),^SC(+SC,"ST",DT,1)="CANCELLED"
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCLUV")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCLUV","Expected error: APTCLUV")
 S ^SC(+SC,"ST",DT,1)=TMP
 S ^HOLIDAY(DT,0)=DT_U_"Holiday test",$P(^SC(+SC,"SL"),U,8)=""
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTSHOL")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTSHOL","Expected error: APTSHOL")
 S $P(^SC(+SC,"SL"),U,8)="Y"
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,$$FMADD^XLFDT(DT,3)_".08",LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTEXCD")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTEXCD","Expected error: APTEXCD")
 N ST,DOW S DOW=$$DOW^SDMAPI5(+SD)
 S ST=$P("SU^MO^TU^WE^TH^FR^SA","^",DOW+1)_" "_$E(SD,6,7)
 S ST=ST_"  [1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1]"
 D CHKEQ^XTMUNIT(ST,^SC(+SC,"ST",$P(SD,"."),1),"Incorrect clinic ST node")
 ;check if patient has an active appointment on the same time
 S %=$$MAKE^SDMAPI2(.RET,DFN,SC,+SD,TYPE,,LEN,NXT,RSN)
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTPAHA")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTPAHA","Expected error: APTPAHA")
 D CHKEQ^XTMUNIT($P(RETURN(0),U,3),2,"Level 2 expected")
 ;check if patient has an active appointment on the same day
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,DT_".1",LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTPAHA")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTPHSD","Expected error: APTPAHA")
 D CHKEQ^XTMUNIT($P(RETURN(0),U,3),3,"Level 3 expected")
 ;check if patient has an canceled appointment on the same time
 S $P(^DPT(+DFN,"S",+SD,0),U,2)="PC"
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTPPCP")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTPPCP","Expected error: APTPPCP")
 D CHKEQ^XTMUNIT($P(RETURN(0),U,3),2,"Level 2 expected")
 ;check if date is prior to patient birth date
 K ^DPT(+DFN,"S")
 S $P(^DPT(+DFN,0),U,3)=DT+2
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTPPAB")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTPPAB","Expected error: APTPPAB")
 D CHKEQ^XTMUNIT($P(RETURN(0),U,3),1,"Level 1 expected")
 ; overbook inside clinic availability - no open slots
 S $P(^DPT(+DFN,0),U,3)=DT-100 K ^XUSEC("SDOB",DUZ)
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTSDOB")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTSDOB","Expected error: APTSDOB")
 D CHKEQ^XTMUNIT(RETURN(1),0,"Inside clinic availability")
 D CHKEQ^XTMUNIT($P(RETURN(0),U,3),1,"Level 1 expected")
 ; overbook outside clinic availability - when??
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,$$FMADD^XLFDT(+SD,,-2),LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTSDOB")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTSDOB","Expected error: APTSDOB")
 D CHKEQ^XTMUNIT(RETURN(1),1,"Outside clinic availability")
 D CHKEQ^XTMUNIT($P(RETURN(0),U,3),1,"Level 1 expected")
 ; overbook warning
 S ^XUSEC("SDOB",DUZ)=""
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTOVBK")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTOVBK","Expected error: APTOVBK")
 D CHKEQ^XTMUNIT($P(RETURN(0),U,3),2,"Level 2 expected")
 ; ok
 S %=$$CHKAPP^SDMAPI2(.RETURN,SC,DFN,+SD,LEN,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 Q
 ;
LSTPATS ;
 N RETURN,%
 S %=$$LSTPATS^SDMAPI3(.RETURN,"TEST")
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: ")
 D CHKEQ^XTMUNIT(%,1,"Unexpected error: ")
 D CHKEQ^XTMUNIT(+RETURN(0),1)
 D CHKEQ^XTMUNIT(RETURN(1,"ID"),+DFN)
 D CHKEQ^XTMUNIT(RETURN(1,"NAME"),PNAME)
 Q
GETPAT ; Get a patient
 N RETURN,%
 S RTN="S %=$$GETPAT^SDMAPI4(.RETURN,.PAT)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$GETPAT^SDMAPI4(.RETURN,DFN) ; Get a patient
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S %=$$GETPAT^SDMAPI4(.RETURN,DFN) ; Get a patient
 D CHKEQ^XTMUNIT($P(RETURN("NAME"),U),PNAME)
 Q
CHKCO ;
 N RETURN,RE,%
 S SD=$P(DT,".")_".1",SD=SD_U_$$FMTE^XLFDT(SD)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 ;undefined SD
 S %=$$CHKCO^SDMAPI4(.RE,DFN)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^INVPARAM","Expected: INVPARAM SD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["SD",1,"Expected: INVPARAM SD")
 ;appt not found
 S %=$$CHKCO^SDMAPI4(.RE,DFN,2)
 D CHKEQ^XTMUNIT(RE_U_$P(RE(0),U),"0^APTNFND","Expected: APTNFND")
 ;patient
 S RTN="S %=$$CHKCO^SDMAPI4(.RETURN,.PAT,SD)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$CHKCO^SDMAPI4(.RETURN,DFN,SD)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$P($G(RE(0)),U,2))
 Q
GETPAT2 ;
 N RETURN,PAT,%
 S RTN="S %=$$GETPAT^SDMAPI4(.RETURN,.PAT)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$GETPAT^SDMAPI4(.PAT,DFN)
 D CHKEQ^XTMUNIT(PAT,1,"Unexpected error:")
 D CHKEQ^XTMUNIT(PAT("NAME"),PNAME,"Invalid patient name")
 Q
ANCTEST ;
 N LAB,EKG,XRAY,RETURN,%,RE
 S %=$$ADDTSTS^SDMAPI4(.RE,DFN,SD,3120501.91,.XRAY,.EKG)
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - LAB^1","Expected: INVPARAM LAB")
 S %=$$ADDTSTS^SDMAPI4(.RE,DFN,SD,,3120501.91,.EKG)
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - XRAY^1","Expected: INVPARAM XRAY")
 S %=$$ADDTSTS^SDMAPI4(.RE,DFN,SD,,.XRAY,3120501.91)
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - EKG^1","Expected: INVPARAM EKG")
 S LAB=$P(DT,".")_".103",LAB=LAB_U_$$FMTE^XLFDT(LAB)
 S XRAY=$P(DT,".")_".11",XRAY=XRAY_U_$$FMTE^XLFDT(XRAY)
 S EKG=$P(DT,".")_".113",EKG=EKG_U_$$FMTE^XLFDT(EKG)
 S RTN="S %=$$ADDTSTS^SDMAPI4(.RETURN,.PAT,SD,.LAB,.XRAY,.EKG)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$ADDTSTS^SDMAPI4(.RETURN,DFN,SD,.LAB,.XRAY,.EKG)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error:")
 D CHKEQ^XTMUNIT($P(^DPT(+DFN,"S",+SD,0),U,3,5),+LAB_U_+XRAY_U_+EKG,"Invalid length")
 S %=$$CHECKO^SDMAPI4(.RETURN,DFN,SD,SC)
 S SDOE=RETURN("SDOE")
 S %=$$ADDTSTS^SDMAPI4(.RETURN,DFN,SD,.LAB,.XRAY,.EKG)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error:")
 D CHKEQ^XTMUNIT($P(^DPT(+DFN,"S",+SD,0),U,3,5),+LAB_U_+XRAY_U_+EKG,"Invalid length")
 S RTN="S %=$$DELTSTS^SDMAPI4(.RETURN,.PAT,SD,,,)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$DELTSTS^SDMAPI4(.RETURN,DFN,SD,1,1,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error:")
 D CHKEQ^XTMUNIT($P(^DPT(+DFN,"S",+SD,0),U,3,5),U_U,"Invalid length")
 Q
CANDELCO ;
 N CAN,OE,%
 S ^XUSEC("SD SUPERVISOR",DUZ)=""
 S %=$$CANDELCO^SDMAPI4(.CAN)
 D CHKEQ^XTMUNIT(CAN,1,"Unexpected error: "_$G(CAN(0)))
 K ^XUSEC("SD SUPERVISOR",DUZ)
 S %=$$CANDELCO^SDMAPI4(.CAN)
 D CHKEQ^XTMUNIT(CAN,0,"Expected error: APTCOSU")
 D CHKEQ^XTMUNIT($P(CAN(0),U),"APTCOSU","Expected error: APTCOSU")
 Q
REQESTS ;
 N SCODE,RETURN,%
 S TC=$P(^SC(+SC,0),U,7),$P(^SC(+SC,0),U,7)=105
 S CONS=$$ADDREQ^ZZRGUSDC(+SD,+DFN,105)
 S RTN="S %=$$GETAPCNS^SDCAPI1(.RETURN,.PAT,105)" D EXSTPAT^ZZRGUSD5(RTN)
 S %=$$GETAPCNS^SDCAPI1(.RETURN,DFN,105)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 ;autorebook
 S RTN="S %=$$AUTOREB^SDCAPI1(.RETURN,.CLN,SD,CONS,1)" D EXSTCLN^ZZRGUSD5(RTN)
 S %=$$AUTOREB^SDCAPI1(.RETURN,SC,SD,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S $P(^SC(+SC,0),U,7)=TC
 Q
CANAPP ;
 N RETURN,%
 K ^SC(+SC,"S"),^DPT(+DFN,"S")
 S SD1=$P(DT,".")_".13",SD1=SD1_U_$$FMTE^XLFDT(SD1)
 ;reactivate cancelled appointment warning
 S LAB=$P(DT,".")_".133",LAB=LAB_U_$$FMTE^XLFDT(LAB)
 S XRAY=$P(DT,".")_".14",XRAY=XRAY_U_$$FMTE^XLFDT(XRAY)
 S EKG=$P(DT,".")_".143",EKG=EKG_U_$$FMTE^XLFDT(EKG)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,.LAB,.XRAY,.EKG,)
 ;check lab, xray, ekg
 S DPT0=+SC_"^^"_+LAB_"^"_+XRAY_"^"_+EKG_"^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD1,0),DPT0,"Invalid patient appointment - 0 node")
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD1,"PC",CRSN,"Cancellation test remarks")
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,.LAB,.XRAY,.EKG,,,.LVL)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTPPCP")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTPPCP","Expected error: APTPPCP")
 ;reactivate cancelled appointment ok
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,.LAB,.XRAY,.EKG,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD1,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^^"_+LAB_"^"_+XRAY_"^"_+EKG_"^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD1,0),DPT0,"Invalid patient appointment - 0 node")
 D CHKEQ^XTMUNIT($D(^DPT(+DFN,"S",+SD1,"R")),0,"Invalid patient appointment - R node")
 ;Cancel existing appointment on same time
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 ;
 S SD1=$P(DT,".")_".22",SD1=SD1_U_$$FMTE^XLFDT(SD1)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD1,TYPE,,LEN,NXT,RSN,,,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 Q
MAKECO ;
 N RETURN,%
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 S CIO="CO",CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,LEN,NXT,RSN,.CIO,,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),"","Past Appt, cannot be checked out.")
 ;appt checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$E($$NOW^XLFDT(),1,10)
 S CIO="CO",CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,LEN,NXT,RSN,.CIO,,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),$E(CIO("DT"),1,12),"Incorrect check out date")
 ;appt checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$E($$NOW^XLFDT(),1,10)
 S CIO="CO" ;,CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,LEN,NXT,RSN,.CIO,,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),$E($$NOW^XLFDT(),1,12),"Incorrect check out date")
 K ^XUSEC("SDOB",DUZ),^XUSEC("SDMOB",DUZ)
 Q
XTENT ;
 ;;CHKAPP;Check make apt
 ;;LSTPATS;Get patients
 ;;GETPAT;Get a patient
 ;;CHKCO;Check in check out
 ;;GETPAT2;Get patient
 ;;ANCTEST;Add/Delete tests
 ;;CANDELCO;Can delete check out?
 ;;REQESTS;Consult request apt
 ;;CANAPP;Un cancel
 ;;MAKECO;Make appt check-out
