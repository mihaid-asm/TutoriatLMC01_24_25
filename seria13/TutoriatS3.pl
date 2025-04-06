/* distanta dintre un punct de coordonate (A,B) si un punct (C,D)*/
distanta((A,B), (C,D), X) :- X is sqrt((C-A) ** 2 + (D-B) ** 2).

/* cazurile de baza in primele 2 linii, iar apoi cazul recursiv */
fib(0,1).
fib(1,1).
fib(N,X) :- N1 is N-1, N2 is N-2, fib(N1, X1), fib(N2, X2), X is X1 + X2.

/* predicat ajutator care afiseaza o linie */
line(0, _) :- write('').
line(1, C) :- write(C).
line(N, C) :- write(C), write(' '), N1 is N-1, line(N1,C).

/* predicat ajutator care afiseaza patratul */
square(0, '', 0).
square(1, C, X) :- line(X,C).
square(N, C, X) :- line(X,C), nl, N1 is N-1, square(N1, C, X).

/* predicat care afiseaza patratul respectand parametrii */
sqrok(N,C) :- square(N,C,N).

/* verifica daca primul parametru este in lista din al 2-lea parametru */
element_of(_, []) :- false. /* daca lista e vida, predicatul e false */
element_of(X, [H|_]) :- X == H. /* daca X este primul element da true */
element_of(X, [_|T]) :- element_of(X, T). /* daca X este in coada da true */

/* concat(A,B,C) unde C este concatenarea lui A cu B */
concat_list([], [], []).
concat_list(A, [], A).
concat_list([], B, B).
concat_list([HA|A], B, [HA|D]) :- concat_list(A, B, D).

/* traduce o lista de a-uri in b-uri ([a,a,a] -> [b,b,b]) */
trans_a_b([], []).
trans_a_b([a|TA], [b|TB]) :- trans_a_b(TA, TB).

/* scalarMult(M, [L1,L2,L3], R) :- R = [M*L1, M*L2, M*L3] */
scalarMult(_, [], []).
scalarMult(X, [HA|TA], [HB|TB]) :- HB is X * HA, scalarMult(X, TA, TB).

/* determina maximul dintr-o lista */
max([X], X).
max([HA|TA], X) :- max(TA, Y), HA < Y, X is Y.
max([HA|TA], X) :- max(TA, Y), HA >= Y, X is HA.
