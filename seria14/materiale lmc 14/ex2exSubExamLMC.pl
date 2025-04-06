/* Consider izomorfismul boolean f:L2->{false,true}, f(0)=false si f(1)=true.
Fie h:V->L2={0,1} interpretare arbitrara, iar h~:E->L2 unica prelungire a lui h la E care
transforma conectorii logici (de pe E) in operatii booleene (in L2).
Cum am procedat la lectii, consider compunerile foh:V->{false,true}, foh~:E->{false,true}.
Voi reprezenta satisfacerea, deductia semantica si faptul de a fi adevar semantic prin |=.
Asadar, pentru un enunt epsilon, o multime de enunturi Sigma, si interpretarea h, avem:
h|=epsilon  <=> h~(epsilon)=1 <=> f(h~(epsilon))=true
|=epsilon <=> (pentru orice g:V->L2)(g|=epsilon) <=> (pentru orice g:V->L2)(g~(epsilon)=1)
	<=> (pentru orice g:V->L2)(f(g~(epsilon))=true)
Sigma|=epsilon <=> (pentru orice g:V->L2)(g|=Sigma => g|=epsilon) <=> 
(pentru orice g:V->L2)((pentru orice enunt sigma din Sigma)(g~(sigma)=1) => g~(epsilon)=1)
<=> (pentru orice g:V->L2)((pentru orice enunt sigma din multimea Sigma)(f(g~(sigma))=true)
	 => f(g~(epsilon))=true)
Vom reprezenta prin urmatoarele variabile in Prolog, unde alfa, beta, teta sunt enunturile
din exercitiu: P=f(h(p)), Q=f(h(q)), Alfa=f(h~(alfa)), Beta=f(h~(beta)), iar Teta=f(h~(teta))
va avea intotdeauna valoarea true, intrucat, conform teoremei de completitudine, |=teta. */

:- [lab6lmc1].

enuntulIpoteza(Q,Beta) :- echiv(implica(true,Q), Beta).

ipoteza(Alfa,Beta,P,Q) :- implica((Alfa,P), enuntulIpoteza(Q,Beta)).

enuntulConcluzie(Alfa,Beta,P,Q) :- implica((Alfa,Beta),implica(P,Q)).

cerinta(Alfa,Beta,P,Q) :- implica(ipoteza(Alfa,Beta,P,Q),enuntulConcluzie(Alfa,Beta,P,Q)).

demCerinta :- not((nuplu([Alfa,Beta,P,Q]), not(cerinta(Alfa,Beta,P,Q)))).


 





