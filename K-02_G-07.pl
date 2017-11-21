/* Nama File : K02_Alice_vs_Umbrella.pl */
/* Alice vs The Umbrella Corperation */

/*
Anggota kelompok :
	1.
	2.
	3.
	4.
*/

/*Dynamics fact disini itu fact bisa berubah2 seiring berjalan game
*Untuk player position ,look, dll yang berhubungan sama map itu belum bisa dibikin
*/
:- use_module(library(random)).
:- dynamic(player_pos/2, item/2, insidethisplace/4, ingamestate/1, bag/1, health/2, hunger/1, thirsty/1, weapon/1).

/*Inisialisasi game
* 0 = belum mulai permainan atau udah mati, 1 = hidup atau sedang bermain
*/
ingamestate(0).

/***** Deklarasi Fakta *****/
place(0, openfield).
place(1, openfield).
place(2, garden).
place(3, armory).
place(4, openfield).
place(5, forest).
place(6, cave).
place(7, lake).
zombie(kipepo).
zombie(majiniundead).
zombie(uberlicker).
zombie(fenrir).
zombie(scagdead).
zombie(aculeozzo).
zombie(farfarello).
zombie(malacoda).
zombie(cerberus).
zombie(chimera).

/*locationName
* Perhitungan : x mod 5 = 0<=a<=4 , y mod 4 = 0<=b<=3,0<= a+b <=7
* Misal ->  a+b = 1 (openfield), ikuti fakta yang diatas
*/
locationName(X, Y, Place) :- A is X mod 5, B is Y mod 4, N is A+B, place(N, Place).

/* Game loop */
game_loop   :- ingamestate(1),
			repeat,
			write('<command>  '),
			read(X),
			run(X),
			(X==quit), !.

/* Path (from - to)*/
path(Xa,Ya,east,Xb,Yb) :- Xa < 10, Xb is Xa + 1, Yb is Ya,!.
path(Xa,Ya,west,Xb,Yb) :- Xa >= 1, Xb is Xa - 1, Yb is Ya,!.
path(Xa,Ya,north,Xb,Yb) :- Ya < 20, Yb is Ya + 1, Xb is Xa,!.
path(Xa,Ya,south,Xb,Yb) :- Ya >= 1, Yb is Ya - 1, Xb is Xa,!.

/* Basic rules */
isdefined(X,Y) :- X>=0, X<11, Y>=0, Y<21.
islistkosong([]).
isEnemy([]) :- fail.
isEnemy([H|T]) :- zombie(H), !,isEnemy(T).
konso(X,L,[X|L]).
writelist([]):- nl.
writelist([H|T]):- write('> '), write(H),nl,writelist(T).
writeln(X) :- write(X), nl.
isMember(X, [X|_]).
isMember(X, [Y|Z]) :- X\==Y, isMember(X,Z).
delElmt(_,[],[]).
delElmt(X,[X|Xs],Xs).
delElmt(X,[Y|Xs],[Y|Ys]) :- X\==Y, delElmt(X,Xs,Ys).
isLocation(X) :- list(location, List), isMember(X, List).
objectLoc(X, Y) :- list(Y, List), isMember(X, List).

/***** Implementasi run command from input *****/
run(north) :- north, nl,!.
run(east) :- east, nl,!.
run(south) :- south, nl,!.
run(west) :- west, nl,!.
run(look) :- look, nl, !. /* */
run(help) :- help, nl, !. /* */
run(quit) :- quit, nl, !. /* */
run(maps) :- maps, nl,!.
run(take(Obj)) :- take(Obj), nl, !.
run(drop(Obj)) :- drop(Obj), nl, !.
run(use(Obj)) :- use(Obj), nl, !.
run(start) :- start, nl,  !.
run(attack) :- attack, nl, !.
run(status) :- status, nl, !.
run(save(FileName)) :- save(FileName), nl, !.
run(load(FileName)) :- load(FileName), nl, !.

/***** Commands *****/
init_zombies :-
							random(0, 10, Xa), /* random ZOMB1 (position) */
							random(0, 20, Ya),
							random(0, 10, Xb), /* random ZOMB2 (position) */
							random(0, 20, Yb),
							random(0, 10, Xc), /* random ZOMB3 (position) */
							random(0, 20, Yc),
							random(0, 10, Xd), /* random ZOMB4 (position) */
							random(0, 20, Yd),
							random(0, 10, Xe), /* random ZOMB5 (position) */
							random(0, 20, Ye),
							random(0, 10, Xf), /* random ZOMB6 (position) */
							random(0, 20, Yf),
							random(0, 10, Xg), /* random ZOMB7 (position) */
							random(0, 20, Yg),
							random(0, 10, Xh), /* random ZOMB8 (position) */
							random(0, 20, Yh),
							random(0, 10, Xi), /* random ZOMB9 (position) */
							random(0, 20, Yi),
							random(0, 10, Xj), /* random ZOMB10 (position) */
							random(0, 20, Yj),
							retract(insidethisplace(Xa,Ya,_A,Lista)),
							retract(insidethisplace(Xb,Yb,_B,Listb)),
							retract(insidethisplace(Xc,Yc,_C,Listc)),
							retract(insidethisplace(Xd,Yd,_D,Listd)),
							retract(insidethisplace(Xe,Ye,_E,Liste)),
							retract(insidethisplace(Xf,Yf,_F,Listf)),
							retract(insidethisplace(Xg,Yg,_G,Listg)),
							retract(insidethisplace(Xh,Yh,_H,Listh)),
							retract(insidethisplace(Xi,Yi,_I,Listi)),
							retract(insidethisplace(Xj,Yj,_J,Listj)),
							append([majiniundead],Lista,RLista), /*Zombie2*/
							append([kipepo],Listb,RListb),
							append([uberlicker],Listc,RListc),
							append([fenrir],Listd,RListd),
							append([scagdead],Liste,RListe),
							append([aculeozzo],Listf,RListf),
							append([farfarello],Listg,RListg),
							append([malacoda],Listh,RListh),
							append([cerberus],Listi,RListi),
							append([chimera],Listj,RListj),
							asserta(insidethisplace(Xa,Ya,_A,RLista)),
							asserta(insidethisplace(Xb,Yb,_B,RListb)),
							asserta(insidethisplace(Xc,Yc,_C,RListc)),
							asserta(insidethisplace(Xd,Yd,_D,RListd)),
							asserta(insidethisplace(Xe,Ye,_E,RListe)),
							asserta(insidethisplace(Xf,Yf,_F,RListf)),
							asserta(insidethisplace(Xg,Yg,_G,RListg)),
							asserta(insidethisplace(Xh,Yh,_H,RListh)),
							asserta(insidethisplace(Xi,Yi,_I,RListi)),
							asserta(insidethisplace(Xj,Yj,_J,RListj)),
							retract(player_pos(X,Y)),
							asserta(player_pos(Xb,Yb))
							.

init_dynamic_facts(X,Y) :-
									X == 11 ,true.

init_dynamic_facts(X,Y) :-
									X < 11, Y < 20,
									locationName(X,Y,Place),
									item(Place, List),
									asserta(insidethisplace(X,Y,List,[])),
									M is X,
									N is Y + 1,
									init_dynamic_facts(M,N).
init_dynamic_facts(X,Y) :-
									X < 11, Y == 20,
									locationName(X,Y,Place),
									item(Place, List),
									asserta(insidethisplace(X,Y,List,[])),
									M is X + 1,
									N is 0,
									init_dynamic_facts(M,N).

start:- writeln('Welcome to Alice vs Umbrella Corp.!'),
		writeln('White Queen Kingdom has been invaded by Umbrella Corp.!'),
		writeln('Help Alice to defeat the invaders!'),
		help,
		restartgame,
		random(0, 10, X), /*random Alice (X position)*/
 		random(0, 20, Y), /*random Alice (Y position)*/
		asserta(player_pos(X,Y)),
		asserta(health(alice,100)),
		asserta(health(majini_Undead,80)),
		asserta(health(kipepo,50)),
		asserta(health(uberlicker,50)),
		asserta(health(fenrir,60)),
		asserta(health(scagdead,60)),
		asserta(health(aceleozzo,50)),
		asserta(health(farfarello,40)),
		asserta(health(malacoda, 30)),
		asserta(health(cerberus,35)),
		asserta(health(chimera,40)),
		asserta(hunger(100)),
		asserta(thirsty(100)),
		asserta(weapon([])),
		asserta(bag([])),
		asserta(item(lake,[waterpouch, meat, axe])),
		asserta(item(openfield,[])),
		asserta(item(armory,[sword, medicine])),
		asserta(item(garden,[hoe,banana])),
		asserta(item(forest,[pig,honey])),
		asserta(item(cave,[bandage,spear])),
		init_dynamic_facts(0,0),
		init_zombies,
		retract(ingamestate(_)),
		asserta(ingamestate(1)),
		game_loop.

restartgame :-
		retract(ingamestate(_A)),
		asserta(ingamestate(0)),
		retract(insidethisplace(_R,_T,_U,_V)),
		retract(player_pos(_X,_Y)),
		retract(bag(_C)),
		retract(health(_K,_D)),
		retract(hunger(_E)),
		retract(thirsty(_F)),
		retract(weapon(_G)), !.
		restartgame.

prio(X,Y) :- \+isdefined(X,Y),
							write('#'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList), isEnemy(EList),
  						write('E'),!.
prio(X,Y) :-insidethisplace(X,Y,List,EList) , islistkosong(List), player_pos(M,N),
							M == X, N == Y,
							write('A'),!.
prio(X,Y) :-insidethisplace(X,Y,List,EList) , islistkosong(List),
							write('-'),!.
prio(X,Y) :-insidethisplace(X,Y,List,EList),
						isMember(medicine,List),
						write('M'),!.
prio(X,Y) :-insidethisplace(X,Y,List,EList),
							isMember(bandage,List),
						write('M'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList),
							isMember(meat,List),
						write('F'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList),
						isMember(banana,List),
						write('F'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList),
							isMember(pig,List),
						write('F'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList),
						isMember(waterpouch,List),
						write('W'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList),
						isMember(honey,List),
						write('W'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList),
						isMember(spear,List),
						write('@'),!.
prio(X,Y) :- insidethisplace(X,Y,List,EList),
						isMember(axe,List),
						write('@'),!.
prio(X,Y) :- player_pos(A,B),
						X==A,
						Y==B,
						write('A').

/* 		asserta(item(lake,[waterpouch, meat, axe])),
		asserta(item(openfield,[])),
		asserta(item(armory,[sword, medicine])),
		asserta(item(garden,[hoe,banana])),
		asserta(item(forest,[pig,honey])),
		asserta(item(cave,[bandage,spear])), */

		/* Skala prioritas penampilan peta: Enemy > Medicine > Food > Water > Weapon >
pemain. */

look :- ingamestate(1),
		player_pos(X, Y),
		locationName(X, Y, Place),
		insidethisplace(X,Y,List,EList),
		A is X - 1,
		B is X,
		C is X + 1,
		D is Y - 1,
		E is Y,
		F is Y + 1,
		write('  '), prio(A,F),
		write('  '), prio(B,F),
		write('  '), prio(C,F),nl,
		write('  '), prio(A,E),
		write('  '), prio(B,E),
		write('  '), prio(C,E),nl,
		write('  '), prio(A,D),
		write('  '), prio(B,D),
		write('  '), prio(C,D),nl,
		writelist(EList),
		write('You are in '), write(Place), nl,
		writeln('Items in this place is/are '), writelist(List),!.

help :- writeln('These are the available commands:'),
		writeln('- start.          = start the game.'),
		writeln('- north. east. west. south.     = go to somewhere (follow compass rules).'),
		writeln('- look.           = look things around you.'),
		writeln('- help.           = see available commands.'),
		writeln('- maps.           = show map if you have one.'),
		writeln('- take(Obj).      = pick up an object.'),
		writeln('- drop(Obj).      = drop an object.'),
		writeln('- use(Obj)        = use an object.'),
		writeln('- attack.         = attack enemy that accross your path.'),
		writeln('- status.         = display Alice status.'),
		writeln('- save(FileName). = save your game.'),
		writeln('- load(FileName). = load previously saved game.'),
		writeln('- quit.           = quit the game.'),
		writeln('Legends : '),
		writeln('W = Water'),
		writeln('M = Medicine'),
		writeln('F = Food'),
		writeln('@ = Weapon'),
		writeln('A = Alice'),
		writeln('E = Enemy'),
		writeln('# = Inaccesible'),
		writeln('- = Accesible').

maps :- write('').

take(Obj) :- write('').

drop(Obj) :- write('').

use(Obj) :- write('').

attack	:- write('').

status :- ingamestate(1),
		weapon(WeaponList),
		health(alice,HP),
		thirsty(T),
		bag(BagList),
		write('Health    = '), writeln(HP),
		write('Thirsty   = '), writeln(T),
		writeln('Weapon    = '), writelist(WeaponList),
		writeln('Inventory = '), writelist(BagList),!.

save(FileName) :- write('').

loads(FileName) :- write('').

quit :- write('Alice gives up to the zombies. Game over.'), halt.

/*go_to another place with direction*/

go(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			path(Xa,Ya, Direction,Xb,Yb),nl,
			write('You moved to the '), writeln(Direction),
			retract(player_pos(Xa,Ya)),
			asserta(player_pos(Xb,Yb)),
			look, !.

go(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			\+path(Xa,Ya, Direction,Xb,Yb),
			write('Alice, you cannot go there!. Please return to your last location!.'),!.

go(_) :- ingamestate(1),
			writeln('Your inputs wrong. Undefined!.'), !.

go(_) :- ingamestate(0),
			writeln('You must start the game first!').

north :- go(north).
south :- go(south).
west :- go(west).
east :- go(east).
