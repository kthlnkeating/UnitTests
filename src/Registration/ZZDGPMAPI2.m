ZZDGPMAPI2 ;Unit Tests - Transfer API; 4/18/13
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGPMAPI2")
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
TRANSF ;
 N PAR,RTN,ADM
 ;Invalid patient
 S ADM("PATIENT")=+DFN,ADM("TYPE")=1,ADM("ADMREG")=1,ADM("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-5,-5)_U
 S ADM("FDEXC")=1,ADM("SHDIAG")="Transfer Admit diagnosis",ADM("WARD")=WARD1,ADM("FTSPEC")="1^"
 S ADM("ATNDPHY")=DUZ_U,ADM("ROOMBED")=BED1
 S PARA(.01)=+WARD1 D ADDBASW^ZZDGPMSE(,+BED1,.PARA)
 S %=$$ADMIT^DGPMAPI1(.RT,.ADM)
 S AFN=+RT
 S RTN="S %=$$TRANSF^DGPMAPI2(.RE,.PAR)"
 ;Check date
 D CHKDT^ZZDGPMUTL(RTN,.PAR)
 ;invalid admission IFN
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-5,-5)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM ADMIFN")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('ADMIFN')",1,"Expected error: INVPARM ADMIFN")
 S PAR("ADMIFN")="aa",PAR("DATE")=$$FMADD^XLFDT(+PAR("DATE"),-1) X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM AFN")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 ;not before admission
 S PAR("ADMIFN")=AFN X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM DATE")
 D CHKEQ^XTMUNIT($P(RE(0),U),"TRANBADM","Expected error: TRANBADM")
 ;time used
 S PAR("DATE")=$$FMADD^XLFDT(+PAR("DATE"),+1) X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: TIMEUSD")
 D CHKEQ^XTMUNIT($P(RE(0),U),"TIMEUSD","Expected error: TIMEUSD")
 ;Invalid transfer type
 S PAR("TYPE")="11^",PAR("INVTYPE")="1",PAR("DATE")=(+PAR("DATE"))+1 ;Direct admission
 D CHKTYPE^ZZDGPMSE(RTN,.PAR)
 ;Invalid ward
 D CHKWARD^ZZDGPMSE(RTN,.PAR,WARD1)
 ;Invalid room-bed
 D CHKBED^ZZDGPMSE(RTN,.PAR,BED2,,2,WARD1)
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMSE(RTN,.PAR,,1)
 ;Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PAR,,1)
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PAR)
 ;Transfer
 ;K PAR("PRYMPHY")
 S %=$$TRANSF^DGPMAPI2(.RE,.PAR)
 S TFN=RE
 ;check valid data
 D CHKEQ^XTMUNIT($P(^DGPM(+TFN,0),U),+PAR("DATE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+TFN,0),U,4),+PAR("TYPE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+TFN,0),U,6),+PAR("WARD"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+TFN,0),U,7),+PAR("ROOMBED"),"Unexpected error: "_$G(RE(0)))
 Q
UPDTRA ;
 K PAR,RE
 ;no update
 S PM0=^DGPM(+TFN,0)
 S RTN="S %=$$UPDTRA^DGPMAPI2(.RE,.PAR,+TFN)" X RTN
 D CHKEQ^XTMUNIT(RE,1,"Expected error: "_$G(RE(0)))
 ;transfer not found
 S %=$$UPDTRA^DGPMAPI2(.RE,.PAR,+TFN+100)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: TRANFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"TRANFND","Expected error: TRANFND")
 ;Check date
 D CHKDT^ZZDGPMUTL(RTN,.PAR,1)
 ;invalid date
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-6)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM DATE")
 D CHKEQ^XTMUNIT($P(RE(0),U),"TRANBADM","Expected error: TRANBADM")
 ;Invalid transfer type
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1)_U
 S PAR("TYPE")="11^"
 ;Invalid ward
 D CHKWARD^ZZDGPMSE(RTN,.PAR,WARD2,1)
 ;Invalid room-bed
 K PARA
 S PARA(.01)=+WARD2,PAR("WARD")=WARD2
 D CHKBED^ZZDGPMSE(RTN,.PAR,BED1,1,3,WARD2)
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMSE(RTN,.PAR,1,1)
 ;Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PAR,1)
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PAR)
 X RTN
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+TFN,0),U),+PAR("DATE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+TFN,0),U,4),+PAR("TYPE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+TFN,0),U,6),+PAR("WARD"),"Unexpected error: "_$G(RE(0)))
 ;Invalid date
 S PARD("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),,-1)_U,PARD("TYPE")=24,PARD("ADMIFN")=AFN
 S %=$$DISCH^DGPMAPI3(.RR,.PARD),DSFN=RR
 S PAR("DATE")=$$NOW^XLFDT() X RTN
 D CHKEQ^XTMUNIT(RE,0,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P($G(RE(0)),U),"TRANADIS","Expected error: TRANADIS")
 S %=$$DELTRA^DGPMAPI2(.RE,TFN)
 S %=$$DELDSCH^DGPMAPI3(.RR,DSFN)
 Q
TOASIH ;
 K PAR,RE
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1)_U,PAR("ADMIFN")=AFN,PAR("TYPE")=13
 S PAR("WARD")=WARD2
 S RTN="S %=$$TRANSF^DGPMAPI2(.RE,.PAR)"
 ; invalid facility directory exclusion
 S PAR("FDEXC")=2 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 ;Invalid admitting regulation
 S PAR("FDEXC")="0^"
 D CHKAREG^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid short diag
 D CHKDIAG^ZZDGPMSE(RTN,.PAR,"To asih diagnosis")
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMSE(RTN,.PAR)
 ;Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PAR)
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PAR)
 ;Invalid source of admission
 D CHKASRC^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid ward service
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ASHWINVS")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ASHWINVS","Expected error: ASHWINVS")
 S $P(^DIC(42,+WARD2,0),U,3)="M"
 ;Invalid ward
 K PAR("WARD")
 D CHKWARD^ZZDGPMSE(RTN,.PAR,WARD2)
 ;Invalid room-bed
 ;D CHKBED^ZZDGPMSE(RTN,.PAR,BED2,,2,WARD2,1)
 ;transfer
 X RTN
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 ;to asih after to asih
 S PAR("DATE")=+PAR("DATE")+0.01 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMINVAT")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMINVAT","Expected error: ADMINVAT")
 ;discharge while asih
 S %=$$GETLASTM^DGPMAPI8(.LMVT,+PAR("PATIENT"))
 S PAR("DATE")=+PAR("DATE")+0.02,PAR("TYPE")=24,PAR("ADMIFN")=LMVT("ADMIFN")
 S %=$$DISCH^DGPMAPI3(.RE,.PAR),DISCH=+RE
 ;Must delete discharge first
 S %=$$GETLASTM^DGPMAPI8(.LMVT,+PAR("PATIENT"))
 S %=$$DELADM^DGPMAPI1(.RE,LMVT("ADMIFN"))
 D CHKEQ^XTMUNIT(RE,0,"Expected error: CANMDDF")
 D CHKEQ^XTMUNIT($P(RE(0),U),"CANMDDF","Expected error: CANMDDF")
 ;delete discharge
 S %=$$DELDSCH^DGPMAPI3(.RE,DISCH)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 S %=$$DELADM^DGPMAPI1(.RE,LMVT("ADMIFN"))
 Q
TOASIHO ;
 K PAR,RE
 ;S ADM("PATIENT")=DFN,ADM("TYPE")=1,ADM("ADMREG")=1,ADM("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-3)_U
 ;S ADM("FDEXC")=1,ADM("SHDIAG")="Check bed diagnosis",ADM("WARD")=WARD,ADM("FTSPEC")=1
 ;S ADM("ATNDPHY")=DUZ,ADM("ROOMBED")=BED
 ;S %=$$ADMIT^DGPMAPI1(.RE,.ADM) S RAFN=RE
 ;
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1)_U,PAR("ADMIFN")=AFN_U,PAR("TYPE")=20
 S RTN="S %=$$TRANSF^DGPMAPI2(.RE,.PAR)" X RTN
 D CHKFCTY^ZZDGPMAPI2(RTN,.PAR)
 ;To ASIH Other facility
 X RTN S ASHO=+RE
 D CHKEQ^XTMUNIT(+RE>0,1,"Unexpected error: "_$G(RE(0)))
 ;delete discharge
 S %=$$GETLASTM^DGPMAPI8(.LMVT,DFN)
 S %=$$DELDSCH^DGPMAPI3(.RE,LMVT("DISIFN"))
 D CHKEQ^XTMUNIT(RE,0,"Expected error: DCHCDWAH")
 D CHKEQ^XTMUNIT($P(RE(0),U),"DCHCDWAH","Expected error: DCHCDWAH")
 ;TO NHCU/DOM FROM ASIH
 S PAR("TYPE")=12,PAR("DATE")=+PAR("DATE")+0.00001 X RTN
 D CHKEQ^XTMUNIT(+RE>0,1,"Unexpected error: "_$G(RE(0)))
 ;delete TO NHCU/DOM FROM ASIH
 S %=$$DELTRA^DGPMAPI2(.RR,+RE)
 D CHKEQ^XTMUNIT(RR,1,"Unexpected error: "_$G(RE(0)))
 ;delete ASIH Other facility
 S %=$$DELTRA^DGPMAPI2(.RR,ASHO)
 D CHKEQ^XTMUNIT(RR,1,"Unexpected error: "_$G(RE(0)))
 Q
CHKFCTY(RTN,PAR,UPD,REQ) ;
 ;Invalid transfer facility
 I +$G(UPD)=0 D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM FCTY")
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('FCTY')",1,"Expected error: INVPARM FCTY")
 ;transfer facility not found
 S PAR("FCTY")=($P(^DIC(4,0),U,3)+10)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: TFCNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"TFCNFND","Expected error: TFCNFND")
 ;inactive transfer facility
 S FTS=$P(^DIC(4,0),U,3),PAR("FCTY")=FTS_U_$P(^DIC(4,FTS,0),U)
 S $P(^DIC(4,+FTS,99),U,4)=1 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: TFCINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"TFCINAC","Expected error: TFCINAC")
 S $P(^DIC(4,+FTS,99),U,4)="" 
 S PAR("FCTY")=(FTS)_U
 Q
TOABS ;
 K PAR,RE
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1)_U,PAR("ADMIFN")=AFN,PAR("TYPE")=16
 S RTN="S %=$$TRANSF^DGPMAPI2(.RE,.PAR)" X RTN S TFN1=+RE
 D CHKEQ^XTMUNIT(+RE>0,1,"Expected error: INVPARM")
 ;invalid transfer type
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1,1)_U,PAR("TYPE")=18 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMINVAT")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMINVAT","Expected error: ADMINVAT")
 ;from absence
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1,1)_U,PAR("TYPE")=14 X RTN S TFN2=+RE
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 ;cleaning up
 ;invalid transfer pair
 S %=$$DELTRA^DGPMAPI2(.RE,TFN1)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: DELTITP")
 D CHKEQ^XTMUNIT($P(RE(0),U),"DELTITP","Expected error: DELTITP")
 S %=$$DELTRA^DGPMAPI2(.RE,TFN2)
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 S %=$$DELTRA^DGPMAPI2(.RE,TFN1)
 D CHKEQ^XTMUNIT(RE>0,1,"Unexpected error: "_$G(RE(0)))
 Q
 ;
XTENT ;
 ;;TRANSF;Transfer patient.
 ;;UPDTRA;Update transfer.
 ;;TOASIH;To ASIH transfer.
 ;;TOASIHO;To ASIH OTHER FACILITY) transfer.
 ;;TOABS;To absence transfer.
