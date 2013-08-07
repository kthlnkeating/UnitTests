ZZSDAV ;Unit Tests - Availability API; 7/22/13
 ;;1.0;UNIT TEST;;
 Q:$T(^SDMAPI1)=""
 TSTART
 I $T(EN^XTMUNIT)'="" D EN^XTMUNIT("ZZSDAV")
 TROLLBACK
 Q
STARTUP ;
 S DTIME=500,DUZ=1,U="^"
 K XUSER,XOPT,PROT
 D LOGON^ZZRGUSDC
 S DT=$P($$HTFM^XLFDT($H),".")
 D SETUP^ZZRGUSDC()
 Q
 ;
SHUTDOWN ;
 Q
 ;
TEARDOWN ;
 Q
GETCANP ;
 N RE,%
 S %=$$GETCANP^SDAVAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SC^1","Expected error: INVPARAM")
 ;Clinic not found
 S %=$$GETCANP^SDAVAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNNFND^Clinic not found.^1","Expected error: CLNNFND")
 ;Invalid SD
 S %=$$GETCANP^SDAVAPI(.RE,SC)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SD^1","Expected error: INVPARAM")
 ;Ok
 S ^SC(+SC,"SDCAN",+SD,0)=+SD_"^"_"1000"
 S ^SC(+SC,"S",+SD,"MES")="CANCELLED UNTIL 1000 (restore test)"
 S %=$$GETCANP^SDAVAPI(.RE,SC,SD)
 D CHKEQ^XTMUNIT(RE(+SD,"BEGIN"),+SD,"Invalid begin")
 D CHKEQ^XTMUNIT(RE(+SD,"END"),"1000","Invalid end")
 D CHKEQ^XTMUNIT(RE(+SD,"MESS"),"restore test","Invalid message")
 Q
 ;
RESTAV ;
 N RE,%
 S %=$$RESTAV^SDAVAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SC^1","Expected error: INVPARAM")
 ;Clinic not found
 ;S %=$$SETST^SDMAPI5(.RETURN,+SC,+SD) Q:RETURN=0 0
 S %=$$RESTAV^SDAVAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNNFND^Clinic not found.^1","Expected error: CLNNFND")
 ;Invalid SD
 S %=$$RESTAV^SDAVAPI(.RE,SC2)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SD^1","Expected error: INVPARAM")
 ;Not cancelled
 S %=$$RESTAV^SDAVAPI(.RE,SC2,SD)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: RESTCNC")
 D CHKEQ^XTMUNIT($G(RE(0)),"RESTCNC^Clinic has not been cancelled for that date, so it cannot be restored^1","Expected error: RESTCNC")
 ;Not cancelled
 S %=$$SETST^SDMAPI5(.RETURN,+SC2,+SD)
 S %=$$RESTAV^SDAVAPI(.RE,SC2,SD)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: RESTCNC")
 D CHKEQ^XTMUNIT($G(RE(0)),"RESTCNC^Clinic has not been cancelled for that date, so it cannot be restored^1","Expected error: RESTCNC")
 ;Not cancelled
 S ^SC(+SC2,"SDCAN",+SD,0)=+SD_"^"_"1000" K ^SC(+SC2,"ST",$P(SD,"."))
 S ^SC(+SC2,"S",+SD,"MES")="CANCELLED UNTIL 1000 (restore test)"
 S %=$$RESTAV^SDAVAPI(.RE,SC2,SD)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: RESTCNC")
 D CHKEQ^XTMUNIT($G(RE(0)),"RESTCNC^Clinic has not been cancelled for that date, so it cannot be restored^1","Expected error: RESTCNC")
 ;Cannot be restored
 S %=$$SETST^SDMAPI5(.RETURN,+SC2,+SD)
 S ^SC(+SC2,"ST",$P(SD,"."),9)=$P(SD,".")
 S ^SC(+SC2,"OST",$P(SD,"."),1)="" ;^SC(+SC2,"ST",$P(SD,"."),1)
 S S=^SC(+SC2,"ST",$P(SD,"."),1)
 S S=$P(S,"[1 1 1 1|1 1 1 1|",1)_"[X X X X|X X X X|"_$P(S,"[1 1 1 1|1 1 1 1|",2)
 S ^SC(+SC2,"ST",$P(SD,"."),1)=S
 S %=$$RESTAV^SDAVAPI(.RE,SC2,SD)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: RESTCNC")
 D CHKEQ^XTMUNIT($G(RE(0)),"RESTCBR^This clinic date cannot be restored.^1","Expected error: RESTCNC")
 ;Invalid date/time
 S %=$$RESTAV^SDAVAPI(.RE,SC2,$P(SD,"."))
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SD^1","Expected error: INVPARAM")
 ;Ok
 K ^SC(+SC2,"ST",$P(SD,"."),9)
 S %=$$RESTAV^SDAVAPI(.RE,SC2,SD)
 D CHKEQ^XTMUNIT(RE,1,"Invalid begin")
 Q
 ;
ADDHOL ;Add holiday
 N RE,%,HOL
 ;Invalid date
 S %=$$ADDHOL^SDAVAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - HDT^1","Expected error: INVPARAM")
 ;Invalid date
 S %=$$ADDHOL^SDAVAPI(.RE,1700000)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - HDT^1","Expected error: INVPARAM")
 ;Invalid name
 S %=$$ADDHOL^SDAVAPI(.RE,SD,"AA")
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - NAME^1","Expected error: INVPARAM")
 ;Invalid name
 F I=1:1:40 S NAME=$G(NAME,"N")_"N"
 S %=$$ADDHOL^SDAVAPI(.RE,SD,NAME)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - NAME^1","Expected error: INVPARAM")
 ;Ok
 S %=$$ADDHOL^SDAVAPI(.RE,SD,"Today is Holiday")
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 S %=$$GETHOL^SDMAPI4(.HOL,SD)
 D CHKEQ^XTMUNIT(HOL($P(SD,".")),$P(SD,".")_"^Today is Holiday","Invalid holiday")
 ;Already exists
 S %=$$ADDHOL^SDAVAPI(.RE,SD,"Today is Holiday")
 D CHKEQ^XTMUNIT(RE,0,"Expected error: HOLAEXST")
 D CHKEQ^XTMUNIT($G(RE(0)),"HOLAEXST^Holiday already exists.^1","Expected error: HOLAEXST")
 Q
UPDHOL ;Update holiday
 N RE,%,HOL
 ;Invalid date
 S %=$$UPDHOL^SDAVAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - HDT^1","Expected error: INVPARAM")
 ;Invalid date
 S %=$$UPDHOL^SDAVAPI(.RE,1700000)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - HDT^1","Expected error: INVPARAM")
 ;Not found
 S %=$$UPDHOL^SDAVAPI(.RE,SD-1,"Today is Holiday")
 D CHKEQ^XTMUNIT(RE,0,"Expected error: HOLNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"HOLNFND^Holiday not found.^1","Expected error: HOLNFND")
 ;Invalid name
 S %=$$UPDHOL^SDAVAPI(.RE,SD,"AA")
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - NAME^1","Expected error: INVPARAM")
 ;Invalid name
 F I=1:1:40 S NAME=$G(NAME,"N")_"N"
 S %=$$UPDHOL^SDAVAPI(.RE,SD,NAME)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - NAME^1","Expected error: INVPARAM")
 ;Ok
 S %=$$UPDHOL^SDAVAPI(.RE,SD,"Today was Holiday")
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 S %=$$GETHOL^SDMAPI4(.HOL,SD)
 D CHKEQ^XTMUNIT(HOL($P(SD,".")),$P(SD,".")_"^Today was Holiday","Invalid holiday")
 Q
DELHOL ;Delete holiday
 N RE,%,HOL
 ;Invalid date
 S %=$$DELHOL^SDAVAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - HDT^1","Expected error: INVPARAM")
 ;Invalid date
 S %=$$DELHOL^SDAVAPI(.RE,1700000)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - HDT^1","Expected error: INVPARAM")
 ;Not found
 S %=$$DELHOL^SDAVAPI(.RE,SD-1)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: HOLNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"HOLNFND^Holiday not found.^1","Expected error: HOLNFND")
 ;Ok
 S %=$$DELHOL^SDAVAPI(.RE,SD)
 D CHKEQ^XTMUNIT(RE,1,"Unexpected error: "_$G(RE(0)))
 S %=$$GETHOL^SDMAPI4(.HOL,SD)
 D CHKEQ^XTMUNIT($D(HOL),1,"Invalid holiday")
 Q
REMAP ;Remap clinic
 N RE,%
 S %=$$REMAP^SDAVAPI(.RE)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SC^1","Expected error: INVPARAM")
 ;Clinic not found
 S %=$$REMAP^SDAVAPI(.RE,9999)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: CLNNFND")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNNFND^Clinic not found.^1","Expected error: CLNNFND")
 ;Invalid SDBD
 S %=$$REMAP^SDAVAPI(.RE,SC1)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SDBD^1","Expected error: INVPARAM")
 ;Invalid SDBD
 S %=$$REMAP^SDAVAPI(.RE,SC1,1700000)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SDBD^1","Expected error: INVPARAM")
 ;Invalid SDED
 S SDBD=SD
 S %=$$REMAP^SDAVAPI(.RE,SC1,SDBD)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SDED^1","Expected error: INVPARAM")
 ;Invalid SDED
 S %=$$REMAP^SDAVAPI(.RE,SC1,SDBD,1700000)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: INVPARAM")
 D CHKEQ^XTMUNIT($G(RE(0)),"INVPARAM^Invalid parameter value - SDED^1","Expected error: INVPARAM")
 ;Invalid SDED
 S %=$$REMAP^SDAVAPI(.RE,SC1,SDBD,SDBD-1)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: REMEDABD")
 D CHKEQ^XTMUNIT($G(RE(0)),"REMEDABD^Ending date must not be before beginning date^1","Expected error: REMEDABD")
 ;Invalid clinic
 S SDED=$$FMADD^XLFDT(SDBD,1),SL=^SC(+SC1,"SL") K ^SC(+SC1,"SL")
 S %=$$REMAP^SDAVAPI(.RE,SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: REMEDABD")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNINV^Invalid Clinic SL node.^1","Expected error: REMEDABD")
 ;Invalid clinic division
 S ^SC(+SC1,"SL")=SL
 S %=$$REMAP^SDAVAPI(.RE,SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE,0,"Expected error: REMEDABD")
 D CHKEQ^XTMUNIT($G(RE(0)),"CLNINV^Invalid Clinic Division.^1","Expected error: REMEDABD")
 S $P(^SC(+SC1,"0"),U,15)=1
 ;
 D ADDPATT^ZZRGUSDC(+SC1) 
 S DOW1=$$DOW^XLFDT(+SD,1)
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 S TMP=^SC(+SC1,"ST",$P(SD,"."),1)
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(^SC(+SC1,"ST",$P(SD,"."),1),TMP,"Invalid clinic ST")
 ;Bogus
 S ^SC(+SC1,"ST",$P(SD,"."),1)="AA"_$E(^SC(+SC1,"ST",$P(SD,"."),1),3,999)
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE(1,"CLINIC"),SC1,"Invalid clinic A1")
 D CHKEQ^XTMUNIT(RE(1,"MSG"),"Bogus clinic day","Invalid msg A1")
 D CHKEQ^XTMUNIT(RE(1,"DATE"),$P(SD,"."),"Invalid date A1")
 ;Holiday
 D HOL
 D APT
 ;Bogus
 S ^SC(+SC1,"ST",$P(SD,"."),1)="AA"_$E(^SC(+SC1,"ST",$P(SD,"."),1),3,999)
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE(1,"CLINIC"),SC1,"Invalid clinic A1")
 D CHKEQ^XTMUNIT(RE(1,"MSG"),"Bogus clinic day- Appts!","Invalid msg A1")
 D CHKEQ^XTMUNIT(RE(1,"DATE"),$P(SD,"."),"Invalid date A1")
 Q
 ;
APT ;
 S TMP=^SC(+SC1,"T"_DOW1,9999999,1),^SC(+SC1,"T"_DOW1,9999999,1)=""
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE(1,"CLINIC"),SC1,"Invalid clinic A1")
 D CHKEQ^XTMUNIT(RE(1,"MSG"),"no master pattern for this day","Invalid msg A1")
 D CHKEQ^XTMUNIT(RE(1,"DATE"),$P(SD,"."),"Invalid date A1")
 ;
 S ^SC(+SC1,"T"_DOW1,9999999,1)=TMP
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 S $P(^SC(+SC1,"SL"),U,8)="Y",TMP=^SC(+SC1,"ST",$P(SD,"."),1)
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(^SC(+SC1,"ST",$P(SD,"."),1),TMP,"Invalid clinic ST")
 ;Cancelled all day
 S ^SC(+SC1,"ST",$P(SD,"."),"CAN")=^SC(+SC1,"ST",$P(SD,"."),1)
 S ^SC(+SC1,"ST",$P(SD,"."),1)="   "_$E($P(SD,"."),6,7)_"    **CANCELLED**"
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE(1,"CLINIC"),SC1,"Invalid clinic A1")
 D CHKEQ^XTMUNIT(RE(1,"MSG"),"Cancelled","Invalid msg A1")
 D CHKEQ^XTMUNIT(RE(1,"DATE"),$P(SD,"."),"Invalid date A1")
 ;Cancelled all day
 S ^SC(+SC1,"ST",$P(SD,"."),1)=$E(^SC(+SC1,"ST",$P(SD,"."),"CAN"),1,7)_"[XXXXXXXXXXXXXXXX"
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE(1,"CLINIC"),SC1,"Invalid clinic A1")
 D CHKEQ^XTMUNIT(RE(1,"MSG"),"Cancelled","Invalid msg A1")
 D CHKEQ^XTMUNIT(RE(1,"DATE"),$P(SD,"."),"Invalid date A1")
 S ^SC(+SC1,"ST",$P(SD,"."),1)=^SC(+SC1,"ST",$P(SD,"."),"CAN")
 ;
 S S=^SC(+SC1,"ST",$P(SD,"."),1)
 S S=$E(S,1,7)_"[0 0 1 1]XXXXXXX[1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1|1 1 1 1]"
 S ^SC(+SC1,"ST",$P(SD,"."),1)=S
 S ^SC(+SC1,"SDCAN",$P(SD,".")_".09",0)=+SD_"^1000"
 S ^SC(+SC1,"S",$P(SD,".")_".09","MES")="CANCELLED UNTIL 1000 (restore test)"
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(^SC(+SC1,"ST",$P(SD,"."),1),S,"Invalid clinic ST")
 Q
 ;
HOL ;
 S $P(^SC(+SC1,"SL"),U,8)=""
 S %=$$ADDHOL^SDAVAPI(.RE,SD,"Holiday test")
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE(1,"CLINIC"),SC1,"Invalid clinic H1")
 D CHKEQ^XTMUNIT(RE(1,"MSG"),"Holiday test- Inserted","Invalid msg H1")
 D CHKEQ^XTMUNIT(RE(1,"DATE"),$P(SD,"."),"Invalid date H1")
 ;
 K ^SC(+SC1,"ST")
 S $P(^SC(+SC1,"SL"),U,8)="Y"
 S %=$$MAKEUS^SDMAPI2(.RE,DFN,SC1,SD,9,,"CO")
 S $P(^SC(+SC1,"SL"),U,8)=""
 S %=$$REMAP^SDAVAPI(.RE,+SC1,SDBD,SDED)
 D CHKEQ^XTMUNIT(RE(1,"CLINIC"),SC1,"Invalid clinic H2")
 D CHKEQ^XTMUNIT(RE(1,"MSG"),"Holiday test- Appts!","Invalid msg H2")
 D CHKEQ^XTMUNIT(RE(1,"DATE"),$P(SD,"."),"Invalid date H2")
 D DELHOL^SDAVAPI(,SD)
 Q
 ;
XTENT ;
 ;;GETCANP;Get cancelled periods
 ;;RESTAV;Restore clinic availability
 ;;ADDHOL;Add holiday
 ;;UPDHOL;Update holiday
 ;;DELHOL;Delete holiday
 ;;REMAP;Remap clinic
