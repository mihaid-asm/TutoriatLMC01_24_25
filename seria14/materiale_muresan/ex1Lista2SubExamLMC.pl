:- [lab5lmc1].

cub(B,OrdB) :- B=[0,a,b,c,x,y,z,1], 
orddinsucc([(0,a),(0,b),(0,c),(a,x),(a,y),(b,x),(b,z),(c,y),(c,z),(x,1),(y,1),(z,1)],B,OrdB).

l3(L3,OrdL3) :- L3=[0,m,1], orddinsucc([(0,m),(m,1)],L3,OrdL3).

fctL2xL2xL2laL3(ListaMorfLatMarg) :- cub(B,OrdB), l3(L3,OrdL3),
	morfismelelatmarg(B,OrdB,L3,OrdL3,ListaMorfLatMarg).

niciunasurj([],_).
niciunasurj([Fct|ListaFct],Codom) :- not(surj(Fct,Codom)), niciunasurj(ListaFct,Codom).

niciunasurj :- fctL2xL2xL2laL3(ListaMorfLatMarg), l3(L3,_), niciunasurj(ListaMorfLatMarg,L3).

% varianta:

niciunanuesurj :- fctL2xL2xL2laL3(ListaMorfLatMarg), l3(L3,_), 
	not((member(Fct,ListaMorfLatMarg), surj(Fct,L3))).

% Nu e cerut in examen, dar sa verificam:

testniciunasurj([],_).
testniciunasurj([Fct|ListaFct],Codom) :- write(Fct), not(surj(Fct,Codom)), 
	write(' nu e surjectiva'), nl, testniciunasurj(ListaFct,Codom).

testniciunasurj :- fctL2xL2xL2laL3(ListaMorfLatMarg), l3(L3,_), 
		testniciunasurj(ListaMorfLatMarg,L3).

% varianta:

testniciunanuesurj :- fctL2xL2xL2laL3(ListaMorfLatMarg), l3(L3,_), 
	not((member(Fct,ListaMorfLatMarg), nl, write(Fct), surj(Fct,L3),
	write(' e surjectiva'))).

