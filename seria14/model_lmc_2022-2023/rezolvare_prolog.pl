:- [lab6lmc3]. % includem tot

% Exercitiul 1:

l4(A,Ord) :- A = [0,1,a,b], orddinsucc([(0,a),(a,b),(b,1)],A,Ord). % nu aveam lantul L4 predefinit. el este 0 <= a <= b <= 1.

fctL4laL2xL2xL2(FctCresc) :- l4(L4,OrdL4), cub(Cub,OrdCub), % luam cele 2 poseturi din enunt
    setof(F, fctstrcresc(F, L4, OrdL4, Cub, OrdCub), FctCresc). % adaugam toate functiile F strict crescatoare in lista FctCresc

toatemorflatmarg :- l4(L4,OrdL4), cub(Cub,OrdCub),  % luam cele 2 poseturi din enunt
    fctL4laL2xL2xL2(Fct), % generam acele functii strict crescatoare
    not((member(F,Fct), not(morflatmarg(F,L4, OrdL4, Cub, OrdCub)))). % verificam sa nu existe functii care sa nu fie morfisme de latici marginite.



% Exercitiul 2:

fi(A,B) :- implica(implica(A,B), (A, not(B))).
propr1 :- listaBool([Alfa,Beta]), fi(Alfa,Beta). % prima evaluare ce respecta (sau false).

% nota: a satisface o multime inseamna a satisface toate elementele.
propr2 :- not((listaBool([Alfa,Beta]), fi(Alfa,Beta), (Alfa, Beta))). % daca fi(A,B) atunci sa nu fie satisfabil {A,B}


% Exercitiul 3:

multimeaA([a,b,c,d]).
detf(F) :- F = ([(a,b), (b,c), (c,d), (d,d)]), multimeaA(A), functionala(F,A), totala(F,A).
detR(R) :- multimeaA(A),orddinsucc([(a,b), (a,c), (b,d), (c,d)],A,Ord), ordstrdinord(Ord,R).

intersectieRelatii(R1,R2,Inters) :- setof((X,Y), (member((X,Y),R1), member((X,Y),R2)), Inters).
intersectie_F_cu_R(Inters):- detR(R), detf(F), intersectieRelatii(F,R,Inters).
detK(K) :- member(K, [b,c,d]), intersectie_F_cu_R(Inters), member((K,_), Inters).

verifAsatepsilon :- multimeaA(A), detR(R), detK(K), detf(F),
    not(( member(X,A), member(Y,A), 
        not(implica(
            (  member((X,K), F), member((K,Y), F), member((K,Y), R)  ), member((X,Y),R))))).

% Exercitiul 4:


fctL2xL2xL2laL3(ListaMorfLatMarg) :- cub(Cub, OrdCub), l3(L3, OrdL3), 
    setof(F, (morflatmarg(F,Cub,OrdCub, L3,OrdL3)), ListaMorfLatMarg).

niciunasurj :- not( (fctL2xL2xL2laL3(ListaMorfLatMarg), l3(L3,_), not(not(surjectiv(ListaMorfLatMarg, L3))))).


% functii random: 
prettyPrint(Lista) :- write("["), prettyPrintAux(0,20,Lista), write("]"), nl.
prettyPrintAux(N, Nmax, L) :- N >= Nmax, !, nl, prettyPrintAux(0,Nmax,L). 
prettyPrintAux(N, Nmax, [H|T]) :- N < Nmax, N1 is N + 1, write(H), write(", "), prettyPrintAux(N1,Nmax,T). 
prettyPrintAux(_, _, []).



% Pregatire examen:

% Ex 1

l2xl3(A,Ord) :- A = [0,1,a,b,c,d], orddinsucc([(0,a),(0,b),(a,c),(b,c),(b,d),(c,1),(d,1)],A,Ord).

l2+l2xl2(A,Ord) :- A = [0,1,u,x,y], orddinsucc([(0,u),(u,x),(u,y),(x,1),(y,1)],A,Ord).

% fctstrcresc(F,P,OrdP,Q,OrdQ).  

fctL2xL3laL2plusL2xL2(Rez) :- l2xl3(A,Ord), l2+l2xl2(B,Ord2), invrel(Ord2, InvOrd2), fctstrcresc(Rez, A, Ord, B, InvOrd2).

niciunainj :- not((fctL2xL3laL2plusL2xL2(Rez), injectiv(Rez))). 
% ca sa dem ca nicio functie nu e injectiva, putem
% demonstra ca nu exista functie care sa fie injectiva.

% Ex 2:

l2_ipoteza1(Alfa, Beta, Gama) :- (Alfa ; implica(Beta,Gama)).

l2_ipoteza2(Alfa, Gama) :- implica(Gama,Alfa).

l2_concluzia(Alfa, Beta) :- implica(Beta,Alfa).

regded :- not( (listaBool( [Alfa,Beta,Gama] ), l2_ipoteza1(Alfa, Beta, Gama),l2_ipoteza2(Alfa, Gama), not(l2_concluzia(Alfa, Beta))) ).
% nu exista nicio evaluare , in care concluzia e falsa (date fiind ipotezele). 

% Ex 3:

l2_multA([a,b,c,d]).

l2_ordinea(Ord) :- l2_multA(A), orddinsucc([(a,b), (b,d)], A, Ord).

l2_posetA(A,Ord) :- l2_ordinea(Ord), l2_multA(A).

dual(Ord, DualOrd) :- invrel(Ord, DualOrd).

l2_getf(F) :- l2_posetA(A,Ord), dual(Ord,OrdDual), 
    fctcresc(F, A, Ord, A, OrdDual), functiebijectiv(F, A, A). % izomorfism de poseturi = fct crescatoare (numita si morfism), si bijectiva
    
l2_getr(R) :- l2_ordinea(Ord), dual(Ord,R).

l2_verifAsatepsilon :- l2_multA(AAA), l2_getf(F), l2_getr(R),
    not( (member(X, AAA), member(Y, AAA), 
        member( (Y, FY), F), member( (FY, FFY), F), member( (X, FX), F),
        member( (X, FY), R), not(not( member( (FX, FFY), R))), write(X), nl, write(Y) ) ).