completa(R,A) :- not((member(X,A), member(Y,A),
	not(member((X,Y),R)), not(member((Y,X),R)))).

sublista([],_).
sublista([H|T],[H|L]) :- sublista(T,L).
sublista([H|T],[_|L]) :- sublista([H|T],L).

submultlinord(M,O,Lant) :- findall(S, (sublista(S,M), completa(O,S)), Lant).

% submultlinord([a,b,c,d] , [(a,a),(b,b),(c,c),(d,d),(a,d),(a,b),(a,c),(b,d),(c,d)], Lant)

prodrelbin(R,S,RxS) :- setof(((A,X),(B,Y)), (member((A,B),R), member((X,Y),S)), RxS), !.
prodrelbin(_,_,[]).

% Calculul produsului (Prod,OrdProd) a doua poseturi (P,OrdP) si (Q,OrdQ):

prodposeturi(P,OrdP,Q,OrdQ,Prod,OrdProd) :- prodcart(P,Q,Prod), 
				prodrelbin(OrdP,OrdQ,OrdProd).

% Asadar rombul, respectiv cubul pot fi obtinute astfel:

rombul(L2la2,OrdRomb) :- lant([0,1],Ord), prodposeturi([0,1],Ord,[0,1],Ord,L2la2,OrdRomb).

cubul(L2la3,OrdCub) :- lant([0,1],Ord), rombul(L2la2,OrdRomb), prodposeturi([0,1],Ord,L2la2,OrdRomb,L2la3,OrdCub).

rombplusL2(L,Ord) :- L=[0,b,x,y,1], orddinsucc([(0,x),(0,y),(x,b),(y,b),(b,1)],L,Ord).


elimdup([],[]).
elimdup([H|T],M) :- member(H,T), !, elimdup(T,M).
elimdup([H|T],[H|M]) :- elimdup(T,M).
reun(L,M,R) :- append(L,M,C), elimdup(C,R).
tranz(R) :- not((member((X,Y),R), member((Y,Z),R), not(member((X,Z),R)))).

comp(R,S,SoR) :- setof((X,Z), Y^(member((X,Y),R), member((Y,Z),S)), SoR), !.
comp(_,_,[]). % Y^ = exista un Y

diag([],[]).
diag([H|T],[(H,H)|U]) :- diag(T,U).
inchtranz(R,T) :- auxinchtranz(R,R,T).


inchrefl(R,A,Q) :- diag(A,D), reun(D,R,Q).
auxinchtranz(_,T,T) :- tranz(T), !.
auxinchtranz(R,Tn,T) :- comp(R,Tn,C), reun(R,C,Tsn), auxinchtranz(R,Tsn,T).
preordgen(R,A,P) :- inchtranz(R,T), inchrefl(T,A,P).
orddinsucc(Succ,A,Ord) :- preordgen(Succ,A,Ord).

l2plusrombplusL2(L,Ord) :- L=[0,a,b,x,y,1], orddinsucc([(0,a),(a,x),(a,y),(x,b),(y,b),(b,1)],L,Ord).
submultlinordL2plusL2xL2plusL2(Sub) :- l2plusrombplusL2(L,Ord), submultlinord(L,Ord,Sub).

% EX 4:

minorant(M,S,P,Ord) :- member(M,P), minoreaza(M,S,Ord).
minoreaza(M,S,Ord) :- not((member(X,S), not(member((M,X),Ord)))).

majorant(M,S,P,Ord) :- member(M,P), majoreaza(M,S,Ord).

majoreaza(M,S,Ord) :- not((member(X,S), not(member((X,M),Ord)))).

majorantii(S,P,Ord,LM) :- setof(M, majorant(M,S,P,Ord), LM), !.
majorantii(_,_,_,[]).

minim(M,S,Ord) :- minorant(M,S,S,Ord).

maxim(M,S,Ord) :- majorant(M,S,S,Ord).

inf(M,S,P,Ord) :- minorantii(S,P,Ord,L), maxim(M,L,Ord).

sup(M,S,P,Ord) :- majorantii(S,P,Ord,L), minim(M,L,Ord).

perechifarasup(Mult,Ord,Rez) :- findall((X,Y), (member(X,Mult),member(Y,Mult), not(sup(_,[X,Y],Mult,Ord))),Rez).

% 5 la fel

% 6
