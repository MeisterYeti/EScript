// Testcases for HasEScript Scripting-Language
out ("EScript Testcases\nVersion: ",EScript.VERSION_STRING,"\n","-"*79,"\n");

{
	var expressions = [
		"7+8;",
		"out('Hello HasE!');",
		"a.b();",
		"a.b.c();",
		"a+b;",
		"(a.b())();",
		"if(true) 'yes';",
		"if(a) 'yes'; else if( b ) ; else 'no';",
		"a||b;",
		"a||b||c;",
		"a&&b;",
		"!a;",
		"var a; { var b; }",
		"var a; { var a; {var a;}} {var a;}",
		"var a = 1;{var b = 2;}",
		"var a = var b = 2;",
		"var a = out; a();",
		"var a=4; { var b=17; }",
		"a = var b;",
		"a.b = 5;",
		"foo().b = true;",
		"a.b := true;",
		"a.b ::= true;",
		"a.b @(private) ::= true;",
		"while(true);",
		"do{17;}while(false);",
		"for(var i=0;i<10;++i){	var a = i;}",
		"foreach(arr as var key,var value){	value; }",
	];
	
	
	foreach(expressions as var expression ){
		out("\n","-"*30,"\n[",expression,"]\n");
		var block = _parse2( expression);
		out( block._getAsm() );
	
	}

	
	exit(0);
	
	
	
	
	
	
	
}









//----
// init
GLOBALS.benchmark:=false;
GLOBALS.errors:=0; // error count
//! new testing function
GLOBALS.test := fn(description,result,checkCoverageType=false){
	if(!result)
		++errors;
	if(!benchmark){
		out(description.fillUp(25," "),result?"ok":"failed");

		if(checkCoverageType){
			var numFunctions=0;
			var coveredFunctions=0;
			var missing = [];
			foreach(checkCoverageType._getAttributes() as var fun){
				if(! (fun---|>Function))
					continue;
				++numFunctions;
				if(fun._getCallCounter()>0){
					++coveredFunctions;
				}else{
					missing+=fun.getOriginalName();
				}
			}
			out("\t (",coveredFunctions,"/",numFunctions,")");
			if(!missing.empty()){
				out("\nMissing: ",missing.implode(", "));
			}
		}
		out("\n");

	}

};

var start=clock();
var outBackup=out;
addSearchPath(__DIR__);

//----
var t = load("Testcases_Core.escript");

if(benchmark){
	var progress = fn( percent ){
		var i = (percent*20).floor();
		SGLOBALS.out("\r","|"+"="*i+"|"+" "*(20-i)+"| "+percent.round(0.01)*100+"%    ");
	};

	GLOBALS.out:=fn(values*){ ;};
	var times = [];
	var tries = 200;
	var innerLoops = 20;
	var sum = 0;

	progress(0);

	for(var i=0;i<tries;i++){
		var startTime = clock();
		for(var j=0;j<innerLoops;j++){
			t();
		}
		var time = (clock()-startTime)*1000;
		sum += time;
		times += (time/innerLoops).round(0.01); // ms per execution
		progress(i/tries);
	}
	progress(1);
//	print_r(times);
	times.sort();
	SGLOBALS.out("\nMin:",times.front(),"ms\tMed:",times[ (times.count()*0.5).floor() ],"ms\tMax:",times.back(),"ms\n" );
	SGLOBALS.out("Avg:",sum/ (tries*innerLoops),"\n");
}else{
	try{
		t();
	}catch(e){
		Runtime.log(Runtime.LOG_ERROR,e);
		++errors;
	}
}

load("Testcases_IOLib.escript");
load("Testcases_MathLib.escript");
load("Testcases_Runtime.escript");
//if(getOS()=="WINDOWS")
//	load(__DIR__+"/Testcases_Win32Lib.escript");
load("Bugs.escript");

GLOBALS.out=outBackup;

out("\n-----\n");
if(errors>0)
	out("Errors:\t\t",errors,"!\n");
else
	out("No Errors.\n");

out("Duration:\t",clock()-start," sec\n");

return "Bye!";
// ----------------------------------------------------------
