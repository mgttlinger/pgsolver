open Paritygame;;

let generator_game_func arguments = 

	let show_help _ =
		print_string (Info.get_title "Jurdzinski Game Generator");
		print_string ("Usage: jurdzinskigame n m\n\n" ^
					  "       where (n,m) = (n,m)-th jurdzinski game\n\n")
	in

	let rec range i j = if i=j then [j] else i::(range (i+1) j) in

  if (Array.length arguments != 2) then (show_help (); exit 1);

  let d = int_of_string arguments.(0) in
  let w = int_of_string arguments.(1) in

  let name i j = 2*w*i + j in
  
  let game = pg_create (1 + name (2*d) (2*w-1)) in
  
  let make_node i prio player edges ann =
    let v = nd_make i in
    pg_set_priority game v prio;
    pg_set_owner game v player;
    pg_set_desc game v ann;
    List.iter (fun w -> pg_add_edge game v (nd_make w)) edges
  in

  let m = (2*d+2) in

  for i=0 to d-1 do
    let i'=2*i in
    for j=0 to w-1 do
      let j' = 2*j in
      make_node (name i' j') (m-i'-1) plr_Even [name (i'+1) (j'+1)] None
    done
  done;
  for i=0 to d-1 do
    let i'=2*i+1 in
    make_node (name i' 0) (m-i'-1) plr_Odd [name i' 1; name (i'-1) 0] None;
    for j=1 to w-1 do
      let j' = 2*j in
      make_node (name i' j') (m-i'-1) plr_Odd [name i' (j'-1); name i' (j'+1); name (i'-1) j'] None
    done;
    for j=0 to w-2 do
      let j' = 2*j+1 in
      make_node (name i' j') (m-i'-1) plr_Even [name i' (j'-1); name i' (j'+1); name (2*d) j'] None
    done;
    make_node (name i' (2*w-1)) (m-i'-1) plr_Even [name i' (2*w-1); name i' (2*w-2)] None
  done;

  make_node (name (2*d) 0) 0 plr_Even [name (2*d) 1] None;
  for j=1 to w-1 do
    let j' = 2*j in
    make_node (name (2*d) j') 0 plr_Even [name (2*d) (j'-1); name (2*d) (j'+1)] None
  done;
  for j=0 to w-2 do
    let j' = 2*j+1 in
    make_node (name (2*d) j') 1 plr_Odd ((name (2*d) (j'-1))::(name (2*d) (j'+1))::
                                            (List.map (fun i -> name (2*i+1) j') (range 0 (d-1)))) None
  done;
  make_node (name (2*d) (2*w-1)) 1 plr_Odd ((name (2*d) (2*w-2))::(name (2*d) (2*w-1))::
                                              (List.map (fun i -> name (2*i+1) (2*w-1)) (range 0 (d-1)))) None;
  game;;


Generators.register_generator generator_game_func "jurdzinskigame" "Jurdzinski Game";;
