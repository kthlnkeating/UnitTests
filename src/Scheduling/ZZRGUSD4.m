ZZRGUSD4 ;Unit Tests - Clinic API; 05/28/2012  11:46 AM
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZRGUSD4")
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
MAKEUS ;
 N SDD
 S SDD=DT_".08",SDD=SDD_U_$$FMTE^XLFDT(SDD)
 S RTN="MAKEUS^SDMAPI2(.RETURN,PAT,CLN,SDD,TYPE)" D EXSTPAT^ZZRGUSD2(RTN),EXSTCLN^ZZRGUSD2(RTN)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDD,TYPE)
 D CHKEQ^XTMUNIT(RETURN,1,"Unexpected error: ")
 S SC0=+DFN_"^"_+LEN_"^^^^"_DUZ_"^"_DT
 D CHKEQ^XTMUNIT(^SC(+SC,"S",+SDD,1,1,0),SC0,"Invalid clinic appointment - 0 node")
 S DPT0=+SC_"^^^^^^4^^^^^^^^^"_+TYPE_"^^"_DUZ_"^"_DT_"^^^^^0^W^0"
 D CHKEQ^XTMUNIT(^DPT(+DFN,"S",+SDD,0),DPT0,"Invalid patient appointment - 0 node")
 ;future appt
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,$$FMADD^XLFDT($$NOW^XLFDT(),1),TYPE)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"INVPARAM","Expected error: INVPARAM")
 ;invalid clinic
 S ^SC(+SC,"I")=DT-1_U_DT+1,SDD=DT_".1",SDD=SDD_U_$$FMTE^XLFDT(SDD)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDD,TYPE)
 D CHKEQ^XTMUNIT(RETURN,0,"Expected error: APTCINV")
 D CHKEQ^XTMUNIT($P(RETURN(0),U),"APTCINV","Expected error: APTCINV")
 K ^SC(+SC,"I")
 Q
MAKECO ;
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 S CIO="CO",CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),"","Past Appt, cannot be checked out.")
 ;appt checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$E($$NOW^XLFDT(),1,10)
 S CIO="CO",CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),$E(CIO("DT"),1,12),"Incorrect check out date")
 ;appt checked out
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S SD0=$E($$NOW^XLFDT(),1,10)
 S CIO="CO" ;,CIO("DT")=$$NOW^XLFDT()
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("COD")),$E($$NOW^XLFDT(),1,12),"Incorrect check out date")
 K ^XUSEC("SDOB",DUZ),^XUSEC("SDMOB",DUZ)
 Q
MAKECI ;
 K ^DPT(+DFN,"S"),^SC(+SC,"S")
 S ^XUSEC("SDOB",DUZ)="",^XUSEC("SDMOB",DUZ)=""
 ;future appointment cannot be checked in
 S SD0=$$NOW^XLFDT(),SD0=$E(SD0,1,12)+0.0001,CIO="CI"
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SD0,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Future Appt cannot be checked in.")
 ;appt checked in
 S SDPAST=$E($$NOW^XLFDT(),1,10)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),+SDPAST,"Incorrect check in date")
 ;past appointment cannot be checked in
 S SDPAST=$E($$FMADD^XLFDT($$NOW^XLFDT(),-1),1,10)
 S %=$$MAKEUS^SDMAPI2(.RETURN,DFN,SC,SDPAST,TYPE,,.CIO)
 D CHKEQ^XTMUNIT(RETURN,1,"Unxpected error: "_$G(RETURN(0)))
 D CHKEQ^XTMUNIT($G(RETURN("CI")),"","Past Appt, cannot be checked in.")
 K ^XUSEC("SDOB",DUZ),^XUSEC("SDMOB",DUZ)
 Q
 ;
XTENT ;
 ;;MAKEUS;Make unscheduled appointment
 ;;MAKECI;Make appt check-in
 ;;MAKECO;Make appt check-out
