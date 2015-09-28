
% predicate merge (arity 3) merges two ordered lists (first two arguments) into a single ordered list (third argument).
merge([],L1,L1).
merge(L1,[],L1).
merge([H1|T1], [H2|T2], L1) :- 
    	H1 < H2 -> L1 = [H1|Y], merge(T1,[H2|T2],Y) ;
    	H1 > H2 -> L1 = [H2|Y], merge([H1|T1],T2,Y) ;
    	L1 = [H1|R], merge(T1,T2,Y).

% predicate search (arity 3) searches for a member in a list and returns its position in the list.
search([X|_],X,1).
search([H|T],X,Z):-
	search(T,X,Zi),
	Z is Zi + 1.

% predicate least (arity 2) finds the smallest number in a list of numbers.
leasthelp(X, Y, X) :-
  (X =< Y).
leasthelp(X, Y, Y) :-
  (Y < X).
least([H|[]], H).
least([H|T], X) :-
  least(T,Y),
  leasthelp(Y,H,X).
	

% This is exercise 2.4 on page 32 of Learn Prolog Now! by Patrick Blackburn, Johan Bos,
% and Kristina Striegnitz. The predicate crosswd/6 that tells us how to fill the grid;
% the first three arguments, V1, V2 and V3 are the vertical words from left to right
% and the following three arguments H1, H2 and H3 are the horizontal words from top to bottom.

word(abalone,a,b,a,l,o,n,e).
word(abandon,a,b,a,n,d,o,n).
word(enhance,e,n,h,a,n,c,e).
word(anagram,a,n,a,g,r,a,m).
word(connect,c,o,n,n,e,c,t).
word(elegant,e,l,e,g,a,n,t).

crosswd(V1,V2,V3,H1,H2,H3):-
word(H1,_,TL,_,TM,_,TR,_),
word(H2,_,ML,_,MM,_,MR,_),
word(H3,_,BL,_,BM,_,BR,_),
word(V1,_,TL,_,ML,_,BL,_),
word(V2,_,TM,_,MM,_,BM,_),
word(V3,_,TR,_,MR,_,BR,_).
