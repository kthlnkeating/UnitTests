ZZDGPMAPI7 ;Unit Tests - Clinic API; 4/18/13
 ;;1.0;UNIT TEST;;05/28/2012;
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZDGPMAPI7")
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
LSTPROV ;
 S RTN="S %=$$LSTPROV^DGPMAPI7(.RE,,,,DGDT)"
 D VALDT^ZZDGPMUTL(RTN,"DGDT")
 ; 
 S %=$$LSTPROV^DGPMAPI7(.RE,$P(^VA(200,+DUZ,0),U),,,$$NOW^XLFDT())
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),+DUZ,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^VA(200,+DUZ,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(RE(1,"INITIAL"),$P(^VA(200,+DUZ,0),U,2),"Incorrect initial")
 D CHKEQ^XTMUNIT(RE(1,"TITLE"),$P(^VA(200,+DUZ,0),U,9),"Incorrect title")
 Q
LSTADREG ;
 S IFN=$P(^DIC(43.4,0),U,3),NAME=$P(^DIC(43.4,IFN,0),U)
 S %=$$LSTADREG^DGPMAPI7(.RE,NAME,,)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),IFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DIC(43.4,IFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(RE(1,"CFR"),$P(^DIC(43.4,IFN,0),U,3),"Incorrect CFR")
 Q
LSTFTS ;
 N RE,DGDT
 S %=$$LSTFTS^DGPMAPI7(.RE,,,,)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 S RTN="S %=$$LSTFTS^DGPMAPI7(.RE,,,,DGDT)"
 D VALDT^ZZDGPMUTL(RTN,"DGDT")
 S IFN=$P(^DIC(45.7,0),U,3),NAME=$P(^DIC(45.7,IFN,0),U)
 S %=$$LSTFTS^DGPMAPI7(.RE,NAME,,,$$NOW^XLFDT()) ; Return facility treating specialties
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),IFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DIC(45.7,IFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(RE(1,"SPEC"),$P(^DIC(42.4,$P(^DIC(45.7,IFN,0),U,2),0),U),"Incorrect specialty")
 Q
LSTADSRC ;
 S IFN=$P(^DIC(45.1,0),U,3),NAME=$P(^DIC(45.1,IFN,0),U)
 S %=$$LSTADSRC^DGPMAPI7(.RE,NAME,,)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),IFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DIC(45.1,IFN,0),U,2),"Incorrect name")
 D CHKEQ^XTMUNIT(RE(1,"CODE"),$P(^DIC(45.1,IFN,0),U),"Incorrect code")
 Q
LSTFCTY ;
 S IFN=$P(^DIC(4,0),U,3),NAME=$P(^DIC(4,IFN,0),U)
 S %=$$LSTFCTY^DGPMAPI7(.RE,NAME,,)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),IFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DIC(4,IFN,0),U),"Incorrect name")
 Q
LSTWARD ;
 S IFN=$P(^DIC(42,0),U,3),NAME=$P(^DIC(42,IFN,0),U)
 S %=$$LSTWARD^DGPMAPI7(.RE,NAME,,)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),IFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DIC(42,IFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT($P(RE(1,"SERV"),U),$P(^DIC(42,IFN,0),U,3),"Incorrect service")
 D CHKEQ^XTMUNIT(RE(1,"SPEC"),$P(^DIC(42,IFN,0),U,12)_U_$P(^DIC(42.4,$P(^DIC(42,IFN,0),U,12),0),U),"Incorrect spec")
 Q
LSTWBED ;
 S IFN=$P(^DIC(42,0),U,3),NAME=$P(^DIC(42,IFN,0),U)
 S %=$$LSTWBED^DGPMAPI7(.RE,,,,WARD1)
 D CHKEQ^XTMUNIT(+RE(0),0,"Unexpected error: "_$G(RE(0)))
 K PARA S PARA(.01)=+WARD1 D ADDBASW^ZZDGPMSE(,+BED1,.PARA)
 S %=$$LSTWBED^DGPMAPI7(.RE,,,,WARD1)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),+BED1,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DG(405.4,+BED1,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(RE(1,"DESC"),$P(^DG(405.4,+BED1,0),U,2),"Incorrect desc")
 Q
LSTPATS ;
 S IFN=+DFN,NAME=$P(^DPT(+DFN,0),U)
 S %=$$LSTPATS^DGPMAPI7(.RE,NAME,,)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),+IFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DPT(IFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(RE(1,"SSN"),$P(^DPT(IFN,0),U,9),"Incorrect desc")
 D:$D(^DPT(IFN,"TYPE")) CHKEQ^XTMUNIT(RE(1,"TYPE"),$P($G(^DG(391,$P($G(^DPT(IFN,"TYPE")),U),0)),U),"Incorrect desc")
 D CHKEQ^XTMUNIT($E(RE(1,"VETERAN"),1),$P($G(^DPT(IFN,"VET")),U),"Incorrect desc")
 Q
LSTTPATS ;
 S %=$$LSTTPATS^DGPMAPI7(.RE,NAME,,) S DATE1=$$FMADD^XLFDT($$NOW^XLFDT(),-3)_U
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 S ADM("PATIENT")=+DFN,ADM("TYPE")=1,ADM("ADMREG")=1,ADM("DATE")=DATE1
 S ADM("FDEXC")=1,ADM("SHDIAG")="Transfer Admit diagnosis",ADM("WARD")=WARD1,ADM("FTSPEC")="1^"
 S ADM("ATNDPHY")=DUZ,ADM("ROOMBED")=BED1 M PAR=ADM
 S %=$$ADMIT^DGPMAPI1(.RT,.ADM) S AFN=+RT
 S %=$$LSTTPATS^DGPMAPI7(.RE,.NAME,,) S IFN=+DFN
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(RE(1,"ID"),+IFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(RE(1,"NAME"),$P(^DPT(IFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(RE(1,"SSN"),$P(^DPT(IFN,0),U,9),"Incorrect desc")
 D CHKEQ^XTMUNIT(RE(1,"TYPE"),"","Incorrect desc")
 D CHKEQ^XTMUNIT($E(RE(1,"VETERAN"),1),"","Incorrect desc")
 Q
LSTPADMS ;
 S %=$$LSTPADMS^DGPMAPI7(.RE,DFN) S IFN=+DFN
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+RE(1,"ROOMBED"),+BED1,"Incorrect bed")
 D CHKEQ^XTMUNIT(+RE(1,"DATE"),+DATE1,"Incorrect date")
 D CHKEQ^XTMUNIT(+RE(1,"ID"),+AFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(+RE(1,"MASTYPE"),+15,"Incorrect mastype")
 D CHKEQ^XTMUNIT(+RE(1,"PATIENT"),+DFN,"Incorrect patient")
 D CHKEQ^XTMUNIT(+RE(1,"TYPE"),1,"Incorrect type")
 D CHKEQ^XTMUNIT(+RE(1,"WARD"),+WARD1,"Incorrect ward")
 Q
LSTPTRAN ;
 S PAR("ADMIFN")=AFN,PAR("DATE")=$$FMADD^XLFDT(PAR("DATE"),1),PAR("TYPE")=11
 S %=$$TRANSF^DGPMAPI2(.RE,.PAR) S TFN=+RE
 ;invalid admission
 S %=$$LSTPTRAN^DGPMAPI7(.RE,DFN) S IFN=+DFN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: ADMNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMNFND","Expected error: ADMNFND")
 ;invalid patient
 S %=$$LSTPTRAN^DGPMAPI7(.RE,,AFN) S IFN=+DFN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM")
 ;
 S %=$$LSTPTRAN^DGPMAPI7(.RE,DFN,AFN) S IFN=+DFN
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+RE(1,"ROOMBED"),+BED1,"Incorrect bed")
 D CHKEQ^XTMUNIT(+RE(1,"DATE"),+PAR("DATE"),"Incorrect date")
 D CHKEQ^XTMUNIT(+RE(1,"ID"),+TFN,"Incorrect IFN")
 D CHKEQ^XTMUNIT(+RE(1,"MASTYPE"),+4,"Incorrect mastype")
 D CHKEQ^XTMUNIT(+RE(1,"PATIENT"),+DFN,"Incorrect patient")
 D CHKEQ^XTMUNIT(+RE(1,"TYPE"),PAR("TYPE"),"Incorrect type")
 D CHKEQ^XTMUNIT(+RE(1,"WARD"),+WARD1,"Incorrect ward")
 Q
GETPAT ;
 S PAR("ADMIFN")=AFN,PAR("DATE")=$$FMADD^XLFDT(PAR("DATE"),2),PAR("TYPE")=24
 S %=$$DISCH^DGPMAPI3(.RE,.PAR) S DMFN=+RE,DMDATE=PAR("DATE")
 S %=$$GETPAT^DGPMAPI8(.RE,DFN)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT($P(RE("NAME"),U),$P(^DPT(+DFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(+RE("DOB"),$P(^DPT(+DFN,0),U,3),"Incorrect desc")
 Q
GETMVT ;
 S %=$$GETMVT^DGPMAPI8(.RE,DMFN)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+RE("TTYPE"),3,"Incorrect ttype")
 D CHKEQ^XTMUNIT(+RE("PATIENT"),+DFN,"Incorrect patient")
 D CHKEQ^XTMUNIT(+RE("MASTYPE"),16,"Incorrect mastype")
 D CHKEQ^XTMUNIT(+RE("TYPE"),24,"Incorrect type")
 D CHKEQ^XTMUNIT(+RE("TTYPE"),3,"Incorrect ttype")
 D CHKEQ^XTMUNIT(+RE("DATE"),DMDATE,"Incorrect ttype") 
 Q
GETMVTT ;
 S RTN="S %=$$GETMVTT^DGPMAPI8(.RE,IFN)"
 D CHKMFN^ZZDGPMAPI8("IFN","MVTTNFND")
 S IFN=$P(^DG(405.1,0),U,3),NAME=$P(^DG(405.1,IFN,0),U)
 S %=$$GETMVTT^DGPMAPI8(.RE,IFN)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 D CHKEQ^XTMUNIT(+RE("MAS"),$P(^DG(405.1,IFN,0),U,3),"Incorrect mastype")
 D CHKEQ^XTMUNIT($P(RE("NAME"),U),$P(^DG(405.1,IFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT(+RE("STAT"),$P(^DG(405.1,IFN,0),U,4),"Incorrect status")
 D CHKEQ^XTMUNIT(+RE("TTYPE"),$P(^DG(405.1,IFN,0),U,2),"Incorrect ttype")
 D CHKEQ^XTMUNIT(+RE("ASKSPEC"),+$P(^DG(405.1,IFN,0),U,5),"Incorrect askspec")
 Q
GETMASMT ;
 S RTN="S %=$$GETMASMT^DGPMAPI8(.RE,IFN)"
 D CHKMFN^ZZDGPMAPI8("IFN","MVTTNFND")
 S IFN=$P(^DG(405.2,0),U,3),NAME=$P(^DG(405.2,IFN,0),U)
 S %=$$GETMASMT^DGPMAPI8(.RE,IFN)
 D CHKEQ^XTMUNIT(+RE("ABS"),$P(^DG(405.2,IFN,"E"),U),"Incorrect abs")
 D CHKEQ^XTMUNIT($P(RE("NAME"),U),$P(^DG(405.2,IFN,0),U),"Incorrect name")
 D CHKEQ^XTMUNIT($P(RE("TTYPE"),U),$P(^DG(405.2,IFN,0),U,2),"Incorrect ttype")
 D CHKEQ^XTMUNIT($P(RE("ASIH"),U),$P(^DG(405.2,IFN,"E"),U,3),"Incorrect asih")
 D CHKEQ^XTMUNIT(+RE("ASKFTY"),$P(^DG(405.2,IFN,0),U,6),"Incorrect askfty")
 D CHKEQ^XTMUNIT(+RE("ASKSPEC"),$P(^DG(405.2,IFN,0),U,5),"Incorrect askspec")
 D CHKEQ^XTMUNIT(+RE("CFADM"),+$P(^DG(405.2,IFN,"E"),U,2),"Incorrect cfadm")
 ;
 S %=$$ISDOM^DGPMAPI8(.RE,DFN,$$NOW^XLFDT()_U)
 D CHKEQ^XTMUNIT(RE,"","Unexpected error: "_$G(RE(0)))
 Q
XTENT ;
 ;;LSTPROV;List providers
 ;;LSTADREG;List admitting regulations
 ;;LSTFTS;List facility treating specialties
 ;;LSTADSRC;List source of admissions
 ;;LSTFCTY;List transfer facilities
 ;;LSTWARD;List wards
 ;;LSTWBED;List beds
 ;;LSTPATS;List patients
 ;;LSTTPATS;List transferable patients
 ;;LSTPADMS;List patient admissions
 ;;LSTPTRAN;List patient transfers
 ;;GETPAT;;Get patient
 ;;GETMVT;;Get movement
 ;;GETMVTT;;Get movement type
 ;;GETMASMT;;Get mas movement type
