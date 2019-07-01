:-use_module(library(clpfd)),use_module(library(lists)).

/*
-1 -> Black Queen
0 -> Free place
1 -> White Queen

Mat -> matrix for showing positions of black and white queens on chessboard
Dim -> Dimimension or Size of chessboard
N -> Maximum possible equal number of queens from black and white army of queens placed on chessboard
*/
queens(Mat,Dim,N):-
	Dim > 2,
	
	Ls is Dim*Dim,
	length(Sol, Ls), 
    N #> 0, N #< Ls/4,
	
	domain(Sol, -1,1),
	list_to_matrix(Sol, Dim, Mat),
	
	row(Mat, 1, Row1),
	domain(Row1, -1, 0),

	column(Mat, 1, Col1), 
	domain(Col1, -1, 0),
	
	row(Mat, Dim, RowDim), 
	domain(RowDim, 0, 1),
	
	column(Mat, Dim, ColDim), 
	domain(ColDim, 0, 1),
	
	diag(Mat, Dimiag, 0, Dim),
	domain(Dimiag, 0, 1),
	
	nth1(Dim, RowDim, LRow), 
	LRow is 1,
	
	global_cardinality(Sol, [-1-N, 1-N, 0-_]),
	
	check_rows(Mat), 
	transpose(Mat, B),
	check_rows(B),
	
	diag_to_list(Mat, X1, Dim), 
	check_rows(X1),
	
	matrix_reverse(Mat, C),
	
	diag_to_list(C, X2, Dim), 
	check_rows(X2),
	
	labeling([maximize(N), ffc],Sol).
	
	


/* checking global_cardinality condition for each list in the list */
check_rows([]).
check_rows([H | T]) :- global_cardinality(H, [1-N1,0-_,-1-N2]), (N1#=0 #\/ N2#=0), check_rows(T).
	
/* Transforming a list to a matrix */
list_to_matrix([], _, []).
list_to_matrix(List, Size, [Row|Matrix]):-
											list_to_matrix_row(List, Size, Row, Tail),
											list_to_matrix(Tail, Size, Matrix).
	
list_to_matrix_row(Tail, 0, [], Tail).
list_to_matrix_row([Item|List], Size, [Item|Row], Tail):-
															NSize is Size-1,
															list_to_matrix_row(List, NSize, Row, Tail).
	
/*outputs a list of lists with the diagonals from upper left to bottom right*/
diag_to_list(M, X, Dim) :- 
						transpose(M, T),
						diag_list(M, X1, 0, Dim),
						diag_list(T, X2, 0, Dim),
						concat(X1, X2, X3),
						removehead(X3, X).

removehead([H | T], T).
getfirstelement([H |  T], H).

diag_list([],[],_,_).
diag_list([H | T], X, Z, Dim) :-
								A is Z+1,
								(Z < Dim -> diag([H | T], X1, Z, Dim)), 
								(A < Dim-1 -> diag_list([H | T], X2, A, Dim); concat([], [], X2)),
								concat([X1], X2, X).

/*Outputs a list with the diagonal, starting with the Yth element from the 1st row from upper left to bottom right */
diag([],[],_,_).	
diag([H | T], X, Z, Dim) :-
	A is Z+1,
	(Z < Dim -> nth0(Z, H, Mat)),
	(A < Dim -> diag(T, Y, A, Dim); concat([], [], Y)),
	concat([Mat], Y, X).

/* the matrix in the middle 1st column <-> nth column, 2nd column <-> n-1th column*/
matrix_reverse(Y, X) :- transpose(Y,W), revert1(W,V), transpose(V,X).

concat([],L,L).
concat([H|T],L2,[H|NewT]):- concat(T,L2,NewT).

revert1(List,Rev):- rev(List,[],Rev).
rev([],L,L).
rev([H|T],Rest,Rev):- rev(T,[H|Rest],Rev).

/* getting Nth row from M matrix */
row(M, N, Row) :- nth1(N, M, Row).
/* getting Nth Col from M matrix */
column(M, N, Col) :- transpose(M, MT), row(MT, N, Col).