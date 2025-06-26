% OBS! nu e adevaratul lab 6. am combinat doar ce am folosit sa se vada predicatele.

implica(P,Q) :- not(P) ; Q.
echiv(P,Q) :- implica(P,Q), implica(Q,P).
xor(P,Q) :- P, not(Q) ; Q, not(P).

% Amintesc acest predicat pentru calculul inversei unei liste:
inversa([],[]).
inversa([H|T],L) :- inversa(T,U), append(U,[H],L).

% Afisarea unei liste cu fiecare element pe alta linie:
afislista([]).
afislista([H|T]) :- write(H), nl, afislista(T).

% Stergerea unui element X dint-o lista.
sterge(_,[],[]).
sterge(H,[H|T],L) :- sterge(H,T,L), !.
sterge(X,[H|T],[H|L]) :- sterge(X,T,L).

/* Predicat care sterge o singura aparitie a unui element intr-o lista, dar de pe o pozitie arbitrara: */
stergeuna(_,[],_) :- fail.
stergeuna(H,[H|T],T).
stergeuna(X,[H|T],[H|L]) :- stergeuna(X,T,L).

/* Eliminarea duplicatelor dintr-o lista, cu pastrarea primei aparitii a fiecarui element: */
elimdupl([],[]).
elimdupl([H|T],[H|L]) :- sterge(H,T,U), elimdupl(U,L).

% Produsul cartezian (de multimi, i.e. generat fara duplicate), cu setof:
prodmult(L,M,LxM) :- setof((X,Y), (member(X,L), member(Y,M)), LxM), !.
prodmult(_,_,[]).

% Produsul cartezian de liste, cu bagof, respectiv findall:
prodlist(L,M,LxM) :- bagof((X,Y), (member(X,L), member(Y,M)), LxM), !.
prodlist(_,_,[]).

prodcart(_,[],[]).
prodcart(L,[H|T],P) :- prodsgl(L,H,Q), prodcart(L,T,R), append(Q,R,P).

prodsgl([],_,[]).
prodsgl([H|T],X,[(H,X)|U]) :- prodsgl(T,X,U).

prodcartmult(L,M,P) :- prodcart(L,M,Q), elimdupl(Q,P).

/* Predicatul listaValBool trebuie apelat cu argumentul dat de o lista de variabile.
Cand este apelat cu o lista L de N variabile distincte (i.e. o lista L de lungime N continand variabile doua cate doua distincte), acest predicat intoarce 2**N solutii, anume listele de N valori booleene, pe care le si afiseaza pe ecran, urmate de cate o trecere la linie noua. */
listaBool([]).
listaBool([H|T]) :- member(H,[false,true]), listaBool(T).

listaValBool(L) :- listaBool(L), write(L), nl.

% Reuniunea, ca lista fara duplicate:
reuniune(A,B,R) :- append(A,B,C), elimdupl(C,R).

% Intersectia (rezulta fara duplicate daca prima lista e fara duplicate):
inters([],_,[]).
inters([H|T],B,[H|L]) :- member(H,B), !, inters(T,B,L).
inters([_|T],B,L) :- inters(T,B,L).
% Intersectia, ca lista fara duplicate:
intersectie(A,B,I) :- inters(A,B,J), elimdupl(J,I).

/* Diferenta, prin recurenta dupa primul termen (daca acesta e fara duplicate, atunci rezultatul e fara duplicate): */
dif([],_,[]).
dif([H|T],B,L) :- member(H,B), !, dif(T,B,L).
dif([H|T],B,[H|L]) :- dif(T,B,L).

/* Diferenta simetrica, ca lista fara duplicate, cu fiecare dintre cele doua metode de mai sus pentru obtinerea diferentei: */
difsim(A,B,D) :- dif(A,B,AminusB), dif(B,A,BminusA), reuniune(AminusB,BminusA,D).


/* Desigur, in listele fara duplicate din Prolog conteaza ordinea elementelor, spre deosebire de multimi. Doua liste fara duplicate sunt egale ca multimi ddaca fiecare dintre ele este permutare a celeilalte: */
egalmult(A,B) :- permutare(A,B).

permutare([],[]).
permutare([H|T],P) :- permutare(T,Q), stergeuna(H,P,Q).

% Multimea permutarilor unei liste:
permutarile(L,LP) :- setof(P, permutare(L,P), LP).

/* Determinarea sublistelor unei liste; daca lista e fara duplicate, reprezentand, asadar, o multime, atunci obtinem partile (i.e. submultimile) multimii respective: */
sublista([],_).
sublista([H|T],[H|L]) :- sublista(T,L).
sublista([H|T],[_|L]) :- sublista([H|T],L). % fara aceasta regula rezulta prefixele

/* Multimea (i.e. lista fara duplicate a) sublistelor unei liste; daca lista e fara duplicate, obtinem multimea partilor multimii respective: */
sublistele(L,LS) :- setof(S, sublista(S,L), LS).

/* Putem testa daca o multime e submultime a alteia, indiferent de ordinea elementelor listelor care le reprezinta, astfel: */
submultime(S,L) :- permutare(L,P), sublista(S,P).

% Determinarea relatiilor binare R de la A la B:
relbin(R,A,B) :- prodcartmult(A,B,P), sublista(R,P).
relbinara(R,A) :- relbin(R,A,A).

% Determinarea multimii LR a relatiilor binare de la A la B, doua variante:
relatiibinare(A,B,LR) :- setof(R, relbin(R,A,B), LR).

/* Predicatul functie(-Functie,+listaA,+listaB) determina functiile Functie de la
multimea (i.e. lista fara duplicate) listaA la multimea listaB: */
functie([],[],_).
functie([(H,FH)|L],[H|T],B) :- member(FH,B), functie(L,T,B).

% Testarea functionalitatii unei relatii binare R de la multimea A la o alta multime:
functionala(F,A) :-  not((member(X,A), member((X,B),F), member((X,C),F), B\=C)).

/* Determinarea relatiilor totale de la A la B, cu doua metode de testare a totalitatii, i.e. a definirii peste tot, adica pentru toate elementele lui A: */
totala(R,A) :- not((member(X,A), not(member((X,_),R)))).

% Inversa unei relatii binare, calculata in doua moduri:
invrel([],[]).
invrel([(X,Y)|T],[(Y,X)|L]) :- invrel(T,L).

inj(R,B) :-  not((member(Y,B), member((A,Y),R), member((U,Y),R), A\=U)).
injectiv(R) :- not((member((U,Y),R), member((X,Y),R), U\=X)).

surj(R,A,B) :- not((member(Y,B), not((member(X,A), member((X,Y),R))))).
surjectiv(R,B) :- not((member(Y,B), not(member((_,Y),R)))).

functiebijectiv(F,A,B) :- functie(F,A,B), inj(F,B), surj(F,A,B).

% Predicat care testeaza daca o lista nu are duplicate:
faradupl([]).
faradupl([H|T]) :- not(member(H,T)), faradupl(T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%:- [lab3lmc4].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% incepe lab 4:

% Produsul cartezian a N multimi:
prodNmult([L],L) :- !.
prodNmult([Lista|ListaListe],Prod) :- prodNmult(ListaListe,P),
				prodcartmult(Lista,P,Prod).

% Varianta pentru puterile naturale nenule ale unei multimi:
listaNcopiiMult(_,0,[]).
listaNcopiiMult(A,N,[A|L]) :- N>0, PN is N-1, listaNcopiiMult(A,PN,L).

putereaNmult(A,N,P) :- listaNcopiiMult(A,N,L), prodNmult(L,P).

im(R,A,Im) :- setof(Y, X^(member(X,A), member((X,Y),R)), Im), !.
im(_,_,[]).

preim(R,B,PreIm) :- setof(X, Y^(member(Y,B), member((X,Y),R)), PreIm), !.
preim(_,_,[]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%:- [lab4lmc1].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% incepe lab 5:

% Compunerea de relatii binare:
comprel(S,R,SoR) :- setof((X,Z), Y^(member((X,Y),R),member((Y,Z),S)), SoR), !.
comprel(_,_,[]).

% Produsul a doua relatii binare:
prodrel(R,Q,RxQ) :- setof(((X,Y),(U,V)), 
		(member((X,Y),R), member((U,V),Q)), RxQ), !.
prodrel(_,_,[]).

% Diagonala multimii A, recursiv:
diag(A,D) :- setof((X,X), member(X,A), D).

diagonala([],[]).
diagonala([H|T],[(H,H)|L]) :- diagonala(T,L).

% Puterile intregi nenule ale unei relatii binare pe o multime:
putere(R,1,R).
putere(R,N,RlaN) :- N>1, PN is N-1, putere(R,PN,RlaPN), comprel(RlaPN,R,RlaN).
putere(R,N,RlaN) :- N<0, ModulN is -N, invrel(R,I), putere(I,ModulN,RlaN).

/* Puterile intregi ale unei relatii binare pe o multime A: urmatorul predicat, de aritate 4, nu va fi confundat de Prolog cu predicatul ternar de mai sus: */
putere(_,A,0,D) :- diag(A,D).
putere(R,A,N,RlaN) :- N>0, PN is N-1, putere(R,A,PN,RlaPN),
			comprel(RlaPN,R,RlaN).
putere(R,A,N,RlaN) :- N<0, ModulN is -N, invrel(R,I), putere(I,A,ModulN,RlaN).

/* Testarea reflexivitatii unei relatii binare pe o multime A, cu negatie, apoi recursiv: */

reflexiva(_,[]).
reflexiva(R,[H|T]) :- member((H,H),R), reflexiva(R,T).
refl(R,A) :- not((member(X,A), not(member((X,X),R)))).

/* Testarea simetriei unei relatii binare pe o multime, cu negatie, apoi recursiv: */
sim(R) :- not((member((X,Y),R), not(member((Y,X),R)))).

simetrica(R) :- auxsim(R,R).

auxsim(_,[]).
auxsim(R,[(X,Y)|T]) :- member((Y,X),R), auxsim(R,T).

% Testarea tranzitivitatii unei relatii binare pe o multime:
tranz(R) :- not((member((X,Y),R), member((Y,Z),R), not(member((X,Z),R)))).

preord(R,A) :- refl(R,A), tranz(R).

eq(R,A) :- preord(R,A), sim(R).
releq(R,A) :- relbinara(R,A), eq(R,A).

/* Testarea antisimetriei, asimetriei, ireflexivitatii unei relatii binare pe o multime: */
antisimetrica(R) :- auxantisim(R,R).

auxantisim(_,[]).
auxantisim(R,[(X,Y)|T]) :- (X=Y, !; not(member((Y,X),R))), auxantisim(R,T).

asim(R) :- not((member((X,Y),R), member((Y,X),R))).

irefl(R) :- not(member((X,X),R)).

ordine(R,A) :- preord(R,A), antisimetrica(R).

ordinestricta(R) :- irefl(R), tranz(R).

% Clasa C a unui element X raportat la o relatie de echivalenta E:
clasa(X,E,C) :- setof(Y, member((X,Y),E), C). 

% Partitia P asociata unei relatii de echivalenta E pe o multime A:
parteq(E,A,P) :- setof(C, X^(member(X,A), clasa(X,E,C)), P).

partitii(A,PartA) :- setof(P, R^(releq(R,A), parteq(R,A,P)), PartA).

% Relatia de echivalenta asociata unei partitii:
eqpart([],[]).
eqpart([A|LA],E) :- prodcart(A,A,AxA), eqpart(LA,F), reuniune(AxA,F,E).

% Ordinea stricta S asociata unei ordini O, in doua moduri:
ordstrdinord(O,S) :- setof((X,Y), (member((X,Y), O), X\=Y), S), !.
ordstrdinord(_,[]).

succdinord(O,Succ) :- setof((X,Y), (member((X,Y),O), X\=Y,
	(not((member((X,U),O), X\=U, member((U,Y),O), U\=Y)))), Succ), !.

% Inchiderea reflexiva a unei relatii binare Q pe o multime A:

inchrefl(Q,A,R) :- diag(A,D), reuniune(D,Q,R).

% Inchiderea simetrica a unei relatii binare Q:

inchsim(Q,S) :- invrel(Q,R), reuniune(Q,R,S).

% Inchiderea tranzitiva a unei relatii binare Q:

inchtranz(Q,T) :- auxit(Q,1,[],T).

auxit(Q,N,R,T) :- putere(Q,N,P), reuniune(R,P,S),
		(tranz(S), !, T=S ; SN is N+1, auxit(Q,SN,S,T)).


preordgen(Q,A,P) :- inchtranz(Q,T), inchrefl(T,A,P).

% Echivalenta generata de o relatie binara Q pe o multime A:
eqgen(Q,A,E) :- inchsim(Q,S), preordgen(S,A,E).

%
orddinsucc(Succ,A,O) :- preordgen(Succ,A,O).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%:- [lab5lmc4].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% incepe lab 6:
/* Notez suma ordinala cu + si ridicarea la putere cu ^. Sa construim cateva poseturi (P,OrdP), introducand multimea suport P si relatia de succesiune, apoi obtinand din acestea relatia de ordine OrdP cu predicatul orddinsucc: */

% A = L2^2+L2: suma ordinala dintre romb si lantul cu doua elemente:

posetA(A,OrdA) :- A=[0,a,b,c,1],
	orddinsucc([(0,a),(0,b),(a,c),(b,c),(c,1)],A,OrdA).

% B = "V rasturnat":

posetB(B,OrdB) :- B=[u,v,1], orddinsucc([(u,1),(v,1)],B,OrdB).

% L2: lantul cu doua elemente:

l2([0,1],OrdL2) :- orddinsucc([(0,1)],[0,1],OrdL2).

% P = L2+"V":

posetP(P,OrdP) :- P=[a,b,c,d], orddinsucc([(a,b),(b,c),(b,d)],P,OrdP).

% L3: lantul cu trei elemente:

l3(L3,OrdL3) :- L3=[0,a,1], orddinsucc([(0,a),(a,1)],L3,OrdL3).

% L2^2: rombul:

romb(R,OrdR) :- R=[0,a,b,1], orddinsucc([(0,a),(0,b),(a,1),(b,1)],R,OrdR).

% L2+L2^2+L2:

latL(L,OrdL) :- L=[0,a,x,y,b,1],
	orddinsucc([(0,a),(a,x),(a,y),(x,b),(y,b),(b,1)],L,OrdL).

% L2^3: cubul:

cub(C,OrdC) :- C=[0,a,b,c,x,y,z,1], orddinsucc([(0,a),(0,b),(0,c),(a,x),(a,y),(b,x),(b,z),(c,y),(c,z),(x,1),(y,1),(z,1)],C,OrdC).

% Diamantul: M3:

m3(M3,OrdM3) :- M3=[0,a,b,c,1],
	orddinsucc([(0,a),(0,b),(0,c),(a,1),(b,1),(c,1)],M3,OrdM3).

% Pentagonul: N5:

n5(N5,OrdN5) :- N5=[0,x,y,z,1],
	orddinsucc([(0,x),(x,1),(0,y),(y,z),(z,1)],N5,OrdN5).
	
% Hexagonul:

hexa(M,Ord) :- M=[0,u,x,y,z,1],
	orddinsucc([(0,u),(u,x),(x,1),(0,y),(y,z),(z,1)],M,Ord).


/* Predicat care testeaza daca o functie F:A->B pastreaza relatiile binare R<=A^2 si S<=B^2, mai precis daca duce pe R in S, adica are proprietatea ca, pentru orice x,y in A, daca (x,y) in R, atunci (F(x),F(y)) in S: */
pastrrel(F,R,S) :- not((member((X,Y),R), member((X,FX),F), member((Y,FY),F),
			not(member((FX,FY),S)))).

% Functiile crescatoare F:P->Q intre doua poseturi (P,OrdP) si (Q,OrdQ):
fctcresc(F,P,OrdP,Q,OrdQ) :- functie(F,P,Q), pastrrel(F,OrdP,OrdQ).

% Functiile strict crescatoare F:P->Q intre doua poseturi (P,OrdP) si (Q,OrdQ):
fctstrcresc(F,P,OrdP,Q,OrdQ) :- functie(F,P,Q), ordstrdinord(OrdP,OrdStrP),
		ordstrdinord(OrdQ,OrdStrQ), pastrrel(F,OrdStrP,OrdStrQ).

/* Determinarea minorantilor, respectiv a majorantilor M ai unei submultimi S a unui poset (P,OrdP): */
minoreaza(M,S,Ord) :- not((member(X,S), not(member((M,X),Ord)))).

minorant(M,S,P,OrdP) :- member(M,P), minoreaza(M,S,OrdP).

minorantii(S,P,OrdP,LM) :- setof(M, minorant(M,S,P,OrdP), LM), !.
minorantii(_,_,_,[]).

majoreaza(M,S,Ord) :- not((member(X,S), not(member((X,M),Ord)))).

majorant(M,S,P,OrdP) :- member(M,P), majoreaza(M,S,OrdP).

majorantii(S,P,OrdP,LM) :- setof(M, majorant(M,S,P,OrdP), LM), !.
majorantii(_,_,_,[]).

/* Determinarea minimului, respectiv a maximului M unei multimi S raportat la ordinea Ord; ca si in cazul predicatelor minoreaza si majoreaza, Ord poate fi o  ordine pe S sau pe o multime care include pe S; de fapt, pentru ca aceste predicate sa functioneze, este suficient ca Ord sa fie o lista care include o relatie de ordine pe S: */

min(S,Ord,M) :- minorant(M,S,S,Ord).

max(S,Ord,M) :- majorant(M,S,S,Ord).

/* Determinarea infimumului, respectiv a supremumului M al unei submultimi S a unui poset (P,OrdP): */

inf(S,P,OrdP,M) :- minorantii(S,P,OrdP,LM), max(LM,OrdP,M).

sup(S,P,OrdP,M) :- majorantii(S,P,OrdP,LM), min(LM,OrdP,M).

/* Determinarea elementelor minimale, respectiv a elementelor maximale M ale unei submultimi S a unui poset (P,Ord), apoi a listei LM a fiecarora dintre acestea: */

elemminimal(M,S,Ord) :- ordstrdinord(Ord,OrdStr), nueminstrict(M,S,OrdStr).

nueminstrict(M,S,OrdStr) :- member(M,S),
	not((member(X,S), member((X,M),OrdStr))).

elemmaximal(M,S,Ord) :- ordstrdinord(Ord,OrdStr), nuemajstrict(M,S,OrdStr).

nuemajstrict(M,S,OrdStr) :- member(M,S),
	not((member(X,S), member((M,X),OrdStr))).


/* Sa determinam daca un poset (L,OrdL) este latice (Ore), respectiv latice marginita, respectiv latice marginita complementata: */
latice(L,OrdL) :- not((member(X,L), member(Y,L),
	not((inf([X,Y],L,OrdL,_), sup([X,Y],L,OrdL,_))))).

latmarg(L,OrdL) :- latice(L,OrdL), min(L,OrdL,_), max(L,OrdL,_).

latmargcomplem(L,OrdL) :- latice(L,OrdL), min(L,OrdL,Zero), max(L,OrdL,Unu),
		not((member(X,L), not((member(Y,L), 
		inf([X,Y],L,OrdL,Zero), sup([X,Y],L,OrdL,Unu))))).

% Alta varianta, cu determinarea complementilor fiecarui element complementat:

complem(X,L,OrdL,Y) :-  min(L,OrdL,Zero), max(L,OrdL,Unu), member(Y,L),
	inf([X,Y],L,OrdL,Zero), sup([X,Y],L,OrdL,Unu).

% Sau, fara calculul lui 0 si 1 repetat:

complem(X,L,OrdL,Zero,Unu,Y) :-  member(Y,L),
	inf([X,Y],L,OrdL,Zero), sup([X,Y],L,OrdL,Unu).

laticemargcomplem(L,OrdL) :- latmarg(L,OrdL),
	not((member(X,L), not(complem(X,L,OrdL,_)))).

% Sa determinam daca un poset (P,OrdP) este lant:

lant(P,OrdP) :- not((member(X,P), member(Y,P), 
	not((member((X,Y),OrdP) ; member((Y,X),OrdP))))).

/* Determinarea sublaticilor, respectiv a sublaticilor marginite S, ale unei latici, respectiv latici marginite date prin laticea sa (Ore) subiacenta (L,OrdL): */

sublat(S,L,OrdL) :- sublista(S,L), not((member(X,S), member(Y,S),
	inf([X,Y],L,OrdL,XsiY), sup([X,Y],L,OrdL,XsauY),
	not((member(XsiY,S), member(XsauY,S))))).

sublatmarg(S,L,OrdL) :- sublat(S,L,OrdL), inch0si1(S,L,OrdL).

inch0si1(S,L,OrdL) :- min(L,OrdL,Zero), max(L,OrdL,Unu), 
		member(Zero,S), member(Unu,S).

sublaticemarg(S,L,OrdL,Zero,Unu) :- sublat(S,L,OrdL), 
	min(L,OrdL,Zero), max(L,OrdL,Unu), member(Zero,S), member(Unu,S).

sublatnelinord(S,L,OrdL) :- sublat(S,L,OrdL), not(lant(S,OrdL)).

%
sublant(S,L,OrdL) :- sublista(S,L), lant(S,OrdL).


toatelantsublat(L,OrdL) :- not((sublant(S,L,OrdL), not(sublat(S,L,OrdL)))).

/* Inchiderea la complement a unei submultimi S a unei latici marginite complementate (L,OrdL,Zero,Unu), variante: */

inchcomplem(S,L,OrdL) :- min(L,OrdL,Zero), max(L,OrdL,Unu),
	not((member(X,S), complem(X,L,OrdL,Zero,Unu,Y), not(member(Y,S)))).

inchcomplem(S,L,OrdL,Zero,Unu) :- not((member(X,S), 
	complem(X,L,OrdL,Zero,Unu,Y), not(member(Y,S)))).

/* Determinarea subalgebrelor booleene ale unei algebre Boole (B,OrdB), variante echivalente: */

subalgebrabool(S,B,OrdB) :- sublaticemarg(S,B,OrdB,Zero,Unu),
	inchcomplem(S,B,OrdB,Zero,Unu).

subalgbool(S,B,OrdB) :- sublatmarg(S,B,OrdB), inchcomplem(S,B,OrdB).

subalgBoole(S,B,OrdB) :- sublat(S,B,OrdB), S\=[], inchcomplem(S,B,OrdB).

morflat(F,L,OrdL,M,OrdM) :- functie(F,L,M), pastrdisjconj(F,L,OrdL,M,OrdM).

pastrdisjconj(F,L,OrdL,M,OrdM) :- not((member(X,L), member(Y,L),
	member((X,FX),F), member((Y,FY),F),
	inf([X,Y],L,OrdL,XsiY), sup([X,Y],L,OrdL,XsauY), 
	inf([FX,FY],M,OrdM,FXsiFY), sup([FX,FY],M,OrdM,FXsauFY),
	not((member((XsiY,FXsiFY),F), member((XsauY,FXsauFY),F))))).

morflatmarg(F,L,OrdL,M,OrdM) :- morflat(F,L,OrdL,M,OrdM),
	pastr0si1(F,L,OrdL,M,OrdM).

pastr0si1(F,L,OrdL,M,OrdM) :- min(L,OrdL,ZeroL), max(L,OrdL,UnuL),
	min(M,OrdM,ZeroM), max(M,OrdM,UnuM),
	auxpastr0si1(F,ZeroL,UnuL,ZeroM,UnuM).

auxpastr0si1(F,ZeroL,UnuL,ZeroM,UnuM) :- member((ZeroL,ZeroM),F),
			member((UnuL,UnuM),F).

pastrcomplem(F,L,OrdL,M,OrdM) :- 
   min(L,OrdL,ZeroL), max(L,OrdL,UnuL), min(M,OrdM,ZeroM), max(M,OrdM,UnuM),
   pastrcomplem(F,L,OrdL,ZeroL,UnuL,M,OrdM,ZeroM,UnuM).

pastrcomplem(F,L,OrdL,ZeroL,UnuL,M,OrdM,ZeroM,UnuM) :- not((member(X,L),
	member((X,FX),F), complem(X,L,OrdL,ZeroL,UnuL,Y), member((Y,FY),F), 
	not(complem(FX,M,OrdM,ZeroM,UnuM,FY)))).

/* Morfismele de latici marginite intre algebre Boole sunt morfisme booleene, asadar urmatoarele predicate intorc aceleasi solutii F ca morflatmarg: */

morfbool(F,L,OrdL,M,OrdM) :- morflatmarg(F,L,OrdL,M,OrdM),
	pastrcomplem(F,L,OrdL,M,OrdM).