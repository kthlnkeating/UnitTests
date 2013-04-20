ZZDGPMSE ;Unit Tests - Clinic API; 4/19/13
 ;;1.0;UNIT TEST;;05/28/2012;
ADDCLN(NAME) ; Add new clinic
 N IEN
 S IEN=$P(^SC(0),U,3)+1
 S STOP=$O(^DIC(40.7,0))
 S ^SC("B",NAME,IEN)=""
 S $P(^SC(0),U,3)=$P(^SC(0),U,3)+1
 S ^SC(IEN,0)=NAME_"^^C^^^^"_STOP
 S $P(^SC(IEN,0),U,18)=$O(^DIC(40.7,STOP))
 S $P(^SC(IEN,0),U,17)="Y"
 S ^SC(IEN,"SL")="30^V^^^^4^1^Y"
 S ^SC(IEN,"AT")="9"
 S ^SC(IEN,"SDPRIV",0)="^44.04PA^1^1"
 S ^SC(IEN,"SDP")="5^2^3^"
 Q IEN_U_NAME
 ;
ADDPATT(SC) ;
 S DD=9999999
 F I=0:1:6 S ^SC(SC,"T"_I,DD,0)=DD,^SC(SC,"T"_I,DD,1)="[1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1]"
 Q
ADDPAT(NAME,I) ; Add new patient
 N IEN
 S IEN=$P(^DPT(0),U,3)+I
 S ^DPT("B",NAME_I,IEN)=""
 S ^DPT(IEN,0)=NAME_I_"^M^2800621^^^^^^221133445^^^^^^1^3120628^^^^1"
 Q IEN_U_NAME_I
 ;
SETUP(PNM,CNM) ;
 S ^DVB(395,1,0)="1^1^^^n"
 S ^DVB(395,1,"HQ")="^^^^^^^^^^0^^1"
 S ^DG(43,1,"GL")="^0^2^0"
 S ^DIC(213.9,1,0)="1^1"
 S ^DIC(213.9,1,"OFF")=1
 S $P(^ORD(101,1380,0),"^",3)=""
 S:$D(PNM) PNAME=PNM
 S:$D(CNM) CNAME=CNM
 S:'$D(PNM) PNAME="TEST,PATIENT"
 S:'$D(CNM) CNAME="Test Clinic"
 S SC=$$ADDCLN(CNAME)
 S DFN=$$ADDPAT(PNAME,1)
 D ADDPATT(+SC)
 S SD=DT_".08",SD=SD_U_$$FMTE^XLFDT(SD)
 S RSN="Test Reason",LEN="30^30",TYPE="9^REGULAR",NXT="N"
 S CRSN="11^OTHER"
 D ADDWARDS
 Q
ADDWARDS(NAME,TYPE,NAME1,TYPE1)
 N WARD,PARA S PARA(.01)=$S($D(NAME):NAME,1:"Ward NHC 1")
 S PARA(.03)=$S($D(TYPE):TYPE,1:"NH"),PARA(44)=+SC,PARA(.017)=1
 D ADDWARD^ZZDGPMSE(.WARD,.PARA) S WARD1=WARD_U
 K PARA S PARA(400)=1.5 D UPDWARD^ZZDGPMSE(,.PARA,+WARD1)
 K WARD,PARA S PARA(.01)=$S($D(NAME1):NAME1,1:"Ward NHC 2")
 S PARA(.03)=$S($D(TYPE1):TYPE1,1:"NH"),PARA(44)=+SC,PARA(.017)=2
 D ADDWARD^ZZDGPMSE(.WARD,.PARA) S WARD2=+WARD_U
 K PARA S PARA(400)=1.6 D UPDWARD^ZZDGPMSE(,.PARA,+WARD2)
 K BED,PARA S PARA(.01)="R101-BED-1"
 D ADDBED^ZZDGPMSE(.BED,.PARA) S BED1=+BED_U
 K BED,PARA S PARA(.01)="R102-BED-2"
 D ADDBED^ZZDGPMSE(.BED,.PARA) S BED2=+BED_U
 Q
 ;
SETENR(DFN,SC) ; Set patient enrolls
 S ^DPT(+DFN,"DE","B",+SC,1)=""
 S ^DPT(+DFN,"DE",1,0)=+SC_"^"
 S ^DPT(+DFN,"DE",1,1,1,0)=DT_"^O^^^"
 Q
 ;
ADDWARD(RETURN,PARAMS) ; Add new ward
 D ADDNEW(.RETURN,42,.PARAMS)
 Q
 ;
ADDBED(RETURN,PARAMS) ; Add new bed
 D ADDNEW(.RETURN,405.4,.PARAMS)
 Q
ADDNEW(RETURN,FILE,PARAMS) ; Add entry to file
 N FLD,IENS,FDA
 S IENS="+1,"
 S FLD=0
 F  S FLD=$O(PARAMS(FLD)) Q:'FLD  D
 . S FDA(FILE,IENS,FLD)=PARAMS(FLD)
 D UPDATE^DIE("","FDA","IENS","RETURN")
 S RETURN=IENS(1)
 Q
 ;
ADDNEWS(RETURN,SFILE,IEN,PARAMS) ; Add entry to subfile
 N FLD,IENS,FDA
 S IENS="+1,"_IEN_","
 S FLD=0
 F  S FLD=$O(PARAMS(FLD)) Q:'FLD  D
 . S FDA(SFILE,IENS,FLD)=PARAMS(FLD)
 D UPDATE^DIE("","FDA","IENS","RETURN")
 S RETURN=IENS(1)
 Q
 ;
ADDWOOS(RETURN,WARD,PARAMS) ; Add ward out of service date
 D ADDNEWS(.RETURN,42.08,WARD,.PARAMS)
 Q
 ;
ADDFOOS(RETURN,FTS,PARAMS) ; Add FTS out of service date
 D ADDNEWS(.RETURN,45.702,+FTS,.PARAMS)
 Q
 ;
ADDBOOS(RETURN,BED,PARAMS) ; Add bed out of service date
 D ADDNEWS(.RETURN,405.42,BED,.PARAMS)
 Q
 ;
ADDBASW(RETURN,BED,PARAMS) ; Add ward which can assign
 D ADDNEWS(.RETURN,405.41,BED,.PARAMS)
 Q
 ;
UPDWARD(RETURN,PARAMS,IFN) ; Update ward
 D UPD(.RETURN,42,IFN,.PARAMS)
 Q
UPD(RETURN,FILE,IFN,PARAMS) ; Update ward
 N FLD,IENS,FDA
 S IENS=IFN_","
 S FLD=0
 F  S FLD=$O(PARAMS(FLD)) Q:'FLD  D
 . S FDA(FILE,IENS,FLD)=PARAMS(FLD)
 D FILE^DIE("","FDA","RETURN")
 S RETURN=IFN
 Q
 ;
CHKPAT(RTN,PAR,PNAME) ;
 ;Invalid patient param
 N PN X RTN
 S PN=$S('$D(PNAME):"PARAM('PATIENT')",1:PNAME)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARM")
 D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM PATIENT")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[PN,1,"Expected error: INVPARM PATIENT")
 ;patient not found
 S:'$D(PNAME) PN="PAR(""PATIENT"")"
 S @PN=(DFN+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: PATNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"PATNFND","Expected error: PATNFND")
 S @PN=DFN
 Q
CHKTYPE(RTN,PAR,UPD) ;
 ;Invalid movement type
 N TMP
 S TMP=PAR("TYPE") K PAR("TYPE")
 I +$G(UPD)=0 D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM TYPE")
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('TYPE')",1,"Expected error: INVPARM TYPE")
 ;movement type not found
 S PAR("TYPE")=($P(^DG(405.1,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: MVTTNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"MVTTNFND","Expected error: MVTTNFND")
 ;invalid movement type
 S PAR("TYPE")=PAR("INVTYPE") X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: MVTTINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"ADMINVAT","Expected error: ADMINVAT")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[$P(^DG(405.1,+PAR("TYPE"),0),U,1),1,"Expected error: ADMINVAT")
 ;inactive movement type
 S PAR("TYPE")=TMP
 S $P(^DG(405.1,+PAR("TYPE"),0),U,4)=0 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: MVTTINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"MVTTINAC","Expected error: MVTTINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U,2)[$P(^DG(405.1,+PAR("TYPE"),0),U,1),1,"Expected error: MVTTINAC")
 S $P(^DG(405.1,+PAR("TYPE"),0),U,4)=1
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
 I '$G(REQ),+$G(UPD)=0 D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM FTSPEC")
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('ATNDPHY')",1,"Expected error: INVPARM FTSPEC")
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
CHKFTS(RTN,PAR,UPD,REQ,DATE) ;
 ;Invalid facility treating specialty
 I '$G(REQ),+$G(UPD)=0 D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
 . D CHKEQ^XTMUNIT($P(RE(0),U),"INVPARM","Expected error: INVPARM FTSPEC")
 . D CHKEQ^XTMUNIT($P(RE(0),U,2)["PARAM('FTSPEC')",1,"Expected error: INVPARM FTSPEC")
 ;facility treating specialty not found
 S PAR("FTSPEC")=($P(^DIC(45.7,0),U,3)+1)_U X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: FTSNFND")
 D CHKEQ^XTMUNIT($P(RE(0),U),"FTSNFND","Expected error: FTSNFND")
 ;inactive fts
 S FTS=$P(^DIC(45.7,0),U,3)-($G(UPD)+1),PAR("FTSPEC")=FTS_U_$P(^DIC(45.7,FTS,0),U)
 K PARA S PARA(.01)=$P(+$S($D(DATE):DATE,1:$G(PAR("DATE"))),"."),PARA(.02)=0 D ADDFOOS^ZZDGPMSE(,PAR("FTSPEC"),.PARA) X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: FTSINAC")
 D CHKEQ^XTMUNIT($P(RE(0),U),"FTSINAC","Expected error: FTSINAC")
 K ^DIC(45.7,+FTS,"E")
 S PAR("FTSPEC")=(FTS-$G(UPD))_U
 Q
CHKBED(RTN,PAR,BED,UPD,PP,WARD,TRA,DATE,DGPMT) ;
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
 K PARA S PARA(.01)=+WARD D ADDBASW^ZZDGPMSE(,+BED,.PARA)
 K PARA S PARA(.01)=$P(+$S($D(DATE):DATE,1:$G(PAR("DATE"))),".") D ADDBOOS^ZZDGPMSE(,+BED,.PARA) X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: BEDINACT")
 D CHKEQ^XTMUNIT($P(RE(0),U),"BEDINACT","Expected error: BEDINACT")
 K ^DG(405.4,+BED,"I")
 ;Occupied bed
 S DFN1=$$ADDPAT^ZZDGPMSE("TEST1,PATIENT",PP)
 S ADM("PATIENT")=DFN1,ADM("TYPE")=1,ADM("ADMREG")=1,ADM("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),-4,-DGPMT)_U
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
 I +$G(UPD)=0 D
 . X RTN
 . D CHKEQ^XTMUNIT(RE,$S(+$G(UPD)=1:1,1:0),"Expected error: INVPARM")
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
CHKDIAG(RTN,PAR,DIAG,FLD) ;
 ;Invalid short diagnosis
 S:'$D(FLD) FLD="SHDIAG"
 S PAR(FLD)="Di" X RTN K PAR(FLD)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: SHDGINV")
 D CHKEQ^XTMUNIT($P(RE(0),U),"SHDGINV","Expected error: SHDGINV")
 ;too long
 F I=1:1:31 S PAR(FLD)=$G(PAR(FLD))_"D"
 X RTN
 D CHKEQ^XTMUNIT(RE,0,"Expected error: SHDGINV")
 D CHKEQ^XTMUNIT($P(RE(0),U),"SHDGINV","Expected error: SHDGINV")
 S PAR("SHDIAG")=DIAG
 Q
