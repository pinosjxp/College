/* room(Room,Plume,Puffs,Guest). */
roomList([room(_,_,6,_),room(_,_,7,_),room(_,_,8,_),room(_,_,9,_),room(_,_,10,_)]).
solution(A) :-  roomList(A),
		member(room(den,_,_,pedro),A),
		member(room(_,_,8,daniela),A),
		member(room(livingroom,mysteryglen,_,_),A),
		member(room(_,desertflora,7,_),A),
		member(room(_,papayaparadise,Y,_),A),
		member(room(_,_,X,renee),A),X=:=Y-1,
		member(room(bathroom,_,W,_),A),W=:=Y+1,
		member(room(_,sweetbreeze,M,_),A),
		member(room(kitchen,_,N,_),A),N=:=M-1,
		member(room(_,_,O,tina),A),
		M<O,
		member(room(_,_,_,keith),A),
		member(room(diningroom,_,_,_),A),
		member(room(_,summerjoy,_,_),A).
