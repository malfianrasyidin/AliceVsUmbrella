/* Nama File : K02_G_07.pl */
/* Alice vs The Umbrella Corperation */

/*
Anggota kelompok :
	1. Hafizh Budiman
	2. Ivan Jonathan
	3. M. Alfian
	4. Seperayo
*/

/*Dynamics fact disini itu fact bisa berubah2 seiring berjalan game
*Untuk player position ,look, dll yang berhubungan sama maps itu belum bisa dibuat
* Catatan : win/ 1 untuk menentukan siapa pemenang game ini, (1 = Alice, 0 = Umbrella Corp, -1 = Belum ada yang menang/Game masih berjalan)
*/
:- use_module(library(random)).
:- dynamic(kills/1 ,win/1, player_pos/2, item/2, insidethisplace/4, ingamestate/1, bag/1, health/1, hunger/1, thirsty/1, weapon/1, enemypower/2, countstep/1).

/*Inisialisasi game
* 0 = belum mulai permainan atau udah mati, 1 = hidup atau sedang bermain
*/
ingamestate(0).

/* Deklarasi Fakta */
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
isfood(meat).
isfood(banana).
isfood(pig).
isweapon(axe).
isweapon(hoe).
isweapon(spear).
isweapon(sword).
isdrink(waterpouch).
isdrink(honey).
ismedicine(medicine).
ismedicine(bandage).

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
			(checkWinner ; X==quit), !, halt.

/* Path (from - to)*/
path(Xa,Ya,east,Xb,Yb) :- Xa < 10, Xb is Xa + 1, Yb is Ya,!.
path(Xa,Ya,west,Xb,Yb) :- Xa >= 1, Xb is Xa - 1, Yb is Ya,!.
path(Xa,Ya,north,Xb,Yb) :- Ya >= 1 , Yb is Ya - 1, Xb is Xa,!.
path(Xa,Ya,south,Xb,Yb) :- Ya < 20 , Yb is Ya + 1, Xb is Xa,!.

/* Basic rules */
checkWinner :- kills(X), X == 1, writeln('Hooray!!.. Good job, Alice! All the zombies are down.'),!,halt.
checkWinner :- win(X), X == 0, writeln('Oh no! Alice is exhausted and can\'t move again!.. White Kingdom is fully occupied by Umbrella corp, Game over!.'),!.
checkWinner :- win(X), X == 1, writeln('Hooray!!.. Good job, Alice! All the zombies are down.'),!,halt.
writeifenemynearby([]) :- true,!.
writeifenemynearby(List) :- isEnemy(List), write(' and there is an enemy here.. Watch out!!').
isdefined(X,Y) :- X>=0, X<11, Y>=0, Y<21.
islistkosong([]).
isEnemy([]).
isEnemy([H|T]) :- zombie(H), isEnemy(T).
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
count([],0).
count([_|Tail], N) :- count(Tail, N1), N is N1 + 1.

/***** Implementasi run command from input *****/
run(north) :- north, nl,!.
run(east) :- east, nl,!.
run(south) :- south, nl,!.
run(west) :- west, nl,!.
run(look) :- look, nl, !. /* predikat untuk melihat posisi sekitar */
run(help) :- help, nl, !. /* predikat yang memberikan petunjuk game*/
run(quit) :- quit, nl, !. /* predikat yang menyebabkan game berakhir */
run(maps) :- maps, nl,!.
run(take(Obj)) :- take(Obj), nl, !.
run(drop(Obj)) :- drop(Obj), nl, !.
run(use(Obj)) :- use(Obj), nl, !.
run(start) :- start, nl,  !.
run(attack) :- attack, nl, !.
run(status) :- status, nl, !.
run(save(FileName)) :- save(FileName), nl, !.
run(loads(FileName)) :- loads(FileName), nl, !.

/***** Commands *****/
init_zombies :-
												player_pos(X,Y),
							retract(insidethisplace(X,Y,_A,Lista)),
							append([majiniundead],Lista,RLista), /*Zombie2*/
							asserta(insidethisplace(X,Y,_A,RLista)).

init_dynamic_facts(X,Y) :-
									X == 11, Y >= 0, true.

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
		asserta(health(100)),
		asserta(win(-1)),
		asserta(countstep(0)),
		asserta(enemypower(majiniundead,30)),
		asserta(enemypower(kipepo,10)),
		asserta(enemypower(uberlicker,14)),
		asserta(enemypower(fenrir,23)),
		asserta(enemypower(scagdead,32)),
		asserta(enemypower(aculeozzo,6)),
		asserta(enemypower(farfarello,20)),
		asserta(enemypower(malacoda, 23)),
		asserta(enemypower(cerberus,15)),
		asserta(enemypower(chimera,20)),
		asserta(hunger(100)),
		asserta(thirsty(100)),
		asserta(weapon([])),
		asserta(bag([axe])),
		asserta(item(lake,[waterpouch, meat, axe])),
		asserta(item(openfield,[])),
		asserta(item(armory,[sword, medicine])),
		asserta(item(garden,[hoe,banana])),
		asserta(item(forest,[pig,honey])),
		asserta(item(cave,[bandage,spear])),
		init_dynamic_facts(0,0),
		init_zombies,
		asserta(kills(0)),
		retract(insidethisplace(X,Y,_AddRadar,_EL)),
		append([radar], _AddRadar, _AddRadar2),
		asserta(insidethisplace(X,Y,_AddRadar2,_EL)),
		retract(ingamestate(_)),
		asserta(ingamestate(1)),
		game_loop.

restartgame :-
		retract(kills(_P)),
		retract(enemypower(_YY,_TT)),
		retract(ingamestate(_A)),
		asserta(ingamestate(0)),
		retract(insidethisplace(_R,_T,_U,_V)),
		retract(player_pos(_X,_Y)),
		retract(bag(_C)),
		retract(win(_M)),
		retract(countstep(_S)),
		retract(health(_K)),
		retract(hunger(_E)),
		retract(thirsty(_F)),
		retract(weapon(_G)), !.
		restartgame.

prio(X,Y) :- \+isdefined(X,Y),
							write('#'),!.
prio(X,Y) :- insidethisplace(X,Y,_,EList), \+islistkosong(EList), isEnemy(EList),
  						write('E'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_) , islistkosong(List), player_pos(M,N),
							M == X, N == Y,
							write('A'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_) , islistkosong(List),
							write('-'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_),
						isMember(medicine,List),
						write('M'),!.
prio(X,Y) :-insidethisplace(X,Y,List,_),
							isMember(bandage,List),
						write('M'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
							isMember(meat,List),
						write('F'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(banana,List),
						write('F'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
							isMember(pig,List),
						write('F'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(waterpouch,List),
						write('W'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(honey,List),
						write('W'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(spear,List),
						write('@'),!.
prio(X,Y) :- insidethisplace(X,Y,List,_),
						isMember(axe,List),
						write('@'),!.
prio(X,Y) :- player_pos(A,B),
						X==A,
						Y==B,
						write('A').

printmap(_,Y) :- Y == 21 , nl, player_pos(R,T), write('Your location is ('), write(R), write(',') , write(T), writeln('). Relative to the top left corner which is (0,0)'), true.

printmap(X,Y) :- X < 11, Y < 21,
						write(' '), prio(X,Y), write(' '),
						M is X+1,
						N is Y,
						printmap(M,N).
printmap(X,Y) :-
						X == 10, Y < 21,
						write(' '), prio(X,Y) , nl,
						M is 0,
						N is Y+1,
						printmap(M,N).

/* Skala prioritas penampilan peta: Enemy > Medicine > Food > Water > Weapon > Player. */
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
		write('  '), prio(A,D),
		write('  '), prio(B,D),
		write('  '), prio(C,D),nl,
		write('  '), prio(A,E),
		write('  '), prio(B,E),
		write('  '), prio(C,E),nl,
		write('  '), prio(A,F),
		write('  '), prio(B,F),
		write('  '), prio(C,F),nl,
		write('You are in '), write(Place), writeifenemynearby(EList), nl,
		writeln('Items in this place is/are '), writelist(List),!.

help :- writeln('These are the available commands:'),
		writeln('- start.          = start the game.'),
		writeln('- north. east. west. south. = go to somewhere (follow compass rules).'),
		writeln('- look.           = look things around you.'),
		writeln('- help.           = see available commands.'),
		writeln('- maps.           = show map if you have one.'),
		writeln('- take(Obj).      = pick up an object.'),
		writeln('- drop(Obj).      = drop an object.'),
		writeln('- use(Obj)        = use an object.'),
		writeln('- attack.         = attack enemy that accross your path.'),
		writeln('- status.         = display Alice status.'),
		writeln('- save(FileName). = save your game.'),
		writeln('- loads(FileName).= load previously saved game.'),
		writeln('- quit.     = quit the game.'),
		writeln('Legends : '),
		writeln('W = Water'),
		writeln('M = Medicine'),
		writeln('F = Food'),
		writeln('@ = Weapon'),
		writeln('A = Alice'),
		writeln('E = Enemy'),
		writeln('# = Inaccesible'),
		writeln('- = Accesible').

maps :-	ingamestate(1),bag(ListItem), isMember(radar, ListItem),printmap(0,0),!.
maps :- ingamestate(1),bag(ListItem),\+isMember(radar,ListItem),writeln('There is no radar in your bag. Try to find the radar to see full maps!'),!.

/* Describe object that is taken by Alice */

desc(Obj) :- Obj == medicine,
			writeln('While particularly ordinary, this medicine can quickly mend even the deepest of wounds.'),
			writeln('Ability : Restore Alice''s health (+4HP) when used.').

desc(Obj) :- Obj == bandage,
			writeln('An essential things that aids you to survive this mess.'),
			writeln('Ability : Restore Alice''s health (+4HP) when used.').

desc(Obj) :- Obj == banana,
			writeln('It''s a banana, what do you expect anyway. Peel it and just eat it.'),
			writeln('Ability : Gain 2 hunger points when consumed.').

desc(Obj) :- Obj == meat,
			writeln('An ordinary Japanese kobe beef, except the taste is not.'),
			writeln('Ability : Gain 2 hunger points when consumed.').

desc(Obj) :- Obj == pig,
			writeln('A black Iberian pork. You know how expensive it is, don''t you?.'),
			writeln('Ability : Gain 2 hunger points when consumed.').

desc(Obj) :- Obj == axe,
			writeln('The bearer of this mighty axe gains the ability to cut down enemiy at one swing.'),
			writeln('Ability : Slay zombie with one swing.').

desc(Obj) :- Obj == spear,
			writeln('A spear of sharpened rock blades imbued with magical fire.'),
			writeln('Ability : Shattered zombie when thrown.').

desc(Obj) :- Obj == sword,
			writeln('Only the mightiest and most experienced of warriors can wield this relic sword.'),
			writeln('Ability : Demolish zombie with one swing.').

desc(Obj) :- Obj == waterpouch,
			writeln('An old waterpouch made from cattle skin.'),
			writeln('Ability : Gain 2 thirst points when drinked.').

desc(Obj) :- Obj == honey,
			writeln('Sweet.'),
			writeln('Ability : Gain 2 hunger points when consumed.').

desc(Obj) :- Obj == radar,
			writeln('Grants the ability to see every items and zombies').

/* Take object from where you are, and put it in backpack, max item in backpack = 4 */

take(Obj) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total < 4,
						player_pos(X, Y),
						locationName(X, Y, _),
						insidethisplace(X,Y,List,_),
						isMember(Obj,List),
						retract(insidethisplace(X,Y,List,_)),
						retract(bag(BagList)),
						delElmt(Obj,List,ListNew),
						append([Obj],BagList,BagListNew),
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,_)), nl,
						write('You have succesfully taken a '), write(Obj) , nl,
						desc(Obj), !.

take(Obj) :- ingamestate(1),
						player_pos(X, Y),
						insidethisplace(X,Y,List,_),
						\+isMember(Obj,List), nl,
						writeln('What are you, drunk? Alice? That item''s not even here, you can''t just take it outta nowhere.').

take(_) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total==4,
						write('Alice, you gonna need a bigger bag to take that,'), nl,
						write('or you could simply drop something first before taking it.'), nl, !.

/* Drop object from your backpack to the place */

drop(Obj) :- ingamestate(1),
						bag(BagList),
						isMember(Obj,BagList),
						count(BagList,Total),
						Total > 0,
						player_pos(X, Y),
						insidethisplace(X,Y,List,_),
						retract(insidethisplace(X,Y,List,_)),
						retract(bag(BagList)),
						delElmt(Obj,BagList,BagListNew),
						append([Obj],List,ListNew),
						asserta(bag(BagListNew)),
						asserta(insidethisplace(X,Y,ListNew,_)), nl,
						write('You have succesfully dropped your '), write(Obj) , nl, !.

drop(Obj) :- ingamestate(1),
						bag(BagList),
						\+isMember(Obj,BagList), nl,
						writeln('Stop hallucinating, Alice. You don''t have that thing in your backpack.'),nl,!.

drop(_) :- ingamestate(1),
						bag(BagList),
						count(BagList,Total),
						Total==0,
						write('You don''t have anything in your backpack.'), nl, !.

use(Obj) :- bag(BagList),
						isfood(Obj),
						isMember(Obj, BagList),
						hunger(H),
						H == 100,nl,
						writeln('Alice : Hmmm, I can\'t take another bite'),!.

use(Obj) :- bag(BagList),
						isfood(Obj),
						isMember(Obj, BagList),
						hunger(H),
						H < 100,
						_NewH is H + 2,
						_NewH > 100,
						delElmt(Obj, BagList, NBagList),
						retract(hunger(_OldH)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(hunger(100)),nl,
						write('Alice eats '), write(Obj), nl,
						writeln('Yummyy! :)'),!.

use(Obj) :- bag(BagList),
						isfood(Obj),
						isMember(Obj, BagList),
						hunger(H),
						H < 100,
						_NewH is H + 2,
						delElmt(Obj, BagList, NBagList),
						retract(hunger(_OldH)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(hunger(_NewH)),nl,
						write('Alice eats '), write(Obj), nl,
						writeln('Yummyy! :)'),!.

use(Obj) :- bag(BagList),
						isdrink(Obj),
						isMember(Obj, BagList),
						thirsty(T),
						T == 100,nl,
						writeln('Alice : No, i\'am not thirsty'),!.

use(Obj) :- bag(BagList),
						isdrink(Obj),
						isMember(Obj, BagList),
						thirsty(T),
						T < 100,
						_NewT is T + 2,
						_NewT > 100,
						delElmt(Obj, BagList, NBagList),
						retract(thirsty(_OldT)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(thirsty(100)),nl,
						write('Alice drinks '), write(Obj), nl,
						writeln('Sluuurrpp! :)'),!.

use(Obj) :- bag(BagList),
						isdrink(Obj),
						isMember(Obj, BagList),
						thirsty(T),
						T < 100,
						_NewT is T + 2,
						delElmt(Obj, BagList, NBagList),
						retract(thirsty(_OldT)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(thirsty(_NewT)),nl,
						write('Alice drinks '), write(Obj), nl,
						writeln('Sluuurrpp! :)'),!.

use(Obj) :- bag(BagList),
						ismedicine(Obj),
						isMember(Obj, BagList),
						health(H),
						H == 100,nl,
						writeln('Alice : No, I don\'t need this now'),!.

use(Obj) :- bag(BagList),
						ismedicine(Obj),
						isMember(Obj, BagList),
						health(H),
						H < 100,
						_NewH is H + 4,
						_NewH > 100,
						delElmt(Obj, BagList, NBagList),
						retract(health(_OldH)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(health(100)),nl,
						write('Alice uses '), write(Obj), nl,
						writeln('I feel better now :)'),!.

use(Obj) :- bag(BagList),
						ismedicine(Obj),
						isMember(Obj, BagList),
						health(H),
						H < 100,
						_NewH is H + 4,
						delElmt(Obj, BagList, NBagList),
						retract(health(_OldH)),
						retract(bag(_B)),
						asserta(bag(NBagList)),
						asserta(health(_NewH)),nl,
						write('Alice use '), write(Obj), nl,
						writeln('I\'m feel better now :)'),!.

use(Obj) :- bag(BagList),
						isweapon(Obj),
						isMember(Obj, BagList),
						weapon(Weapon),
						islistkosong(Weapon),
						retract(weapon(_)),
						delElmt(Obj, BagList, NBagList),
						retract(bag(_B)),
						append([Obj], Weapon, _NewW),
						asserta(bag(NBagList)),
						asserta(weapon(_NewW)),nl,
						write('Now, you will use '), write(Obj), writeln(' to protect yourself from the zombie.'),!.

use(Obj) :- isweapon(Obj),
						weapon(W),
						\+islistkosong(W),nl,
						writeln('You\'re already use weapon in your hand'),!.

use(Obj) :- bag(BagList),
						\+isMember(Obj, BagList),nl,
					 write(Obj), writeln(' isn\'t available in your bag'),!.

attack	:- ingamestate(1),
					 player_pos(X,Y),
					 insidethisplace(X,Y,_,EList),
					 isEnemy(EList),
					 calcbyzombiename(EList),!.

attack :- ingamestate(1),
					 player_pos(X,Y),
					 insidethisplace(X,Y,_,EList),
					 \+isEnemy(EList),
					writeln('There is no enemy here. Be focus Alice! :(').

status :- ingamestate(1),
		weapon(WeaponList),
		health(HP),
		hunger(_H),
		thirsty(T),
		bag(BagList),
		write('Health    = '), writeln(HP),
		write('Hunger    = '), writeln(_H),
		write('Thirsty   = '), writeln(T),
		write('Weapon    = '), writelist(WeaponList),
		writeln('Inventory = '), writelist(BagList),!.

save(FileName) :- tell(FileName), listing(player_pos), listing(bag), listing(health),
				listing(hunger), listing(thirsty), listing(insidethisplace), told.

loads(FileName) :- retractall(player_pos(_,_)), retractall(bag(_)), retractall(health(_)),
				retractall(hunger(_)), retractall(thirsty(_)), retractall(insidethisplace(_,_,_,_)), [FileName].

quit :- write('Alice gives up to the Zombies. Game over.'), halt.

/* Kalkulasi serangan (zombie) */
calcbyzombiename([_H|_]) :- weapon(_W),
														islistkosong(_W),
														writeln('You can\'t attack the enemy, Alice. You must held the weapon first'),!.

calcbyzombiename([H|_]) :- zombie(H), enemypower(H, Atk),
													 weapon(W),
													 kills(K),
													 \+islistkosong(W),
													 retract(weapon(_W)),
													 asserta(weapon([])),
													 player_pos(X,Y),
													 retract(insidethisplace(X,Y,_A,_E)),
													 asserta(insidethisplace(X,Y,_A,[])),
													 health(HP),
													 _NewHP is HP - Atk,
													 _NewHP > 0,nl,
													 write('You took '), write(Atk), write(' damage!. Alice attacks '), write(H), writeln(' back!'),
													 writeln('Enemy is down!'),
													 write('Your HP is '), writeln(_NewHP),
													 retract(health(_HP)),
													 retract(kills(_K)),
													 NewK is K + 1,
													 asserta(kills(NewK)),
													 asserta(health(_NewHP)), !.

calcbyzombiename([H|_]) :-  zombie(H), enemypower(H, Atk),
 													 retract(health(_HP)),
													 _NewHP is _HP - Atk,
													 _NewHP < 1,
													 retract(win(_X)),
													 asserta(win(0)),!.

/*go_to another place with direction, 1 step Hunger-=1 dan 3 step Thirsty -= 1*/

go(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			countstep(_S),
			hunger(_H),
			_S < 2,
			path(Xa,Ya, Direction,Xb,Yb),nl,
			write('You moved to the '), writeln(Direction),
			retract(player_pos(Xa,Ya)),
			retract(hunger(__)),
			retract(countstep(_)),
			Ha is _H - 1,
			_NS is _S + 1,
			asserta(countstep(_NS)),
			asserta(hunger(Ha)),
			asserta(player_pos(Xb,Yb)),
			look, !.

go(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			countstep(_S),
			hunger(_H),
			thirsty(_T),
			_S == 2,
			path(Xa,Ya, Direction,Xb,Yb),nl,
			write('You moved to the '), writeln(Direction),
			retract(player_pos(Xa,Ya)),
			retract(hunger(_)),
			retract(countstep(__)),
			retract(thirsty(___)),
			Ta is _T - 1,
			Ha is _H - 1,
			_NS is 0,
			asserta(countstep(_NS)),
			asserta(hunger(Ha)),
			asserta(thirsty(Ta)),
			asserta(player_pos(Xb,Yb)),
			look, !.

go(Direction) :-
			ingamestate(1),
			player_pos(Xa,Ya),
			\+path(Xa,Ya, Direction,_,__),
			write('Alice, you can\'t go there!. Please return to your last location!.'),!.

go(_) :-
			ingamestate(1),
			hunger(H),
			H == 1,
			retract(win(_X)),
			asserta(win(0)),!.

go(_) :-
			ingamestate(1),
			thirsty(T),
			countstep(_S),
			_S == 2,
			T == 1,
			retract(win(_X)),
			asserta(win(0)),!.


go(_) :- ingamestate(1),
			writeln('Your inputs wrong. Undefined!.'), !.

go(_) :- ingamestate(0),
			writeln('You must start the game first!').

north :- go(north).
south :- go(south).
west :- go(west).
east :- go(east).
