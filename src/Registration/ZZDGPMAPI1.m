ZZDGPMAPI1 ;Unit Tests - Admission API;07/03/13  12:05
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGPMAPI1")
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
ADMIT ;
 N PAR,RTN,DGQUIET
 ;Invalid patient
 S RTN="S %=$$ADMIT^DGPMAPI1(.RE,.PAR)"
 D CHKPAT^ZZDGPMSE(RTN,.PAR)
 ;Check date
 D CHKDT^ZZDGPMUTL(RTN,.PAR)
 ;invalid facility directory exclusion
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),,-6)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM DATE")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM(""FDEXC"")",1,"Expected error: INVPARM DATE")
 S PAR("FDEXC")="1^"
 ;Invalid admitting regulation
 D CHKAREG^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid admission type
 S PAR("TYPE")="1^",PAR("INVTYPE")="11" ;Direct admission
 D CHKTYPE^ZZDGPMSE(RTN,.PAR)
 ;Invalid short diag
 D CHKDIAG^ZZDGPMSE(RTN,.PAR,"Update diagnosis")
 ;Invalid ward
 D CHKWARD^ZZDGPMSE(RTN,.PAR,WARD1)
 ;Invalid room-bed
 D CHKBED^ZZDGPMSE(RTN,.PAR,BED1,,2,WARD1,,,1)
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMSE(RTN,.PAR)
 ;Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PAR)
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PAR)
 ;Invalid source of admission
 D CHKASRC^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid eligibility
 D CHKELIG^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid admitting category
 D CHKACAT^ZZDGPMAPI1(RTN,.PAR,,PAR("ADMREG"))
 ;Admit
 S PAR("DIAG",1)="Diag 1",PAR("DIAG",3)="Diag 3"
 S %=$$ADMIT^DGPMAPI1(.RE,.PAR)
 S AFN=RE
 D CHKDAT(AFN,.PAR,.RE,"ADMIT")
 ;Invalid date
 S TMP=$$FMTE^XLFDT(+PAR("DATE"))
 S PAR("DATE")=$$FMADD^XLFDT(+PAR("DATE"),-1) S %=$$ADMIT^DGPMAPI1(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMPAHAD")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMPAHAD","Expected error: ADMPAHAD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[TMP,1,"Expected error: ADMPAHAD")
 Q
CHKDAT(AFN,PAR,RE,OP)
 ;check valid data
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U),+PAR("DATE"),"Incorrect admission date - "_OP)
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,4),+PAR("TYPE"),"Incorrect admission type - "_OP)
 D CHKEQ^XTMUNIT(+$P(^DGPM(+AFN,0),U,5),+$G(PAR("FCTY")),"Incorrect fcty - "_OP)
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,6),+PAR("WARD"),"Incorrect ward - "_OP)
 D CHKEQ^XTMUNIT(+$P(^DGPM(+AFN,0),U,7),+$G(PAR("ROOMBED")),"Incorrect bed - "_OP)
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,10),PAR("SHDIAG"),"Incorrect shdiag - "_OP)
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,12),+PAR("ADMREG"),"Incorrect admreg - "_OP)
 Q
CHKASRC(RTN,PAR,UPD) ;
 ;primary physician not found
 S PAR("ADMSRC")=($P(^DIC(45.1,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ASRCNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ASRCNFND","Expected error: ASRCNFND")
 S PAR("ADMSRC")=($P(^DIC(45.1,0),U,3)-$G(UPD))_U
 Q
CHKELIG(RTN,PAR,UPD) ;
 ;invalid param
 S PAR("ELIGIB")="AA" X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 S ^DPT(+DFN,.36)="9"
 S PAR("ELIGIB")=5 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: PATENFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"PATENFND","Expected error: PATENFND")
 S PAR("ELIGIB")=9
 Q
CHKACAT(RTN,PAR,UPD,AREG) ;
 ;invalid param
 N SASC
 S PAR("ADMCAT")="AA" X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARM^Invalid parameter value - PARAM(""ADMCAT"")","Expected error: INVPARM")
 ;not found
 S PAR("ADMCAT")=2 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: SACNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"SACNFND","Expected error: SACNFND")
 ;inactive category
 S CATN="Category "_(1+$G(UPD))
 S %=$$ADDSASC^DGSAAPI(.SASC,CATN)
 S %=$$ADDACAT^DGSAAPI(.SAC,AREG,SASC)
 S PAR("ADMREG")=AREG,PAR("ADMCAT")=SASC X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ACATINAC")
 D CHKEQ^XTMUNIT($G(RE(0)),"ACATINAC^Admitting category '"_CATN_"' is inactive.","Expected error: ACATINAC")
 S %=$$UPDCAT^DGSAAPI(.SAC,SAC,1)
 Q
UPDADM ;
 K PAR,RE,DGQUIET
 ;no update
 S PM0=^DGPM(+AFN,0)
 S RTN="S %=$$UPDADM^DGPMAPI1(.RE,.PAR,+AFN)" X RTN
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 ;admission not found
 S %=$$UPDADM^DGPMAPI1(.RE,.PAR,+AFN+100)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMNFND","Expected error: ADMNFND")
 ;Invalid admission type
 S PAR("TYPE")="2^",PAR("INVTYPE")="11" ;Direct admission
 D CHKTYPE^ZZDGPMSE(RTN,.PAR,1) M PART=PAR K PAR
 ; invalid facility directory exclusion
 S PAR("FDEXC")=2 X RTN K PAR
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 ;Invalid admitting regulation
 D CHKAREG^ZZDGPMAPI1(RTN,.PAR,1) M PART=PAR K PAR
 ;Invalid short diag
 D CHKDIAG^ZZDGPMSE(RTN,.PAR,"Update diagnosis") M PART=PAR K PAR
 ;Invalid ward
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),,-6)_U
 D CHKWARD^ZZDGPMSE(RTN,.PAR,+WARD2,1) M PART=PAR K PAR
 ;Invalid room-bed
 D CHKBED^ZZDGPMSE(RTN,.PAR,+BED2,1,3,WARD1,,PART("DATE"),1) M PART=PAR K PAR
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMSE(RTN,.PAR,1,,PART("DATE")) M PART=PAR K PAR
 ;Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PAR,1) M PART=PAR K PAR
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PAR) M PART=PAR K PAR
 ;Invalid source of admission
 D CHKASRC^ZZDGPMAPI1(RTN,.PAR,1) M PART=PAR K PAR
 ;Invalid eligibility
 D CHKELIG^ZZDGPMAPI1(RTN,.PAR,1) M PART=PAR K PAR
 ;Invalid admitting category
 D CHKACAT^ZZDGPMAPI1(RTN,.PAR,1,PART("ADMREG")) M PART=PAR K PAR
 ;Ok
 S PART("TYPE")="2^",PART("FDEXC")="0^",PART("PRYMPHY")="37^"
 S %=$$UPDADM^DGPMAPI1(.RE,.PART,AFN)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U),+PART("DATE"),"Date update failed")
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,4),+PART("TYPE"),"Type update failed")
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,6),+PART("WARD"),"Ward update failed")
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,7),+PART("ROOMBED"),"Bed update failed")
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,10),PART("SHDIAG"),"Short diag update failed")
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,12),+PART("ADMREG"),"Admitting regulation update failed")
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,"PTF"),U,4),+PART("ADMCAT"),"Admitting category update failed")
 S %=$$GETADM^DGPMAPI8(.ADM,AFN)
 D CHKEQ^XTMUNIT(+ADM("PRYMPHY"),+PART("PRYMPHY"),"Primary physician")
 D CHKEQ^XTMUNIT(+ADM("ATNDPHY"),+PART("ATNDPHY"),"Primary physician")
 D CHKEQ^XTMUNIT(+ADM("FTSPEC"),+PART("FTSPEC"),"Primary physician")
 ;Invalid date
 D CHKDT^ZZDGPMUTL(RTN,.PAR,1)
 S PARD("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),,-1)_U,PARD("TYPE")=24,PARD("ADMIFN")=AFN
 S %=$$DISCH^DGPMAPI3(.RR,.PARD)
 S PAR("DATE")=$$NOW^XLFDT() X RTN
 D CHKEQ^XTMUNIT(RE,0,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMMBBNM","Expected error: ADMMBBNM")
 Q
DELADM ;
 N DGQUIET
 S TR("TYPE")=13
 S %=$$TRANSF^DGPMAPI2(.RR,.TR)
 S %=$$DELADM^DGPMAPI1(.RE,AFN)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 Q
CHKAREG(RTN,PAR,UPD) ;
 ;Invalid admitting regulation
 X RTN
 D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 I +$G(UPD)=0 D
 . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM ADMREG")
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM(""ADMREG"")",1,"Expected error: INVPARM ADMREG")
 ;admitting regulation not found
 S PAR("ADMREG")=($P(^DIC(43.4,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: AREGNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"AREGNFND","Expected error: AREGNFND")
 ;inactive admitting regulation 
 S PAR("ADMREG")=($P(^DIC(43.4,0),U,3)-1)_U
 S $P(^DIC(43.4,+PAR("ADMREG"),0),U,4)=1 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: AREGNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"AREGINAC","Expected error: AREGNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[$P(^DIC(43.4,+PAR("ADMREG"),0),U,1),1,"Expected error: INVPARM")
 S $P(^DIC(43.4,+PAR("ADMREG"),0),U,4)=0
 S PAR("ADMREG")=(($P(^DIC(43.4,0),U,3))-$G(UPD))_U
 Q
TRANSFIN ;Transfer in patient.
 N PAR,RE
 S PAR("ADMSRC")="53^",PAR("ATNDPHY")=DUZ,PAR("DATE")=$$NOW^XLFDT(),PAR("FTSPEC")="40^",PAR("FDEXC")=1
 S PAR("PATIENT")=DFN,PAR("SHDIAG")="Update diagnosis",PAR("TYPE")="5^",PAR("WARD")=WARD1,PAR("ADMREG")="75^"
 ; invalid param transfer facility
 S RTN="S %=$$ADMIT^DGPMAPI1(.RE,.PAR)"
 D CHKFCTY^ZZDGPMAPI2(RTN,.PAR)
 ; ok to add
 S PAR("FCTY")=$P(^DIC(4,0),U,3)
 S %=$$ADMIT^DGPMAPI1(.RE,.PAR)
 D CHKDAT(RE,.PAR,.RE,"TRANSFIN")
 S AFN=+RE
 S %=$$DELADM^DGPMAPI1(.RE,+RE)
 S PAR("ADMSRC")="53^",PAR("ATNDPHY")=DUZ,PAR("DATE")=$$NOW^XLFDT(),PAR("FTSPEC")="40^",PAR("FDEXC")=1
 S PAR("PATIENT")=DFN,PAR("SHDIAG")="Update diagnosis",PAR("TYPE")="1^",PAR("WARD")=WARD1,PAR("ADMREG")="75^"
 S PAR("FCTY")=$P(^DIC(4,0),U,3)+99
 S %=$$ADMIT^DGPMAPI1(.RE,.PAR)
 K PAR
 ; invalid param transfer facility
 S PAR("TYPE")="5^"
 S RTN="S %=$$UPDADM^DGPMAPI1(.RE,.PAR,AFN)"
 D CHKFCTY^ZZDGPMAPI2(RTN,.PAR)
 ; ok to update
 S PAR("FCTY")=$P(^DIC(4,0),U,3)
 S %=$$UPDADM^DGPMAPI1(.RE,.PAR,AFN)
 D CHKEQ^XTMUNIT(+$P(^DGPM(+AFN,0),U,5),+$G(PAR("FCTY")),"Incorrect fcty - TRANSIN")
 Q
XTENT ;
 ;;ADMIT;Admit patient.
 ;;UPDADM;Update admission.
 ;;DELADM;Delete admission.
 ;;TRANSFIN;Transfer in patient.
