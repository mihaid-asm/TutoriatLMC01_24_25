:- [lab5lmc1].

l4(L4,OrdL4) :- L4=[0,u,v,1], orddinsucc([(0,u),(u,v),(v,1)],L4,OrdL4).

cub(B,OrdB) :- B=[0,a,b,c,x,y,z,1], 
orddinsucc([(0,a),(0,b),(0,c),(a,x),(a,y),(b,x),(b,z),(c,y),(c,z),(x,1),(y,1),(z,1)],B,OrdB).

% Determinarea functiilor strict crescatoare de la un poset (P,OrdP) la un poset (Q,OrdQ):

strcresc(F,OrdP,OrdQ) :- not((member((X,Y),OrdP), X\=Y, member((X,FX),F), member((Y,FY),F),
			not((member((FX,FY),OrdQ), FX\=FY)))).

fctstrcresc(F,P,OrdP,Q,OrdQ) :- fct(F,P,Q), strcresc(F,OrdP,OrdQ).

functiistrcresc(P,OrdP,Q,OrdQ,LF) :- setof(F, fctstrcresc(F,P,OrdP,Q,OrdQ), LF), !.
functiistrcresc(_,_,_,_,[]).

% Determinarea functiilor strict crescatoare f:L4->L2xL2xL2:

fctL4laL2xL2xL2(ListaFctStrCresc) :- l4(L4,OrdL4), cub(B,OrdB), 
	functiistrcresc(L4,OrdL4,B,OrdB,ListaFctStrCresc).

/* Testez daca functia F:L->M este morfism de latici marginite intre laticile marginite
date prin laticile lor Ore subiacente (L,OrdL) si (M,OrdM): */

testmorflatmarg(F,L,OrdL,M,OrdM) :- pastrdisjconj(F,L,OrdL,M,OrdM), 
				pastr0si1(F,L,OrdL,M,OrdM).

% Testez daca toate elementele unei liste de functii sunt morfisme de latici marginite:

listamorflatmarg([],_,_,_,_).
listamorflatmarg([H|T],L,OrdL,M,OrdM) :- testmorflatmarg(H,L,OrdL,M,OrdM),
			listamorflatmarg(T,L,OrdL,M,OrdM).

% Testez daca toate functiile crescatoare de la L4 la cub sunt morfisme de latici marginite: 

toatemorflatmarg :- fctL4laL2xL2xL2(ListaFctStrCresc), l4(L4,OrdL4), cub(B,OrdB),
	listamorflatmarg(ListaFctStrCresc,L4,OrdL4,B,OrdB).


