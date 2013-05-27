ZZDGPMAPI6 ;Unit Tests - Check-in API; 5/27/13
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGPMAPI6")
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
ADM(ADM,DATE) ;
 S ADM("PATIENT")=+DFN,ADM("TYPE")=1,ADM("ADMREG")=1,ADM("DATE")=DATE
 S ADM("FDEXC")=1,ADM("SHDIAG")="Admit diagnosis",ADM("WARD")=WARD1,ADM("FTSPEC")="1^"
 S ADM("ATNDPHY")=DUZ_U,ADM("ROOMBED")=BED1_U,ADM("ADMSCC")="1^",ADM("ADMSRC")="1D^"
 S PARA(.01)=+WARD1 D ADDBASW^ZZDGPMSE(,+BED1,.PARA)
 S %=$$ADMIT^DGPMAPI1(.RT,.ADM)
 Q RT
DISCH(AIFN,DATE) ;
 S DCH("ADMIFN")=AIFN,DCH("TYPE")=24,DCH("DATE")=DATE
 S %=$$DISCH^DGPMAPI3(.RR,.DCH)
 Q RR
TRA(AFN,DATE)
 S PAR("ADMIFN")=AFN,PAR("ATNDPHY")=DUZ,PAR("DATE")=DATE,PAR("FTSPEC")="2^"
 S PAR("PATIENT")=DFN,PAR("PRYMPHY")=DUZ,PAR("ROOMBED")=BED2,PAR("TYPE")="11^",PAR("WARD")=WARD1
 S PARA(.01)=+WARD1 D ADDBASW^ZZDGPMSE(,+BED2,.PARA)
 S %=$$TRANSF^DGPMAPI2(.RT,.PAR)
 Q RT
FTS ; TS transfer
 N PAR,PA,DGQUIET,R
 S ADMDT=$$FMADD^XLFDT($$NOW^XLFDT(),,-3)
 S AFN=$$ADM(.ADM,ADMDT) K PAR,PA
 S RTN="S %=$$FTS^DGPMAPI6(.RE,.PA)"
 ; Check date
 D CHKDT^ZZDGPMUTL(RTN,.PA)
 ; Invalid admission IFN
 S PA("DATE")=$$FMADD^XLFDT(ADMDT,,-2),%=$$FTS^DGPMAPI6(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT($G(R(0))["PARAM('ADMIFN')",1,"Invalid admission parameter")
 ;not before admission
 S PA("ADMIFN")=AFN_U,PA("DATE")=$$FMADD^XLFDT(ADMDT,-4) X RTN
 D CHKEQ^XTMUNIT($P($G(RE(0)),U),"TRANBADM","Expected error: TRANBADM")
 ;not after discharge
 D DISCH(AFN,$$FMADD^XLFDT(ADMDT,,2))
 S PA("DATE")=$$FMADD^XLFDT(ADMDT,,3) X RTN
 D CHKEQ^XTMUNIT($P($G(RE(0)),U),"TRANADIS","Expected error: TRANADIS")
 ;time used
 S PA("DATE")=ADMDT X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^TIMEUSD","Expected error: TIMEUSD")
 ; Invalid facility treating specialty
 S PA("DATE")=$$FMADD^XLFDT(ADMDT,,1.5)
 D CHKFTS^ZZDGPMSE(RTN,.PA)
 ; Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PA)
 ; Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PA)
 ; Ok
 S %=$$FTS^DGPMAPI6(.R,.PA),TSFN=R
 S CI0=+PA("DATE")_"^6^"_+PA("PATIENT")_"^42^^"
 S CI0=CI0_"^^"_+PA("PRYMPHY")_"^"_+PA("FTSPEC")_"^^^^^"_+AFN_"^^^^20^"_+PA("ATNDPHY")_"^^^0"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+R,0),"Incorrect movement")
 Q
PROVCHG ; Provider change
 N PA,DGQUIET,RE,R
 S RTN="S %=$$PROVCH^DGPMAPI6(.RE,.PA)"
 ; Check date
 D CHKDT^ZZDGPMUTL(RTN,.PA)
 ; Invalid admission IFN
 S PA("DATE")=$$FMADD^XLFDT(ADMDT,,1.3),%=$$PROVCH^DGPMAPI6(.R,.PA)
 D CHKEQ^XTMUNIT(R_U_$P($G(R(0)),U),"0^INVPARM","Expected error: INVPARM")
 D CHKEQ^XTMUNIT($G(R(0))["PARAM('ADMIFN')",1,"Invalid admission parameter")
 S PA("ADMIFN")=AFN_U
 ; Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PA)
 ; Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PA)
 ; Ok
 S %=$$PROVCH^DGPMAPI6(.R,.PA),PCFN=R
 S CI0=+PA("DATE")_"^6^"_+PA("PATIENT")_"^42^^"
 S CI0=CI0_"^^"_+PA("PRYMPHY")_"^"_+PA("FTSPEC")_"^^^^^"_+AFN_"^^^^20^"_+PA("ATNDPHY")_"^^^0"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+R,0),"Incorrect movement")
 Q
UPDFTSE ; Update TS transfer
 S RTN="S %=$$UPDFTS^DGPMAPI6(.RE,.PA,TSFN)"
 S TFN=TSFN,ADGDT=$$FMADD^XLFDT(ADMDT,,1.41) K PC
 G UPD
UPDPC ; Update provider change
 S RTN="S %=$$UPDPC^DGPMAPI6(.RE,.PA,TSFN)"
 S TFN=PCFN,PC=1,ADGDT=$$FMADD^XLFDT(ADMDT,,1.42)
 G UPD
UPD ;
 ; No update
 N PA,RE,DGQUIET
 X RTN
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(R(0)))
 ; Movement not found
 S TSFN=TSFN+1000 X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^MVTNFND","Expected error: MVTNFND")
 ;Check date
 S TSFN=TSFN-1000
 D CHKDT^ZZDGPMUTL(RTN,.PA,1)
 ;not before admission
 S PA("ADMIFN")=AFN_U,PA("DATE")=$$FMADD^XLFDT(ADMDT,-4) X RTN
 D CHKEQ^XTMUNIT($P($G(RE(0)),U),"TRANBADM","Expected error: TRANBADM")
 ;not after discharge
 S PA("DATE")=$$FMADD^XLFDT(ADMDT,,3) X RTN
 D CHKEQ^XTMUNIT($P($G(RE(0)),U),"TRANADIS","Expected error: TRANADIS")
 ;time used
 S PA("DATE")=ADMDT X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^TIMEUSD","Expected error: TIMEUSD")
 S PA("DATE")=ADGDT
 ;Check facility treating specialty
 I '$G(PC) D CHKFTS^ZZDGPMSE(RTN,.PA,1) S FTSN=PA("FTSPEC")
 ; Invalid attender
 D CHKATD^ZZDGPMSE(RTN,.PA,1)
 ; Invalid primary physician
 D CHKPRYM^ZZDGPMSE(RTN,.PA)
 ; Ok
 S %=$$GETADM^DGPMAPI8(.ADMTT,AFN)
 X RTN
 S CI0=+ADGDT_"^6^"_+PA("PATIENT")_"^42^^^^"_+PA("PRYMPHY")_"^"
 S CI0=CI0_+$S($G(PC):+$G(FTSN),1:+PA("FTSPEC"))_"^^^^^"_+AFN_"^^^^20^"_+PA("ATNDPHY")_"^^^0"
 D CHKEQ^XTMUNIT(CI0,^DGPM(+TSFN,0),"Incorrect movement")
 Q
DELFTS ; Delete TS transfer
 N RE,DGQUIET
 ; Not found
 S %=$$DELFTS^DGPMAPI6(.RE,TSFN+100)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^RPMNFND","Expected error: RPMNFND")
 ; Delete
 S %=$$DELFTS^DGPMAPI6(.RE,TSFN+100)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^RPMNFND","Expected error: RPMNFND")
 ; Delete
 S RPHY=$$GETRPHY^DGPMDAL1(AFN)
 S %=$$DELFTS^DGPMAPI6(.RE,RPHY)
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^CANDRPM","Expected error: CANDRPM")
 Q
XTENT ;
 ;;FTS;TS transfer
 ;;PROVCHG;Provider change
 ;;UPDFTSE;Update TS
 ;;UPDPC;Update provider change
 ;;DELFTS;TS delete
