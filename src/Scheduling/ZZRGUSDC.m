ZZRGUSDC ;Unit Tests - Clinic API; 05/28/2012  11:46 AM
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
 S ^SC(IEN,"SL")="30^^^^^4^1^Y"
 S ^SC(IEN,"AT")="9"
 S ^SC(IEN,"SDPRIV",0)="^44.04PA^1^1"
 S ^SC(IEN,"SDP")="5^2^3^"
 Q IEN
 ;
ADDPATT(SC) ;
 S DD=9999999
 F I=0:1:6 S ^SC(SC,"T"_I,DD,0)=DD,^SC(SC,"T"_I,DD,1)="[1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1]"
 Q
ADDPAT(NAME) ; Add new patient
 N IEN
 S IEN=$P(^DPT(0),U,3)+1
 S ^DPT("B",NAME,IEN)=""
 S ^DPT(IEN,0)=NAME_"^M^2800621^^^^^^221133445^^^^^^1^3120628^^^^1"
 Q IEN
 ;
SETUP(PNM,CNM) ;
 S:$D(PNM) PNAME=PNM
 S:$D(CNM) CNAME=CNM
 S:'$D(PNM) PNAME="Test,Patient"
 S:'$D(CNM) CNAME="Test Clinic"
 S SC=$$ADDCLN(CNAME)
 S DFN=$$ADDPAT(PNAME)
 D ADDPATT(SC)
 S SD=DT_".08"
 S RSN="Test Reason",LEN=30,TYPE=9,NXT="N"
 Q
 ;
SETENR(DFN,SC) ; Set patient enrolls
 S ^DPT(DFN,"DE","B",SC,1)=""
 S ^DPT(DFN,"DE",1,0)=SC_"^"
 S ^DPT(DFN,"DE",1,1,1,0)=DT_"^O^^^"
 Q
 ;
