ZZRGUSD2 ;Unit Tests - Clinic API; 1/25/2013
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD2")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT
 D LOGON^ZZRGUTCM
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZRGUSDC()
 Q
 ;
SHUTDOWN ;
 Q
 ;
MAKE ;
 S TC=$P(^SC(+SC,0),U,7)
 S SCODE=105,$P(^SC(+SC,0),U,7)=105
 S CONS=$$ADDREQ^ZZRGUSDC(SD,DFN,SCODE)
 S $P(^SC(+SC,0),U,7)=TC
 ;
 S RTN="MAKE^SDMAPI2(.RETURN,PAT,CLN,SD,TYPE,,LEN)" D EXSTPAT(RTN),EXSTCLN(RTN)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN,,,,,,CONS)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
CHECKIN ;
 S %=$$CHECKIN^SDMAPI2(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 ;D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC=$P(NOW,".")_"^"_DUZ_"^^^"_NOW
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,"C"),SCC,"Invalid clinic appointment - C node")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 S RTN="CHECKIN^SDMAPI2(.RETURN,PAT,SD,CLN)" D EXSTPAT(RTN),EXSTCLN(RTN)
 Q
EXSTPAT(RTN) ;
 ;Invalid patient param
 S PAT=0,CLN=SC D @RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;patient does not exist
 S PAT=DFN+1,CLN=SC D @RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: PATNFND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"PATNFND","Expected error: PATNFND")
 Q
EXSTCLN(RTN) ;
 ;Invalid clinic param
 S CLN=0,PAT=DFN D @RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;clinic does not exist
 S CLN=SC+1,PAT=DFN D @RTN
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"CLNNFND","Expected error: CLNNFND")
 Q
NOSHOW ;
 S %=$$NOSHOW^SDMAPI2(.RETURN,DFN,SC,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment 0 node")
 S DPT0=+SC_"^N^^^^^3^^^^^"_DUZ_"^^"_NOW_"^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 I $P(^DPT(+DFN,"S",+SD,0),U,2)="N" D
 . S NOW=$$NOW^XLFDT(),%=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 . D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCNPE")
 . D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCNPE","Expected error: APTCNPE")
 S $P(^GMR(123,CONS,0),U,12)=13
 S %=$$GETAPCNS^SDCAPI1(.RETURN,DFN,SCODE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S %=$$NOSHOW^SDMAPI2(.RETURN,DFN,SC,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTNSAL")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTNSAL","Expected error: APTNSAL")
 S %=$$NOSHOW^SDMAPI2(.RETURN,DFN,SC,SD,1),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($P(^DPT(+DFN,"S",+SD,0),U,2),"","Unxpected error: "_$G(RETURN(0)))
 S RTN="NOSHOW^SDMAPI2(.RETURN,PAT,CLN,SD,1)" D EXSTPAT(RTN),EXSTCLN(RTN)
 Q
CANCEL ;
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD=$P(DT,".")_".09",SD=SD_U_$$FMTE^XLFDT(SD)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN,,,,,,CONS)
 ;Cancellation reason errors (INVPARAM)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;Cancellation reason errors (RSNNFND)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",$P(^SD(409.2,0),U,3)+1,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: RSNNFND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"RSNNFND","Expected error: RSNNFND")
 ;Cancelled by errors (INVPARAM)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,,CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;Cancelled by errors (INVPARAM)
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"C",5,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;
 ;
 S %=$$GETAPCNS^SDCAPI1(.RETURN,DFN,SCODE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S $P(^DPT(+DFN,"S",+SD,0),U,2)="C"
 S RTN="CANCEL^SDMAPI2(.RETURN,PAT,CLN,SD,""PC"",RSN,)" D EXSTPAT(RTN),EXSTCLN(RTN)
 ; Already cancelled
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCAND")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCAND","Expected error: APTCAND")
 S $P(^DPT(+DFN,"S",+SD,0),U,2)=""
 ; Checked out
 S $P(^SC(+SC,"S",+SD,1,1,"C"),U,3)=+SD
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCCHO")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCCHO","Expected error: APTCCHO")
 S $P(^SC(+SC,"S",+SD,1,1,"C"),U,3)=""
 ; User rights
 S ^SC(+SC,"SDPROT")="Y"
 S %=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCRGT")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCRGT","Expected error: APTCRGT")
 K ^SC(+SC,"SDPROT")
 ;
 S NOW=$$NOW^XLFDT(),%=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",CRSN,"Cancellation test remarks")
 S SC0=+DFN_"^"_+LEN_"^^"_+CRSN_"^^"_DUZ_"^"_DT_"^^^"
 D CHKEQ^XTMUNIT($G(^SC(+SC,"S",+SD,1,1)),"","Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^PC^^^^^3^^^^^"_DUZ_"^^"_$E(NOW,1,12)_"^"_+CRSN_"^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 ;
 S $P(^GMR(123,CONS,0),U,12)=8
 S TC=$P(^SC(+SC,0),U,7),$P(^SC(+SC,0),U,7)=105
 S %=$$GETAPCNS^SDCAPI1(.RETURN,DFN,SCODE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: "_$G(RETURN(0)))
 S $P(^SC(+SC,0),U,7)=TC
 Q
CHECKO ;
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 S RTN="CHECKO^SDMAPI4(.RETURN,PAT,SD,CLN)" D EXSTPAT(RTN),EXSTCLN(RTN)
 S %=$$CHECKO^SDMAPI4(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC="^^"_NOW_"^"_DUZ_"^^"_NOW
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S SDOE=RETURN("SDOE")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^"_SDOE_"^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 S %=$$GETOE^SDMAPI4(.R,SDOE)
 S NOD=R(.01)_U_R(.02)_U_R(.03)_U_R(.04)_U_R(.05)_U_U_R(.07)_U_R(.08)
 D CHKEQ^XTMUNIT(NOD,$P(^SCE(SDOE,0),U,1,8),"Invalid encounter")
 S %=$$CHECKO^SDMAPI4(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCOAC")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCOAC","Expected error: APTCOAC")
 Q
PTFU ;
 S %=$$PTFU^SDMAPI1(.RETURN,DFN,SC)
 D CHKEQ^XTMUNIT(RETURN,1)
 Q
DELCO ;
 S RTN="DELCOSD^SDMAPI4(.RETURN,PAT,SD)" D EXSTPAT(RTN)
 S %=$$DELCOSD^SDMAPI4(.RETURN,DFN,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=+DFN_"^"_+LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC="^^^^^"
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SD,1,1,"C"),SCC,"Invalid clinic appointment - C node")
 S DPT0=+SC_"^^^^^^3^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^"_SDOE_"^^^^0^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SD,0),DPT0,"Invalid patient appointment - 0 node")
 S OE=RETURN("OE") K RETURN
 S $P(^SCE(OE,0),U,8)=3,^SCE(OE+1,0)=^SCE(OE,0),$P(^SCE(OE+1,0),U,6)=OE
 S ^SCE("APAR",OE,OE+1)=""
 S %=$$GETCHLD^SDMAPI4(.RETURN,OE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S %=$$DELCOPC^SDMAPI4(.RETURN,OE,,"PCE")
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 Q
DISCH ;
 N RSN
 S RSN="Discharge reason"
 S SC1=$$ADDCLN^ZZRGUSDC("Disch Clinic"),SCT=SC,SC=SC1
 S RTN="GETPENRL^SDMAPI3(.RETURN,PAT,CLN)" D EXSTPAT(RTN),EXSTCLN(RTN)
 S SC=SCT
 S %=$$GETPENRL^SDMAPI3(.ENS,DFN,SC1)
 D CHKEQ^XTMUNIT(ENS(+SC1,"NAME"),"Disch Clinic","Expected clinic: Disch Clinic")
 D SETENR^ZZRGUSDC(DFN,SC)
 S %=$$GETPENRL^SDMAPI3(.ENS,DFN,SC)
 D CHKEQ^XTMUNIT(ENS(+SC,"STATUS"),"","Expected status: Active")
 D CHKEQ^XTMUNIT(ENS(+SC,"EN",1,"ENROLLMENT"),DT,"Invalid enrollment date")
 S ENS(+SC,"EN",1,"DISCHARGE")=DT
 S ENS(+SC,"EN",1,"REASON")=RSN
 S RTN="DISCH^SDMAPI3(.RETURN,.ENS,PAT)" D EXSTPAT(RTN)
 S %=$$DISCH^SDMAPI3(.RETURN,.ENS,DFN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: PATDHFA")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"PATDHFA","Expected error: PATDHFA")
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S %=$$DISCH^SDMAPI3(.RETURN,.ENS,DFN)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(^DPT(+DFN,"DE",1,0),+SC_"^I","Expected status: Inactive")
 D CHKEQ^XTMUNIT(^DPT(+DFN,"DE",1,1,1,0),DT_"^O^"_DT_U_RSN_U,"Expected status: Inactive")
 Q
MAKECI ;
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked in
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,LEN,NXT,RSN,"CI",,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Future Appt cannot be checked in.")
 ;appt checked in
 S SDPAST=$E($$NOW^XLFDT(),1,10)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,LEN,NXT,RSN,"CI",,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),+SDPAST,"Incorrect check in date")
 ;past appointment cannot be checked in
 S SDPAST=$E($$FMADD^XLFDT($$NOW^XLFDT(),-1),1,10)
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,LEN,NXT,RSN,"CI",,,,,CONS,1)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Past Appt, cannot be checked in.")
 K ^XUSEC("SDOB",DUZ),^XUSEC("SDMOB",DUZ)
 Q
 ;
XTENT ;
 ;;MAKE;Make appointment
 ;;CHECKIN;Check in appointment
 ;;NOSHOW;No show appointment
 ;;CANCEL;Cancel appointment
 ;;CHECKO;Check out appointment
 ;;PTFU;Determine follow-up apt
 ;;DELCO;Delete check out
 ;;DISCH;Discharge from clinic
 ;;MAKECI;Make appt check-in
