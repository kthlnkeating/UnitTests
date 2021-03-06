ZZDGPMUTL ;Unit Tests - Utils; 6/19/13
 ;;1.0;UNIT TEST;;05/28/2012;
CHKDT(RTN,PAR,UPD)
 ;Invalid date
 I '$G(UPD) D
 . X RTN
 . D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Null date")
 . D CHKEQ^XTMUNIT(RE(0)["PARAM(""DATE"")",1,"Invalid date parameter")
 ; Invalid date 3133029.08
 S PAR("DATE")=3133029.08_U X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Wrong date")
 D CHKEQ^XTMUNIT(RE(0)["PARAM(""DATE"")",1,"Invalid date parameter")
 ; Invalid date 3133029
 S PAR("DATE")=$$DT^XLFDT()_U X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Date/time expected")
 D CHKEQ^XTMUNIT(RE(0)["PARAM(""DATE"")",1,"Invalid date parameter")
 ; Invalid date future
 S PAR("DATE")=$$FMADD^XLFDT($$NOW^XLFDT(),1)_U X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Not in future")
 D CHKEQ^XTMUNIT(RE(0)["PARAM(""DATE"")",1,"Invalid date parameter")
 Q
VALDT(RTN,PAR,REQ) ; Valid date?
 I $G(REQ) D
 . X RTN
 . D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Null date")
 . D CHKEQ^XTMUNIT(RE(0)[PAR,1,"Invalid "_PAR_" parameter")
 ; Invalid date 3133029.08
 S @PAR=3133029.08_U X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Wrong date")
 D CHKEQ^XTMUNIT(RE(0)[PAR,1,"Invalid date parameter")
 ; Invalid date "FOO"
 S @PAR="FOO" X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Wrong date")
 D CHKEQ^XTMUNIT(RE(0)[PAR,1,"Invalid date parameter")
 ; Invalid date 31301011
 S @PAR=31301011 X RTN
 D CHKEQ^XTMUNIT(RE_U_$P($G(RE(0)),U),"0^INVPARM","Not in future")
 D CHKEQ^XTMUNIT(RE(0)[PAR,1,"Invalid date parameter")
 Q 
