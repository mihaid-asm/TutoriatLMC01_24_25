:- [lab5lmc1].

implica(P,Q) :- not(P) ; Q.

multime([a,b,c,d]).

ordinepe(A,Ord) :- permutare(A,P), succlant(P,SuccLant), orddinsucc(SuccLant,A,OrdLant),
			sublista(Ord,OrdLant), ord(Ord,A).

conditie(Ord) :- not(member((a,d),Ord)), not(member((d,a),Ord)),
	not(member((b,c),Ord)), not(member((c,b),Ord)), multime(A),
	elementelemaximale(A,Ord,LMax), permutare([c,d],LMax),
	elementeleminimale(A,Ord,LMin), permutare([a,b],LMin).

detsucc(Succ) :- multime(A), ordinepe(A,Ord), conditie(Ord), succdinord(Ord,Succ).

% Sa eliminam multiplicarea unicei relatii de succesiune ca rezultat:

eord([]).
eord([_]).
eord([H,K|T]) :- H @< K, eord([K|T]).

detSucc(Succ) :- setof(S, detsucc(S), LS), member(Succ,LS), eord(Succ).

/* Rezolvarea cerintei de la examen: suficient:
detF(Fctf) :- inchsim([(a,c),(b,d)],Fctf).
*/

detf(Fctf) :- detSucc(Succ), inchsim(Succ,Fctf).

detR(RelR) :- detf(Fctf), multime(A), echivgen(Fctf,A,RelR).

inters(A,B,AintersB) :- setof(X, (member(X,A), member(X,B)), AintersB), !.
inters(_,_,[]).

detk(Ctk) :- detR(RelR), clsechiv(a,RelR,ClsEchiva), inters([b,c,d],ClsEchiva,Inters),
		member(Ctk,Inters).

verifAsatepsilon :- multime(A), detf(F), detR(R), detk(K),
	not((member(X,A), member((X,FX),F), member(Y,A), 
	not(implica((FX=K, member((K,Y),R)), member((X,Y),R))))).

testAsatepsilon :- multime(A), detf(F), detR(R), detk(K), 
	write(A), nl, write(F), nl, write(R), nl, write(K), nl,
	write('---------------------------'),
	not((member(X,A), member((X,FX),F), member(Y,A),
	nl, write('(X,Y)='), write((X,Y)), tab(2), write('f(x)='), write(FX), tab(2),
	not(implica((FX=K, write('f(x)=k'), tab(2), 
		member((K,Y),R), write('(k,y) e in R'), tab(2)),
		(member((X,Y),R), write('(x,y) e in R')))))).
