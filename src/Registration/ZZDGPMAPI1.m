ZZDGPMAPI1 ;Unit Tests - Clinic API; 2/20/2013
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
 D CHKPAT^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid date
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM DATE")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('DATE')",1,"Expected error: INVPARM DATE")
 ;invalid facility directory exclusion
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-3.01)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM DATE")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('FDEXC')",1,"Expected error: INVPARM DATE")
 S PAR("FDEXC")="1^"
 ;Invalid admitting regulation
 D CHKAREG^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid admission type
 S PAR("TYPE")="1^" ;Direct admission
 D CHKTYPE^ZZDGPMAPI1(RTN,.PAR)
 S PAR("TYPE")="11^"
 S %=$$ADMIT^DGPMAPI1(.RE,.PAR)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMINVAT")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMINVAT","Expected error: ADMINVAT")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["INTERWARD TRANSFER",1,"Expected error: ADMINVAT")
 S PAR("TYPE")="1^"
 ;Invalid short diag
 D CHKDIAG^ZZDGPMAPI1(RTN,.PAR,"Update diagnosis")
 ;Invalid ward
 D CHKWARD^ZZDGPMAPI1(RTN,.PAR,WARD1)
 ;Invalid room-bed
 D CHKBED^ZZDGPMAPI1(RTN,.PAR,BED1,,2,WARD1)
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid attender
 D CHKATD^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMAPI1(RTN,.PAR)
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
CHKPRYM(RTN,PAR) ;
 ;primary physician not found
 S PAR("PRYMPHY")=($P(^VA(200,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: PROVNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"PROVNFND","Expected error: PROVNFND")
 ;inactive fts
 S PAR("PRYMPHY")="1^" X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: PROVINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"PROVINAC","Expected error: PROVINAC")
 S PAR("PRYMPHY")=DUZ_U
 Q
CHKATD(RTN,PAR,UPD,REQ) ;
 ;Invalid attender
 I '$G(REQ) D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 . . I +$G(UPD)=0 D
 . . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM FTSPEC")
 . . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('ATNDPHY')",1,"Expected error: INVPARM FTSPEC")
 ;attender not found
 S PAR("ATNDPHY")=($P(^VA(200,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: PROVNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"PROVNFND","Expected error: PROVNFND")
 ;inactive fts
 S PAR("ATNDPHY")="1^" X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: PROVINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"PROVINAC","Expected error: PROVINAC")
 S PAR("ATNDPHY")=DUZ_U
 Q
CHKFTS(RTN,PAR,UPD,REQ) ;
 ;Invalid facility treating specialty
 I '$G(REQ) D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 . I +$G(UPD)=0 D
 . . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM FTSPEC")
 . . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('FTSPEC')",1,"Expected error: INVPARM FTSPEC")
 ;facility treating specialty not found
 S PAR("FTSPEC")=($P(^DIC(45.7,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: FTSNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"FTSNFND","Expected error: FTSNFND")
 ;inactive fts
 S FTS=$P(^DIC(45.7,0),U,3),PAR("FTSPEC")=FTS_U_$P(^DIC(45.7,FTS,0),U)
 K PARA S PARA(.01)=$P(+PAR("DATE"),"."),PARA(.02)=0 D ADDFOOS^ZZDGPMSE(,PAR("FTSPEC"),.PARA) X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: FTSINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"FTSINAC","Expected error: FTSINAC")
 K ^DIC(45.7,+FTS,"E")
 S PAR("FTSPEC")=(FTS-$G(UPD))_U
 Q
CHKBED(RTN,PAR,BED,UPD,PP,WARD,TRA) ;
 ;bed not found
 S PAR("ROOMBED")=($P(^DG(405.4,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: BEDNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"BEDNFND","Expected error: BEDNFND")
 ;Ward cannot assign
 I '$G(TRA) D
 . S PAR("ROOMBED")=BED X RTN
 . D CHKEQ^XTMUNIT(RE,0,"Expected error: WRDCNASB")
 . D CHKEQ^XTMUNIT($P(RE(0),U),"WRDCNASB","Expected error: WRDCNASB")
 ;Inactive bed
 K PARA S PARA(.01)=+PAR("WARD") D ADDBASW^ZZDGPMSE(,+BED,.PARA)
 K PARA S PARA(.01)=$P(+PAR("DATE"),"."),PARA(.06)=1 D ADDBOOS^ZZDGPMSE(,+BED,.PARA) X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: BEDINACT")
 D CHKEQ^XTMUNIT($P(RE(0),U),"BEDINACT","Expected error: BEDINACT")
 K ^DG(405.4,+BED,"I")
 ;Occupied bed
 S DFN1=$$ADDPAT^ZZDGPMSE("TEST1,PATIENT",PP)
 S ADM("PATIENT")=DFN1,ADM("TYPE")=1,ADM("ADMREG")=1,ADM("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-3)_U
 S ADM("FDEXC")=1,ADM("SHDIAG")="Check bed diagnosis",ADM("WARD")=WARD,ADM("FTSPEC")=1
 S ADM("ATNDPHY")=DUZ,ADM("ROOMBED")=BED M ADM1=ADM
 S %=$$ADMIT^DGPMAPI1(.RE,.ADM) S RAFN=RE
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: BEDOCC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"BEDOCC","Expected error: BEDOCC")
 S %=$$DELADM^DGPMAPI1(,RAFN)
 Q
CHKWARD(RTN,PAR,WFN,UPD) ;
 ;Invalid ward
 X RTN
 D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 I +$G(UPD)=0 D
 . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM WARD")
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('WARD')",1,"Expected error: INVPARM WARD")
 ;ward not found
 S PAR("WARD")=($P(^DIC(42,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: WRDNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"WRDNFND","Expected error: WRDNFND")
 ;Invalid G&L Order
 K PARA S PARA(400)="@" D UPDWARD^ZZDGPMSE(,.PARA,+WFN)
 S PAR("WARD")=WFN_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: WRDINVGL")
 D CHKEQ^XTMUNIT($P(RE(0),U),"WRDINVGL","Expected error: WRDINVGL")
 ;Inactive ward
 K PARA S PARA(400)=1.5 D UPDWARD^ZZDGPMSE(,.PARA,+WFN)
 K PARA S PARA(.01)=$P(+PAR("DATE"),"."),PARA(.06)=1 D ADDWOOS^ZZDGPMSE(,+WFN,.PARA) X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: WRDINACT")
 D CHKEQ^XTMUNIT($P(RE(0),U),"WRDINACT","Expected error: WRDINACT")
 K ^DIC(42,+WFN,"OOS")
 S PAR("WARD")=(WFN-$G(UPD))_U
 Q
CHKDIAG(RTN,PAR,DIAG) ;
 ;Invalid short diagnosis
 S PAR("SHDIAG")="Di" X RTN K PAR("SHDIAG")
 D CHKEQ^XTMUNIT(RE,0,"Expected error: SHDGINV")
 D CHKEQ^XTMUNIT($P(RE(0),U),"SHDGINV","Expected error: SHDGINV")
 ;too long
 F I=1:1:31 S PAR("SHDIAG")=$G(PAR("SHDIAG"))_"D"
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: SHDGINV")
 D CHKEQ^XTMUNIT($P(RE(0),U),"SHDGINV","Expected error: SHDGINV")
 S PAR("SHDIAG")=DIAG
 Q
CHKTYPE(RTN,PAR,UPD) ;
 ;Invalid movement type
 N TMP
 S TMP=PAR("TYPE") K PAR("TYPE")
 X RTN
 D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 I +$G(UPD)=0 D
 . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM TYPE")
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('TYPE')",1,"Expected error: INVPARM TYPE")
 ;movement type not found
 S PAR("TYPE")=($P(^DG(405.1,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: MVTTNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"MVTTNFND","Expected error: MVTTNFND")
 ;inactive movement type
 S PAR("TYPE")=TMP
 S $P(^DG(405.1,+PAR("TYPE"),0),U,4)=0 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: MVTTINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"MVTTINAC","Expected error: MVTTINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[$P(^DG(405.1,+PAR("TYPE"),0),U,1),1,"Expected error: MVTTINAC")
 S $P(^DG(405.1,+PAR("TYPE"),0),U,4)=1
 Q
CHKPAT(RTN,PAR) ;
 ;Invalid patient param
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM PATIENT")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('PATIENT')",1,"Expected error: INVPARM PATIENT")
 ;patient not found
 S PAR("PATIENT")=(DFN+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: PATNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"PATNFND","Expected error: PATNFND")
 S PAR("PATIENT")=DFN
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
 S PAR("ADMREG")=($P(^DIC(43.4,0),U,3))_U
 S $P(^DIC(43.4,+PAR("ADMREG"),0),U,4)=1 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: AREGNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"AREGINAC","Expected error: AREGNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[$P(^DIC(43.4,+PAR("ADMREG"),0),U,1),1,"Expected error: INVPARM")
 S $P(^DIC(43.4,+PAR("ADMREG"),0),U,4)=0
 S PAR("ADMREG")=(($P(^DIC(43.4,0),U,3))-$G(UPD))_U
 Q
UPDADM ;
 K PAR,RE
 ;no update
 S PM0=^DGPM(+AFN,0)
 S RTN="S %=$$UPDADM^DGPMAPI1(.RE,.PAR,+AFN)" X RTN
 D CHKEQ^XTMUNIT(RE,1,"Expected error: "_$G(RE(0)))
 ;admission not found
 S %=$$UPDADM^DGPMAPI1(.RE,.PAR,+AFN+100)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMNFND","Expected error: ADMNFND")
 ;Invalid admission type
 S PAR("TYPE")="1^" ;Direct admission
 D CHKTYPE^ZZDGPMAPI1(RTN,.PAR,1)
 S PAR("TYPE")="11^"
 ; invalid facility directory exclusion
 S PAR("TYPE")=2,PAR("FDEXC")=2 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 ;Invalid admitting regulation
 S PAR("FDEXC")="0^"
 D CHKAREG^ZZDGPMAPI1(RTN,.PAR,1)
 ;Invalid short diag
 D CHKDIAG^ZZDGPMAPI1(RTN,.PAR,"Update diagnosis")
 ;Invalid ward
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-2)_U
 D CHKWARD^ZZDGPMAPI1(RTN,.PAR,+WARD2,1)
 ;Invalid room-bed
 D CHKBED^ZZDGPMAPI1(RTN,.PAR,+BED2,1,3,WARD1)
 ;Invalid facility treating specialty
 D CHKFTS^ZZDGPMAPI1(RTN,.PAR,1)
 ;Invalid attender
 D CHKATD^ZZDGPMAPI1(RTN,.PAR,1)
 ;Invalid primary physician
 D CHKPRYM^ZZDGPMAPI1(RTN,.PAR)
 ;Invalid source of admission
 D CHKASRC^ZZDGPMAPI1(RTN,.PAR,1)
 X RTN
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U),+PAR("DATE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,4),+PAR("TYPE"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,6),+PAR("WARD"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,7),+PAR("ROOMBED"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,10),PAR("SHDIAG"),"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(^DGPM(+AFN,0),U,12),+PAR("ADMREG"),"Unexpected error: "_$G(RE(0)))
 ;Invalid date
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
XTENT ;
 ;;ADMIT;Admit patient.
 ;;UPDADM;Update admission.
 ;;DELADM;Delete admission.
