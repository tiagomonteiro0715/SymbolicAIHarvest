/***
   MDE - Modelação de Dados em Engenharia
   Turno: P4

   Joao Pedro Espanhol Nogueira - jp.nogueira@campus.fct.unl.pt - https://www.linkedin.com/in/joaoespnogueira
   Tiago Capelo Monteiro        - tca.monteiro@campus.fct.unl.pt - https://www.linkedin.com/in/tiago-monteiro-
   Sander Edgar Jose Almeirao   - s.almeirao@campus.fct.unl.pt - https://www.linkedin.com/in/sander-almeir%C3%A3o-07b1ba2b8
***/

:- consult(facts).

% --- ENTITY DECLARATIONS (Dynamic) ---
:- dynamic farmer/1.           % farmer(Name)
:- dynamic farm/4.             % farm(Name, Owner, Region, TypeOfCulture)
:- dynamic distributor/4.      % distributor(Name, Region, Capacity, DemandLevel)
:- dynamic transport/6.        % transport(Name, LoadCapacity, FuelType, Range, Region, ImpactPerKm)
:- dynamic sensor_reading/3.   % sensor_reading(Farm, SensorType, Value)
:- dynamic link/3.             % link(Node1, Node2, Distance)

% ==========================================================================
% RF1: Add/update/remove a farm.
% ==========================================================================

insert_farm(Name, Owner, Region, TypeOfCulture) :-
    assertz(farm(Name, Owner, Region, TypeOfCulture)),
    nl, listing(farm).
insert_farm(_) :- write('##Invalid Farm!').

remove_farm(Name) :-
    retractall(farm(Name, _, _, _)),
    write('Farm removed.'), nl, listing(farm).

update_farm(Name, NewOwner, NewRegion, NewCulture) :-
    retractall(farm(Name, _, _, _)),
    assertz(farm(Name, NewOwner, NewRegion, NewCulture)),
    write('Farm updated: '), write(Name), write(' -> '),
    write(NewOwner), write(', '), write(NewRegion), write(', '), write(NewCulture), nl.

read_insert_farms :-
    write('Insert farm: (Name, Owner, Region, Type_of_culture)'), nl,
    write('Type end. to finish'), nl,
    read(Input), handle_input_farm(Input).

handle_input_farm(end):- write('Finished inserting farms'), nl.
handle_input_farm((Name,Owner,Region,TypeOfCulture)):-
    insert_farm(Name,Owner,Region,TypeOfCulture),
    read_insert_farms.
handle_input_farm(_):- write('## Invalid input! Try again.'),nl, read_insert_farms.

% ==========================================================================
% RF2: Add/update/remove sensors from a farm.
% ==========================================================================

insert_sensor(F,T,V):- assertz(sensor_reading(F,T,V)),nl, listing(sensor_reading).
insert_sensor(_):- write('## Invalid Sensor!').

remove_sensor(Farm,Type) :-
    retractall(sensor_reading(Farm,Type, _)),
    write('Sensor removed.'), nl, listing(sensor_reading).

update_sensor_reading(Farm,Type,Value):-
    retractall(sensor_reading(Farm,Type,_)),
    assertz(sensor_reading(Farm,Type,Value)),
    write('Sensor updated:'),write(Farm),write(','),write(Type),write(','),write(Value).

read_insert_sensor :-
    write('Insert sensor: (Farm, Type of sensor, Value).'), nl,
    write('Type end. to finish.'), nl,
    read(Input), handle_input_sensors(Input).
handle_input_sensors(end) :- write('Finished inserting Sensors.'), nl.
handle_input_sensors((Farm,T,Value)) :- insert_sensor(Farm,T,Value), read_insert_sensor.
handle_input_sensors(_) :- write('## Invalid input! Try again.'), nl, read_insert_sensor.

% ==========================================================================
% RF3: Add/update/remove farmers, distributors and transporters.
% ==========================================================================

% -- FARMERS --
insert_farmer(Name) :-
    assertz(farmer(Name)),
    nl, listing(farmer).
insert_farmer(_) :- write('## Invalid data!').

remove_farmer(Name) :-
    retractall(farmer(Name)),
    write('Farmer removed.'), nl, listing(farmer).

read_insert_farmers :-
    write('Insert farmer: (name).'), nl,
    write('Type end. to finish.'), nl,
    read(Input), handle_input_farmer(Input).
handle_input_farmer(end):- write('Finished inserting farmers.'), nl.
handle_input_farmer(Name):- insert_farmer(Name), read_insert_farmers.
handle_input_farmer(_):- write('## Invalid input! Try again.'), nl, read_insert_farmers.

% -- DISTRIBUTORS --
insert_distributor(Name,Region,Capacity,Demand):-
    assertz(distributor(Name,Region,Capacity,Demand)), nl, listing(distributor).
insert_distributor(_):- write('##invalid distributor!').
remove_distributor(Name) :-
    retractall(distributor(Name, _, _, _)),
    write('Distributor removed.'), nl, listing(distributor).
read_insert_distributor :-
    write('Insert distributor: (Name, Region, Capacity, Demand).'), nl,
    write('Type end. to finish.'), nl,
    read(Input), handle_input_distributors(Input).
handle_input_distributors(end) :- write('Finished inserting distributors.'), nl.
handle_input_distributors((Name,Region,Capacity,Demand)) :- insert_distributor(Name,Region,Capacity,Demand), read_insert_distributor.
handle_input_distributors(_) :- write('## Invalid input! Try again.'), nl, read_insert_distributor.

% -- TRANSPORTERS --
insert_transporter(Name, LoadCapacity, FuelType, Range, Region, Impact) :-
    assertz(transport(Name, LoadCapacity, FuelType, Range, Region, Impact)),
    nl, listing(transport).
insert_transporter(_):- write('##invalid Transport!').
remove_transport(Name) :-
    retractall(transport(Name,_, _, _, _, _)),
    write('Transporter removed.'), nl, listing(transport).
read_insert_transporter :-
    write('Insert transporter: (Name, Capacity, FuelType, Range, Region, Impact).'), nl,
    write('Type end. to finish.'), nl,
    read(Input), handle_input_transporters(Input).
handle_input_transporters(end) :- write('Finished inserting Transporters.'),nl.
handle_input_transporters((Name,Capacity,FuelType,Range,Region,Impact)) :-
    insert_transporter(Name,Capacity,FuelType,Range,Region,Impact), read_insert_transporter.
handle_input_transporters(_) :- write('## Invalid input! Try again.'),nl, read_insert_transporter.

% ==========================================================================
% RF4: Add/Remove Links (based on distances)
% ==========================================================================

add_link(A, B, Dist) :-
    atom(A), atom(B), number(Dist),
    assertz(link(A, B, Dist)),
    write('Link added: '), write(A), write(' -> '), write(B), write(' ('), write(Dist), write(')'), nl.

remove_link(A, B) :-
    retractall(link(A, B, _)),
    retractall(link(B,A,_)),
    write('Link removed: '), write(A), write(' -> '), write(B), nl.

% ==========================================================================
% RF5: Register or update sensor/water consumption
% ==========================================================================

register_or_update_reading(Farm, Type, Value) :-
    retractall(sensor_reading(Farm, Type, _)),
    assertz(sensor_reading(Farm, Type, Value)),
    write('Sensor reading recorded: '), write(Farm), write(', '), write(Type), write(' = '), write(Value), nl.

register_or_update_water_consumption(Farm, Culture, Water) :-
    retractall(water_consumption(Farm, Culture, _)),
    assertz(water_consumption(Farm, Culture, Water)),
    write('Water consumption recorded: '), write(Farm), write(', '), write(Culture), write(' = '), write(Water), nl.

% ==========================================================================
% RF6: List sensors per farm + farmer.
% ==========================================================================

list_farm_sensors(Farm) :-
    farm(Farm, Farmer, Region, _),
    write('Farmer: '), write(Farmer), nl,
    write('Region: '), write(Region), nl,
    write('Sensors for farm: '), write(Farm), nl,
    forall(sensor_reading(Farm, Type, Value),
           (write(' - '), write(Type), write(': '), write(Value), nl)).

% ==========================================================================
% RF7: List transporters available in region.
% ==========================================================================

available_transporters(Region) :-
    write('Available transporters in region: '), write(Region), nl,
    forall((transport(Name, _, _, _, Region, _)),
           (write(' - '), write(Name), nl)).

% ==========================================================================
% RF8: Most recent sensor readings.
% ==========================================================================

latest_readings :-
    write('Latest sensor readings:'), nl,
    forall(sensor_reading(Farm, Type, Value),
           (write(Farm), write(' -> '), write(Type), write(': '), write(Value), nl)).

% ==========================================================================
% RF9: Water consumption by farm or by crop.
% ==========================================================================

water_consumption_by_farm :-
    write('Water consumption per farm:'), nl,
    forall(sensor_reading(Farm, water, Value),
           (write(Farm), write(': '), write(Value), write(' L'), nl)).

water_consumption_by_crop :-
    write('Water consumption per crop type:'), nl,
    forall((farm(Farm, _, _, Type), sensor_reading(Farm, water, Value)),
           (write(Type), write(' ('), write(Farm), write('): '), write(Value), write(' L'), nl)).

% ==========================================================================
% RF10: List sensors with critical values (humidity, temperature)
% ==========================================================================

list_critical_sensors :-
    write('Critical sensor readings:'), nl,
    forall((sensor_reading(Farm, humidity, H), H < 30),
           (write('Humidity too low at '), write(Farm), write(': '), write(H), write('%'), nl)),
    forall((sensor_reading(Farm, temperature, T), T > 35),
           (write('Temperature too high at '), write(Farm), write(': '), write(T), write('ï¿½C'), nl)).

% ==========================================================================
% RF11: Find and display the shortest route between any two nodes (farm/distributor)
% ==========================================================================

edge(A, B, D) :- link(A, B, D);link(B, A, D).
%edge(A, B, D) :- link(B, A, D).

path(Start, End, Path, TotalDistance) :-
    path(Start, End, [Start], ReversedPath, 0, TotalDistance),
    reverse(ReversedPath, Path).

path(End, End, Path, Path, Distance, Distance).
path(Current, End, Visited, FinalPath, AccDist, TotalDistance) :-
    edge(Current, Next, StepDistance),
    \+ member(Next, Visited),
    NewDist is AccDist + StepDistance,
    path(Next, End, [Next|Visited], FinalPath, NewDist, TotalDistance).

min_distance_path([P], P).
min_distance_path([[Path1,Dist1]|Rest], Best) :-
    min_distance_path(Rest, [Path2,Dist2]),
    (Dist1 =< Dist2 -> Best = [Path1,Dist1] ; Best = [Path2,Dist2]).

shortest_route(Start, End, BestPath, MinDistance) :-
    findall([Path, Dist], path(Start, End, Path, Dist), Paths),
    Paths \= [],
    min_distance_path(Paths, [BestPath, MinDistance]).

print_shortest_route(Start, End) :-
    shortest_route(Start, End, Path, Distance),
    write('Shortest path: '), write(Path), nl,
    write('Total distance: '), write(Distance), nl.

print_shortest_route(_, _) :-
    write('No route found.'), nl, fail.

% ==========================================================================
% RF12: Find and print the route between a farm and a distributor with the lowest environmental impact
% ==========================================================================

lowest_impact_route(Farm, Distributor, Load, BestPath, MinDistance, BestTransporter, MinImpact) :-
    % Get region of the origin farm
    farm(Farm, _, Region, _),
    % Get all possible paths from Farm to Distributor
    findall([Path, Dist], path(Farm, Distributor, Path, Dist), Paths),
    Paths \= [],
    % For each path, find all transporters from the same region with enough range
    findall([Path, Dist, T, EnvImpact],
        (
            member([Path, Dist], Paths),
            transport(T, Capacity, _, CoveredDistance, Region, ImpactPerKm),
            CoveredDistance >= Dist,
            Capacity >= Load,

            EnvImpact is Dist * ImpactPerKm
        ),
        Options),
    Options \= [],
    min_impact_option(Options, [BestPath, MinDistance, BestTransporter, MinImpact]).

min_impact_option([O], O).
min_impact_option([[Path1, Dist1, T1, I1]|Rest], Best) :-
    min_impact_option(Rest, [Path2, Dist2, T2, I2]),
    (I1 =< I2 -> Best = [Path1, Dist1, T1, I1] ; Best = [Path2, Dist2, T2, I2]).

print_lowest_impact_route(Farm, Distributor, Load) :-
    lowest_impact_route(Farm, Distributor, Load, Path, Distance, Transporter, Impact),
    write('Lowest impact route:'), nl,
    write('  Path:        '), write(Path), nl,
    write('  Distance:    '), write(Distance), write(' km'), nl,
    write('  Transporter: '), write(Transporter), nl,
    write('  Impact:      '), write(Impact), nl.
print_lowest_impact_route(_, _,_) :-
    write('No route with available transporter found.'), nl, fail.


%==========================================================================
% RF13: Route with mandatory distributor on the path
% ==========================================================================
% The user indicates:
% - a source (farm or node)
% - a destination (final distributor)
% - and a mandatory intermediary distributor
% The system finds:
% - the most efficient route (in total distance) that passes through this distributor

% Combines two routes (origin → distributor, distributor → destination)
% and removes the duplicate from the intermediate node.

route_with_mandatory_distributor(Start, End, MidDistributor, Path, TotalDistance) :-
    shortest_route(Start, MidDistributor, Path1, Dist1),
    shortest_route(MidDistributor, End, Path2, Dist2),
    Path1 = [_|_], Path2 = [_|_],  % garantir que ambas existem
    last(Path1, MidDistributor),
    Path2 = [MidDistributor | Tail2], %% Guarda O resto da rotae 2 em Tail2 de formas a que não haja repetição do distribuidor na rota.
    append(Path1, Tail2, Path),        % junta as duas rotas sem repetiçao do distribuidor
    TotalDistance is Dist1 + Dist2.


% Prints the route forcing it to pass through a distributor
print_route_with_mandatory_distributor(Start, End, MidDistributor) :-
    distributor(MidDistributor,_,_,_),  %Verifica se o intermédio da rota é um distribuidor
    route_with_mandatory_distributor(Start, End, MidDistributor, Path, Distance),
    write('Route with required distributor: '), write(MidDistributor), nl,
    write('  Path:     '), write(Path), nl,
    write('  Distance: '), write(Distance), write(' km'), nl.

print_route_with_mandatory_distributor(_, _, _) :-
    write('No valid route found with the specified distributor.'), nl, fail.


% ==========================================================================
% RF14: Ideal carrier for a route
% ==========================================================================

ideal_transporter(Farm, Distributor, Load, BestTransporter, BestImpact) :-
    % 1. Obtï¿½m distï¿½ncia da rota mais curta (RF11)
    shortest_route(Farm, Distributor, _, Distance),
    farm(Farm,_,FarmRegion,_),

    % 2. Lista transportadoras viï¿½veis com impacto total
    findall([Transporter, TotalImpact],
        (
            transport(Transporter, Capacity, _, Range, Region, ImpactPerKm),
            Capacity >= Load,                      % Suporta a carga?
            Region == FarmRegion,
            Range >= Distance,                     % Tem alcance?
            TotalImpact is Distance * ImpactPerKm  % Impacto total da viagem
        ),
        Transporters),

    Transporters \= [],  % Hï¿½ opï¿½ï¿½es vï¿½lidas?
    % 3. Seleciona a com menor impacto total
    find_min_impact(Transporters, BestTransporter, BestImpact).

% ---- Find the carrier with the LOWEST total impact ----
find_min_impact([[Transporter, Impact]], Transporter, Impact).  % Caso base: sï¿½ 1 opï¿½ï¿½o
find_min_impact([[T1, I1] | Rest], BestTransporter, BestImpact) :-
    find_min_impact(Rest, T2, I2),
    ( I1 < I2 ->
        BestTransporter = T1, BestImpact = I1
    ;
        BestTransporter = T2, BestImpact = I2
    ).

%----Show result----
print_ideal_transporter(Farm, Distributor, Load) :-
    ideal_transporter(Farm, Distributor, Load, Transporter, Impact),
    shortest_route(Farm, Distributor, Path, Distance),
    write('Ideal carrier: '), write(Transporter), nl,
    write(' - Route: '), write(Path), nl,
    write(' - Distance: '), write(Distance), write(' km'), nl,
    write(' - Supported load: '), write(Load), write(' kg'), nl,
    write(' - Total environmental impact: '), write(Impact), nl.

print_ideal_transporter(_, _, _) :-
    write('Error: No transporter found for criteria.'), nl.

%---------------------------------------------------------------------------------
% RF15: Alert Farmers of Critical ph Conditions
%---------------------------------------------------------------------------------

alert_farmers_ph_critical :-
    write('Critical ph alerts for farmers:'), nl,

    forall((sensor_reading(Farm, ph, PH), (PH < 5.5 ; PH > 8.0),
            farm(Farm, Farmer, _, _)),
           (write('ALERT: Abnormal pH at '), write(Farm), write(' (Farmer: '), write(Farmer), write(') - pH: '), write(PH), nl)).


% ---------------------------------MENU-----------------------------------


menu_title :-
    nl,
    write('Best menu in the world!'), nl,
    menu(Op),
    execute(Op).

menu(Op) :-
    write('0 -> Exit'), nl,
    write('1 -> Add/change/remove a farm in the network.'), nl,
    write('2 -> Add/change/remove environmental sensors associated with a farm'), nl,
    write('3 -> Add/change/remove Farmers, Distributors or Transporters'), nl,
    write('4 -> Add/change/remove connections between network nodes'), nl,
    write('5 -> Record and update sensor readings (temperature, humidity, etc.) and water consumption per farm or culture.'), nl,
    write('6 -> List sensors associated with a specific farm identifying the producer'), nl,
    write('7 -> List available carriers for a a certain area or region'), nl,
    write('8 -> Consult the most recent sensor readings'), nl,
    write('9 -> Check water consumption by crop or by farm'), nl,
    write('10 -> List sensors that exceed critical thresholds'), nl,
    write('11 -> Routes and transports'), nl,
    write('15 -> Alert farmers ph critical'), nl,
    read(Op).



execute(0) :- !.  % finish execution

execute(Op) :-
    exec(Op), nl,
    menu(NOp),
    execute(NOp).


exec(1) :- farm_submenu.
exec(2) :- sensor_submenu.
exec(3) :- actor_submenu.
exec(4) :- link_submenu.
exec(5) :- sensor_readings_menu.
exec(6) :- list_sensors_by_farm_menu.
exec(7) :- list_carriers_by_region_menu.

exec(8) :- latest_readings.

exec(9) :- 
    water_consumption_menu.

exec(10) :- list_critical_sensors.

exec(11) :- routes_transport_menu.  % submenu call

exec(15) :- alert_farmers_ph_critical.

exec(_) :-
    write('Invalid option! Try again.'), nl.

% ===================== SUBMENUS FOR MANAGEMENT =====================

% ------- MANAGE FARM MENU (Option 1) -------
farm_submenu :-
    write('\n---- FARM MANAGEMENT ----'), nl,
    write('1. Insert Farms'), nl,
    write('2. Remove Farm'), nl,
    write('3. Update Farm'), nl,
    write('4. Back to Main Menu'), nl,
    read(Option), handle_farm_option(Option).

handle_farm_option(1) :- read_insert_farms.
handle_farm_option(2) :-
    write('Enter farm name to remove: '), read(Name),
    remove_farm(Name).
handle_farm_option(3) :-
    write('Enter (Name, NewOwner, NewRegion, NewCulture): '), read((N, O, R, C)),
    update_farm(N, O, R, C).
handle_farm_option(4) :- menu_title.
handle_farm_option(_) :- write('Invalid option.'), nl, farm_submenu.

% ------- MANAGE SENSORS MENU (Option 2) -------
sensor_submenu :-
    write('\n---- SENSOR MANAGEMENT ----'), nl,
    write('1. Insert Sensors'), nl,
    write('2. Remove Sensor'), nl,
    write('3. Update Sensor'), nl,
    write('4. Back to Main Menu'), nl,
    read(Option), handle_sensor_option(Option).

handle_sensor_option(1) :- read_insert_sensor.
handle_sensor_option(2) :-
    write('Enter (Farm, Type) to remove: '), read((F, T)),
    remove_sensor(F, T).
handle_sensor_option(3) :-
    write('Enter (Farm, Type, Value) to update: '), read((F, T, V)),
    update_sensor_reading(F, T, V).
handle_sensor_option(4) :- menu_title.
handle_sensor_option(_) :- write('Invalid option.'), nl, sensor_submenu.


% ------- MANAGE ACTORS MENU (Option 3) -------
actor_submenu :-
    nl,
    write('=== ACTORS MANAGEMENT MENU ==='), nl,
    write('1 -> Manage Farmers'), nl,
    write('2 -> Manage Distributors'), nl,
    write('3 -> Manage Transporters'), nl,
    write('4 -> Back to Main Menu'), nl,
    read(Option),
    handle_actor_option(Option).

handle_actor_option(1) :- farmer_submenu.
handle_actor_option(2) :- distributor_submenu.
handle_actor_option(3) :- transporter_submenu.
handle_actor_option(4) :- menu_title.
handle_actor_option(_) :-
    write('Invalid option. Try again.'), nl,
    actor_submenu.


% Submenu for managing farmers
farmer_submenu :-
    write('\n---- FARMER MANAGEMENT ----'), nl,
    write('1. Insert Farmers'), nl,
    write('2. Remove Farmer'), nl,
    write('3. Back to Actor Menu'), nl,
    read(Option), handle_farmer_option(Option).

handle_farmer_option(1) :- read_insert_farmers.
handle_farmer_option(2) :-
    write('Enter name to remove: '), read(Name),
    remove_farmer(Name).
handle_farmer_option(3) :- actor_submenu.
handle_farmer_option(_) :- write('Invalid option.'), nl, farmer_submenu.




% Submenu for managing distributors
distributor_submenu :-
    write('\n---- DISTRIBUTOR MANAGEMENT ----'), nl,
    write('1. Insert Distributors'), nl,
    write('2. Remove Distributor'), nl,
    write('3. Back to Actor Menu'), nl,
    read(Option), handle_distributor_option(Option).

handle_distributor_option(1) :- read_insert_distributor.
handle_distributor_option(2) :-
    write('Enter name to remove: '), read(Name),
    remove_distributor(Name).
handle_distributor_option(3) :- actor_submenu.
handle_distributor_option(_) :- write('Invalid option.'), nl, distributor_submenu.


% Submenu for managing transporters
transporter_submenu :-
    write('\n---- TRANSPORTER MANAGEMENT ----'), nl,
    write('1. Insert Transporters'), nl,
    write('2. Remove Transporter'), nl,
    write('3. Back to Actor Menu'), nl,
    read(Option), handle_transporter_option(Option).

handle_transporter_option(1) :- read_insert_transporter.
handle_transporter_option(2) :-
    write('Enter name to remove: '), read(Name),
    remove_transport(Name).
handle_transporter_option(3) :- actor_submenu.
handle_transporter_option(_) :- write('Invalid option.'), nl, transporter_submenu.


% ------- MANAGE LINKS MENU (Option 4) -------
% Submenu for managing links
link_submenu :-
    write('\n---- LINK MANAGEMENT ----'), nl,
    write('1. Add Link'), nl,
    write('2. Remove Link'), nl,
    write('3. Back to main menu'), nl,
    read(Option), handle_link_option(Option).

handle_link_option(1) :-
    write('Enter (Node1, Node2, Distance): '), read((A, B, D)),
    add_link(A, B, D).
handle_link_option(2) :-
    write('Enter (Node1, Node2) to remove: '), read((A, B)),
    remove_link(A, B).
handle_link_option(3) :- menu_title.
handle_link_option(_) :- write('Invalid option.'), nl, link_submenu.




% ------- SENSOR READINGS MENU (Option 5) -------
sensor_readings_menu :-
    nl,
    write('=== Sensor Readings Management ==='), nl,
    write('1. Record/Update sensor reading'), nl,
    write('2. Record/Update water consumption'), nl,
    write('3. Back to main menu'), nl,
    read(Op),
    execute_sensor_readings(Op).

execute_sensor_readings(1) :-
    write('Enter (Farm, SensorType, NewValue): '), read((Farm, Type, Value)),
    register_or_update_reading(Farm, Type, Value),
    sensor_readings_menu.

execute_sensor_readings(2) :-
    write('Enter (Farm, Culture, WaterConsumption): '), read((Farm, Culture, Water)),
    register_or_update_water_consumption(Farm, Culture, Water),
    sensor_readings_menu.

execute_sensor_readings(3) :-
    menu_title.

execute_sensor_readings(_) :-
    write('Invalid option! Try again.'), nl,
    sensor_readings_menu.



% ------- LIST SENSORS BY FARM MENU (Option 6) -------
list_sensors_by_farm_menu :-
    nl,
    write('=== List Sensors by Farm ==='), nl,
    write('Enter farm name: '), read(Farm),
    list_farm_sensors(Farm),
    menu_title.



% ------- LIST CARRIERS BY REGION MENU (Option 7) -------
list_carriers_by_region_menu :-
    nl,
    write('=== List Carriers by Region ==='), nl,
    write('Enter region or area: '), read(Region),
    available_transporters(Region),
    menu_title.
    

    
% ------- WATER CONSUMPTION MENU (Option 9) -------
water_consumption_menu :-
    nl,
    write('=== Water Consumption Menu ==='), nl,
    write('1. Water consumption by farm'), nl,
    write('2. Water consumption by crop'), nl,
    write('3. Back to main menu'), nl,
    read(Op),
    execute_water_consumption(Op).

execute_water_consumption(1) :-
    water_consumption_by_farm,
    water_consumption_menu.

execute_water_consumption(2) :-
    water_consumption_by_crop,
    water_consumption_menu.

execute_water_consumption(3) :-
    menu_title.

execute_water_consumption(_) :-
    write('Invalid option! Try again.'), nl,
    water_consumption_menu.







% ------- Routes and transports menu -------
routes_transport_menu :-
    nl,
    write('=== Routes and Transports ==='), nl,
    write('1 -> Shortest Route (RF11)'), nl,
    write('2 -> Route with less inviromental impact (RF12)'), nl,
    write('3 -> Route with a mandatory intermediate distributor(RF13)'), nl,
    write('4 -> Ideal Transport based on a given route and criteria(RF14)'), nl,
    write('5 -> Back to the main menu'), nl,
    read(Op),
    execute_routes_op(Op).

execute_routes_op(5) :- menu_title.  % Return to main menu

execute_routes_op(Op) :-
    exec_routes(Op),
    routes_transport_menu.  % Stay in submenu until back

exec_routes(1) :-  % RF11
    write('Start: '), read(Start),
    write('End: '), read(End),
    print_shortest_route(Start, End).

exec_routes(2) :-  % RF12
    write('Farm: '), read(Farm),
    write('Distributor: '), read(Distributor),
    write('Load (kg): '), read(Load),
    print_lowest_impact_route(Farm, Distributor, Load).

exec_routes(3) :-  % RF13
    write('Start: '), read(Start),
    write('End: '), read(End),
    write('Distributor intermédio: '), read(Mid),
    print_route_with_mandatory_distributor(Start, End, Mid).

exec_routes(4) :-  % RF14
    write('Farm: '), read(Farm),
    write('Distributor: '), read(Distributor),
    write('Load (kg): '), read(Load),
    print_ideal_transporter(Farm, Distributor, Load).

exec_routes(5) :-
    menu_title.

exec_routes(_) :-
    write('Wrong option!'), nl.
