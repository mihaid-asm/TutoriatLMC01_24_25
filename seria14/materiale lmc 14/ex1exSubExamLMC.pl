/* Determinam morfismele de latici marginite f:L2xL2+L2->N5.
Sa ne amintim ca: o functie intre doua latici e morfism de latici <=> e crescatoare si 
pastreaza disjunctia si conjunctia perechilor de elemente incomparabile.
In L2xL2+L2, singura pereche de elemente incomparabile este perechea a,b. Asadar:
f:L2xL2+L2->N5 este morfism de latici marginite <=> f(0)=0, f(1)=1, f e crescatoare (i.e.
intrucat 0<=a<=c<=1 si 0<=b<=c<=1 in L2xL2+L2, rezulta ca f(0)<=f(a)<=f(c)<=f(1) si 
f(0)<=f(b)<=f(c)<=f(1) in N5) si f(avb)=f(a)vf(b), f(a^b)=f(a)^f(b) (pt. studentul 
nevazator: f(a sau b) = f(a) sau f(b), f(a si b) = f(a) si f(b)).
Fie, asadar, f:L2xL2+L2->N5 un morfism de latici marginite. Avem f(0)=0 si f(1)=1. Vom
imparti pe cazuri dupa valorile lui f(c) in N5 si vom determina pe f(a) si f(b) din faptul
ca in L2xL2+L2 avem: avb=c si a^b=0 (a sau b = c, a si b = 0), prin urmare: 
f(a)vf(b)=f(avb)=f(c) si f(a)^f(b)=f(a^b)=f(0)=0 (f(a) sau f(b) = f(a sau b) = f(c),
f(a) si f(b) = f(a si b) = f(0) = 0).
CAZ 1: f(c)=0.
Atunci, cum f(a)<=f(c)>=f(b), rezulta ca f(a)<=0>=f(b), asadar f(a)=0=f(b).
Am obtinut functia:
  x | 0 a b c 1
---------------
f(x)| 0 0 0 0 1
f e crescatoare, pastreaza pe 0 si 1 si disjunctia si conjunctia perechii a,b, asadar f e,
intr-adevar, morfism de latici marginite. La fel mai jos (si urmatoarele 12 functii astfel
determinate sunt morfisme de latici marginite).
CAZ 2: f(c)=x.
Atunci f(a)vf(b)=x si f(a)^f(b)=0  (f(a) sau f(b) = x, f(a) si f(b) = 0), asadar perechea
(f(a),f(b)) apartine multimii {(0,x),(x,0)}. Am obtinut functiile:
  x | 0 a b c 1
---------------
f(x)| 0 0 x x 1
f(x)| 0 x 0 x 1
CAZ 3: f(c)=y.
Atunci f(a)vf(b)=y si f(a)^f(b)=0  (f(a) sau f(b) = y, f(a) si f(b) = 0), asadar perechea
(f(a),f(b)) apartine multimii {(0,y),(y,0)}. Am obtinut functiile:
  x | 0 a b c 1
---------------
f(x)| 0 0 y y 1
f(x)| 0 y 0 y 1
CAZ 4: f(c)=z.
Atunci f(a)vf(b)=z si f(a)^f(b)=0  (f(a) sau f(b) = z, f(a) si f(b) = 0), iar f(a)<=z>=f(b),
asadar f(a),f(b) apartin multimii {0,y,z}, prin urmare f(a) si f(b) sunt comparabile, deci
f(a)vf(b)=max{f(a),f(b)} si 0=f(a)^f(b)=min{f(a),f(b)} (f(a) sau f(b) = max{f(a),f(b)},
0 = f(a) si f(b) = min{f(a),f(b)}), prin urmare, la fel ca in cazurile 2 si 3, unul dintre
membrii perechii (f(a),f(b)) este egal cu 0, iar celalalt este egal cu f(c), deci cu z in 
acest caz, asadar perechea (f(a),f(b)) apartine multimii {(0,z),(z,0)}. Am obtinut 
functiile:
  x | 0 a b c 1
---------------
f(x)| 0 0 z z 1
f(x)| 0 z 0 z 1
CAZ 5: f(c)=1.
Atunci f(a)vf(b)=1 si f(a)^f(b)=0  (f(a) sau f(b) = 1, f(a) si f(b) = 0), prin urmare
f(a) si f(b) sunt complemente unul altuia in N5, asadar perechea (f(a),f(b)) apartine 
multimii: {(0,1),(1,0),(x,y),(y,x),(x,z),(z,x)}. Am obtinut functiile:
  x | 0 a b c 1
---------------
f(x)| 0 0 1 1 1
f(x)| 0 1 0 1 1
f(x)| 0 x y 1 1
f(x)| 0 y x 1 1
f(x)| 0 x z 1 1
f(x)| 0 z x 1 1
Cele 13 functii de mai sus sunt morfismele de latici marginite de la L2xL2+L2 la N5. */

:- [lab5lmc1].

l2xl2plusl2(A,Ord) :- A=[0,a,b,c,1], orddinsucc([(0,a),(0,b),(a,c),(b,c),(c,1)],A,Ord).

n5(A,Ord) :- A=[0,x,y,z,1], orddinsucc([(0,x),(x,1),(0,y),(y,z),(z,1)],A,Ord).

morfL2xL2plusL2laN5(ListaMorfisme) :- l2xl2plusl2(A,OrdA), n5(B,OrdB), 
	morfismelelatmarg(A,OrdA,B,OrdB,ListaMorfisme), scrielista(ListaMorfisme), 
	length(ListaMorfisme,NrMorfisme), nl, write(NrMorfisme), write(' morfisme'), nl.



