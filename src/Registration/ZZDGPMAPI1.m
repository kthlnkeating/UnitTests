ZZDGPMAPI1 ;Unit Tests - Admission API; 4/18/13
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
 N PAR,RTN
 ;Invalid patient
 S RTN="S %=$$ADMIT^DGPMAPI1(.RE,.PAR)"
 D CHKPAT^ZZDGPMSE(RTN,.PAR)
 ;Check date
 D CHKDT^ZZDGPMUTL(RTN,.PAR)
 ;invalid facility directory exclusion
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-6)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM DATE")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('FDEXC')",1,"Expected error: INVPARM DATE")
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
 D CHKBED^ZZDGPMSE(RTN,.PAR,BED1,,2,WARD1)
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMSE(RTN,.PAR)
 ;Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PAR)
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PAR)
 ;Invalid source of admission
 D CHKASRC^ZZDGPMAPI1(RTN,.PAR)
 ;Admit
 S %=$$ADMIT^DGPMAPI1(.RE,.PAR)
 S AFN=RE
 ;check valid data
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U),+PAR("DATE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,4),+PAR("TYPE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,6),+PAR("WARD"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,7),+PAR("ROOMBED"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,10),PAR("SHDIAG"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,12),+PAR("ADMREG"),"Unexpected error: "_$G(RE(0)))
 ;Invalid date
 S TMP=$$FMTE^XLFDT(+PAR("DATE"))
 S PAR("DATE")=$$FMADD^XLFDT(+PAR("DATE"),-1) S %=$$ADMIT^DGPMAPI1(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMPAHAD")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMPAHAD","Expected error: ADMPAHAD")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[TMP,1,"Expected error: ADMPAHAD")
 Q
CHKASRC(RTN,PAR,UPD) ;
 ;primary physician not found
 S PAR("ADMSRC")=($P(^DIC(45.1,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ASRCNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ASRCNFND","Expected error: ASRCNFND")
 S PAR("ADMSRC")=($P(^DIC(45.1,0),U,3)-$G(UPD))_U
 Q
UPDADM ;
 K PAR,RE
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
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-6,-6)_U
 D CHKWARD^ZZDGPMSE(RTN,.PAR,+WARD2,1) M PART=PAR K PAR
 ;Invalid room-bed
 D CHKBED^ZZDGPMSE(RTN,.PAR,+BED2,1,3,WARD1,,PART("DATE")) M PART=PAR K PAR
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMSE(RTN,.PAR,1,,PART("DATE")) M PART=PAR K PAR
 ;Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PAR,1) M PART=PAR K PAR
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PAR) M PART=PAR K PAR
 ;Invalid source of admission
 D CHKASRC^ZZDGPMAPI1(RTN,.PAR,1) M PART=PAR K PAR
 ;Ok
 S PART("TYPE")="2^",PART("FDEXC")="0^",PART("PRYMPHY")="37^"
 S %=$$UPDADM^DGPMAPI1(.RE,.PART,AFN)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U),+PART("DATE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,4),+PART("TYPE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,6),+PART("WARD"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,7),+PART("ROOMBED"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,10),PART("SHDIAG"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,12),+PART("ADMREG"),"Unexpected error: "_$G(RE(0)))
 S %=$$GETADM^DGPMAPI8(.ADM,AFN)
 D CHKEQ^XTMUNIT(+ADM("PRYMPHY"),+PART("PRYMPHY"),"Primary physician")
 D CHKEQ^XTMUNIT(+ADM("ATNDPHY"),+PART("ATNDPHY"),"Primary physician")
 D CHKEQ^XTMUNIT(+ADM("FTSPEC"),+PART("FTSPEC"),"Primary physician")
 ;Invalid date
 D CHKDT^ZZDGPMUTL(RTN,.PAR,1)
 S PARD("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-1)_U,PARD("TYPE")=24,PARD("ADMIFN")=AFN
 S %=$$DISCH^DGPMAPI3(.RR,.PARD)
 S PAR("DATE")=$$NOW^XLFDT() X RTN
 D CHKEQ^XTMUNIT(RE,0,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMMBBNM","Expected error: ADMMBBNM")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[$$FMTE^XLFDT(PARD("DATE")),1,"Expected error: ADMMBBNM")
 Q
DELADM ;
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
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('ADMREG')",1,"Expected error: INVPARM ADMREG")
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
XTENT ;
 ;;ADMIT;Admit patient.
 ;;UPDADM;Update admission.
 ;;DELADM;Delete admission.
