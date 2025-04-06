%%% OBS! Daca nu sunteti pe Swi-Prolog downloadat nu o sa mearga corect comenzile.
%%% acest lucru se intampla pt ca varianta online SWISH are feature-uri oprite (pt safety).


%%% definitii de baza:
boolTable([]).
boolTable([H|T]) :- member(H,[false,true]), boolTable(T).

implica(P,Q) :- not(P);Q.
echiv(P,Q) :- implica(P,Q), implica(Q,P).
implDif(P,Q) :- implica(P,Q), not(implica(Q,P)).
dif(P,Q) :- P, not(Q).
xor(P,Q) :- P, not(Q) ; Q, not(P).
symDif(P,Q) :- xor(P,Q);


sterge(_,[],[]).
sterge(H,[H|T],L) :- !, sterge(H,T,L).
sterge(X,[H|T],[H|L]) :- sterge(X,T,L).

elimdupl([],[]).
elimdupl([H|T],[H|L]) :- sterge(H,T,M), elimdupl(M,L).

prodmult(L,M,LxM) :- setof((X,Y), (member(X,L), member(Y,M)), LxM), !.
prodmult(_,_,[]).

prodlist(L,M,LxM) :- findall((X,Y), (member(X,L), member(Y,M)), LxM).

prodcart([],_,[]).
prodcart([H|T],L,P) :- prodsgl(H,L,Q), prodcart(T,L,R), append(Q,R,P).

prodsgl(_,[],[]).
prodsgl(H,[K|T],[(H,K)|U]) :- prodsgl(H,T,U).

prodcartmult(L,M,LxM) :- prodcart(L,M,P), elimdupl(P,LxM).



%%% Exemplu cu ipoteze:

ipoteza1(A,B,C,D) :- implica((A,B), xor(C,D)).
ipoteza2(A,B,C,D) :- implica((B,C), (A,D ; not(A),not(D))).
ipoteza3(A,B,C,D) :- implica((not(A),not(B)), (not(C),not(D))).

ipoteza(A,B,C,D) :- ipoteza1(A,B,C,D), ipoteza2(A,B,C,D), ipoteza3(A,B,C,D).

cerintaI(A,B,C) :- implica((not(A),not(B)), not(C)).
cerintaII(A,B,C) :- not((A,B,C)).

dedemI(A,B,C,D) :- implica(ipoteza(A,B,C,D), cerintaI(A,B,C)).
dedemII(A,B,C,D) :- implica(ipoteza(A,B,C,D), cerintaII(A,B,C)).

demcerintaI :- not((boolTable([A,B,C,D]), write((A,B,C,D)), nl,
		not(dedemI(A,B,C,D)))).

demcerintaII :- not((member(A,[false,true]), member(B,[false,true]),
		member(C,[false,true]), member(D,[false,true]), write((A,B,C,D)), nl,
		not(dedemII(A,B,C,D)))).

/***
DEMONSTRATIE INTUTIVA DE CE MERGE CU TABELE DE ADEVAR.
(ddaca = daca si numai daca)

pt orice multimi, A = B ddaca (x apartine A ddaca x apartine B).
x apartine A poate fi ori adevarat ori fals. Daca A este dat de o formula mai complexa:
A = C reunit cu D, atunci putem face o tabela de adevar: x apartine A daca x apartine C SAU x apartine D.
Posibilitatile sunt [00,01,10,11] si doar pentru prima x nu e in A.

Daca avem in ambele parti formule mai interesante, putem doar verifica pentru 
o tabela de adevar sa dea mereu true-true sau false-false si atunci sunt egale.

***/

%%% TEMA:

% Pt a scrie f prescurtat, putem sa ne folosim de o demonstratie generala:

generate_vars(0, []) :- !.
generate_vars(N, [_|Rest]) :-
    N > 0, N1 is N - 1,
    generate_vars(N1, Rest).

demGeneral(N,S,D) :- generate_vars(N,X),
   not(( boolTable(X), write(X), nl,not(echiv(call(S,X),call(D,X))))).


% 1. A ∩ (B ∪ C) = (A ∩ B) ∪ (A ∩ C)

ms1([A,B,C]) :- A , (B;C).
md1([A,B,C]) :- A,B ; A,C.


dem1 :- not((boolTable([A,B,C]), write([A,B,C]),nl,  not(echiv(ms1([A,B,C]),md1([A,B,C]))))).

dem1G :- demGeneral(3,ms1,md1).

% 2. A ∪ B = B ddaca A ⊆ B ddaca A ∩ B = A

ms2_1([A,B]) :- A;B.
ms2_2([_,B]) :- B.
ms2([A,B]) :- echiv(ms2_1([A,B]),ms2_2([A,B])).
md2([A,B]) :- implica(A,B).

dem2_1 :- demGeneral(2,ms2,md2).

mt2([A,B]) :- echiv( (A,B), A).
dem2 :- dem2_1, demGeneral(2, ms2, mt2).

% 3. A ∪ Ø = A. A ∩ Ø = Ø, A \ Ø = A. Ø \ A = Ø. A Δ Ø = A.

ms3_1([A]) :- (A;false).
md3_1([A]) :- A.
dem3_1 :- demGeneral(1,ms3_1, md3_1).

ms3_2([A]) :- A, false.
md3_2([_]) :- false.
dem3_2 :- demGeneral(1, ms3_2, md3_2).

ms3_3([A]) :- dif(A, false).
md3_3([A]) :- A.
dem3_3 :- demGeneral(1, ms3_3, md3_3).

ms3_4([A]) :- dif(false, A).
md3_4([_]) :- false.
dem3_4 :- demGeneral(1, ms3_4, md3_4).

ms3_5([A]) :- symDif(A, false).
md3_5([A]) :- A.
dem3_5 :- demGeneral(1, ms3_5, md3_5).


% 5. A ⊂ B ddaca (A ⊆ B ∩ B ⊂ A) ddaca (A ⊆ B ∩ B \ A != Ø)

ms5([A,B]) :- implDif(A,B).
md5([A,B]) :- implica(A,B), not(implica(B,A)).
mt5([A,B]) :- implica(A,B), dif(B,A).

dem5_1 :- demGeneral(2,ms5,md5).
dem5_2 :- demGeneral(2,ms5,mt5).

% 6.
tRUE(_).
ms0([A]) :- implica(A,not(A)).
dem0 :- demGeneral(1, ms0, tRUE).
