ZZRGUSD2 ;Unit Tests - Clinic API; 05/28/2012  11:46 AM
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 S IO=""
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD2")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,IO="",U="^"
 S CNAME="Test Clinic"
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
 N RETURN
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: ")
 S SC0=DFN_"^"_LEN_"^^"_RSN_"^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=SC_"^^^^^^3^^^^^^^^^"_TYPE_"^^"_DUZ_"^"_DT_"^^^^^^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(DFN,"S",SD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
CHECKIN ;
 N RETURN
 S %=$$CHECKIN^SDMAPI2(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 ;D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=DFN_"^"_LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC=NOW_"^"_DUZ_"^^^"_NOW
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,"C"),SCC,"Invalid clinic appointment - C node")
 S DPT0=SC_"^^^^^^3^^^^^^^^^"_TYPE_"^^"_DUZ_"^"_DT_"^^^^^^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(DFN,"S",SD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
NOSHOW ;
 N RETURN
 S %=$$NOSHOW^SDMAPI2(.RETURN,DFN,SC,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=DFN_"^"_LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,0),SC0,"Invalid clinic appointment 0 node")
 S DPT0=SC_"^N^^^^^3^^^^^"_DUZ_"^^"_NOW_"^^"_TYPE_"^^"_DUZ_"^"_DT_"^^^^^^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(DFN,"S",SD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
CANCEL ;
 N RETURN,RSN
 S RSN=6
 I $P(^DPT(DFN,"S",SD,0),U,2)="N" D
 . S NOW=$$NOW^XLFDT(),%=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",RSN,"Cancellation test remarks")
 . D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCNPE")
 . D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCNPE","Expected error: APTCNPE")
 . S $P(^DPT(DFN,"S",SD,0),U,2)=""
 S NOW=$$NOW^XLFDT(),%=$$CANCEL^SDMAPI2(.RETURN,DFN,SC,SD,"PC",RSN,"Cancellation test remarks")
 S SC0=DFN_"^"_LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 D CHKEQ^XTMUNIT($G(^SC(SC,"S",SD,1,1)),"","Invalid clinic appointment - 0 node")
 S DPT0=SC_"^PC^^^^^3^^^^^"_DUZ_"^^"_$E(NOW,1,12)_"^"_RSN_"^"_TYPE_"^^"_DUZ_"^"_DT_"^^^^^^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(DFN,"S",SD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
MAKEUS ;
 N RETURN
 S SDD=DT+1_".08"
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDD,TYPE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: ")
 S SC0=DFN_"^"_LEN_"^^^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(SC,"S",SDD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=SC_"^^^^^^4^^^^^^^^^"_TYPE_"^^"_DUZ_"^"_DT_"^^^^^^W^0"
 D CHKEQ^XTMUNIT(^DPT(DFN,"S",SDD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
CHECKO ;
 N RETURN
 K ^DPT(DFN,"S"),^SC(SC,"S")
 S %=$$MAKE^SDMAPI2(.RETURN,DFN,SC,SD,TYPE,,LEN,NXT,RSN)
 S %=$$CHECKO^SDMAPI4(.RETURN,DFN,SD,SC),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=DFN_"^"_LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC="^^"_NOW_"^"_DUZ_"^^"_NOW
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,"C"),SCC,"Invalid clinic appointment - C node")
 S SDOE=RETURN("SDOE")
 S DPT0=SC_"^^^^^^3^^^^^^^^^"_TYPE_"^^"_DUZ_"^"_DT_"^"_SDOE_"^^^^^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(DFN,"S",SD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
DELCO ;
 N RETURN
 S %=$$DELCO^SDMAPI4(.RETURN,DFN,SD),NOW=$$NOW^XLFDT()
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 S SC0=DFN_"^"_LEN_"^^"_RSN_"^^"_DUZ_"^"_DT_"^^^"
 S SCC="^^^^^"
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 D CHKEQ^XTMUNIT(^SC(SC,"S",SD,1,1,"C"),SCC,"Invalid clinic appointment - C node")
 S DPT0=SC_"^^^^^^3^^^^^^^^^"_TYPE_"^^"_DUZ_"^"_DT_"^"_SDOE_"^^^^^"_NXT_"^3"
 D CHKEQ^XTMUNIT(^DPT(DFN,"S",SD,0),DPT0,"Invalid patient appointment - 0 node")
 Q
DISCH ;
 N RETURN,ENS,RSN
 S RSN="Discharge reason"
 D SETENR^ZZRGUSDC(DFN,SC)
 S %=$$GETPENRL^SDMAPI3(.ENS,DFN,SC)
 D CHKEQ^XTMUNIT(ENS(SC,"STATUS"),"","Expected status: Active")
 D CHKEQ^XTMUNIT(ENS(SC,"EN",1,"ENROLLMENT"),DT,"Invalid enrollment date")
 S ENS(SC,"EN",1,"DISCHARGE")=DT
 S ENS(SC,"EN",1,"REASON")=RSN
 S %=$$DISCH^SDMAPI3(.RETURN,.ENS,DFN)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: PATDHFA")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"PATDHFA","Expected error: PATDHFA")
 K RETURN,^DPT(DFN,"S"),^SC(SC,"S")
 S %=$$DISCH^SDMAPI3(.RETURN,.ENS,DFN)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT(^DPT(DFN,"DE",1,0),SC_"^I","Expected status: Inactive")
 D CHKEQ^XTMUNIT(^DPT(DFN,"DE",1,1,1,0),DT_"^O^"_DT_U_RSN_U,"Expected status: Inactive")
 Q
XTENT ;
 ;;MAKE;Make appointment
 ;;CHECKIN;Check in appointment
 ;;NOSHOW;No show appointment
 ;;CANCEL;Cancel appointment
 ;;MAKEUS;Make unscheduled appointment
 ;;CHECKO;Check out appointment
 ;;DELCO;Delete check out
 ;;DISCH;Discharge from clinic
