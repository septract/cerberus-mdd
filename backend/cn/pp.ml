module CF = Cerb_frontend

include PPrint

(* copying from backend.ml *)
external get_terminal_size: unit -> (int * int) option = "terminal_size"

type doc = document

(* copying from backend.ml *)
let term_col = match get_terminal_size () with
  | Some (_, col) -> col - 1
  | _ -> 80 - 1

let unicode = ref true
let print_level = ref 0

(* from run_pp *)
let print channel doc = 
  PPrint.ToChannel.pretty 1.0 term_col channel (doc ^^ hardline);
  flush channel


let plain = CF.Pp_utils.to_plain_pretty_string
let (^^^) = Pp_prelude.(^^^)

(* adapting from colour.ml *)
(* and https://en.wikipedia.org/wiki/ANSI_escape_code#Colors *)

type colour =
  | Default
  | Black
  | Red
  | Green
  | Yellow
  | Blue
  | Magenta
  | Cyan
  | White

type brightness = 
  | Bright 
  | Dark

type format = 
  | BG of colour * brightness
  | FG of colour * brightness
  | Blinking
  | Underline

let bg_item_code = function
  | Default -> ""
  | Black -> "40"
  | Red -> "41"
  | Green -> "42"
  | Yellow -> "43"
  | Blue -> "44"
  | Magenta -> "45"
  | Cyan -> "46"
  | White -> "47"

let fg_item_code = function
  | Default -> ""
  | Black -> "30"
  | Red -> "31"
  | Green -> "32"
  | Yellow -> "33"
  | Blue -> "34"
  | Magenta -> "35"
  | Cyan -> "36"
  | White -> "37"


let format_item_code = function
  | Blinking -> "5"
  | Underline -> "4"
  | BG (colour,Dark) -> bg_item_code colour
  | BG (colour,Bright) -> bg_item_code colour ^ ";1"
  | FG (colour,Dark) -> fg_item_code colour
  | FG (colour,Bright) -> fg_item_code colour ^ ";1"

(* from colour.ml *)
let format_string format str =
  let code = String.concat ";" (List.map (fun z -> format_item_code z) format) ^ "m" in
  "\x1b[" ^ code ^ str ^ "\x1b[0m"

let format format string = 
  let n = String.length string in
  fancystring (format_string format string) n

let uformat format string n = 
  fancystring (format_string format string) n


type alignment = L | R

let pad_ alignment should_width has_width pp = 
  let diff = should_width - has_width in
  if diff < 0 then pp else 
    match alignment with
    | L -> pp ^^ repeat diff space
    | R -> repeat diff space ^^ pp

let pad alignment width pp = 
  pad_ alignment width (requirement pp) pp

let list f l = 
  match l with
  | [] -> !^"(empty)"
  | l -> flow_map (comma ^^ break 1) f l

let list_filtered f l = 
  match List.filter_map f l with
  | [] -> !^"(empty)"
  | l -> flow (comma ^^ break 1) l



let nats n =
  let rec aux n = if n < 0 then [] else n :: aux (n - 1) in
  List.rev (aux n)

module IntMap = Map.Make(Int)

let box_vline_n = utf8string "\u{2502}"
let box_vline_b = utf8string "\u{2503}"
let box_hline_d = utf8string "\u{2504}"
let box_hline_n = utf8string "\u{2500}"
let box_hline_b = utf8string "\u{2501}"
let box_cross_vn_hb = utf8string "\u{2542}"
let box_cross_vb_hb = utf8string "\u{254B}"


let (table2, table3, table4, table5, table6) = 
  let table (n_rows : int) (headers: string list) (lines : ((alignment * doc option) list) list) =
    let placeholder = minus ^^ minus in

    let maxes = 
      List.fold_left (fun maxes line ->
          let (_, maxes) = 
            List.fold_left (fun (j, maxes) (_alignment, o_cell) ->
                let j_max = match IntMap.find_opt j maxes with
                  | Some j_max -> j_max
                  | None -> 0
                in
                let req = match o_cell with
                  | Some cell -> requirement cell
                  | None -> requirement placeholder
                in
                let maxes = IntMap.add j (max j_max req) maxes in
                (j + 1, maxes)
              ) (0, maxes) line
          in
          maxes
        ) IntMap.empty (List.map (fun s -> (L, Some (string s))) headers :: lines) 
    in
    let oline =
      List.mapi (fun j _ ->
          repeat (IntMap.find j maxes) (box_hline_b)
        ) headers 
    in
    let sepline =
      List.mapi (fun j _ ->
          repeat (IntMap.find j maxes) (box_hline_d)
        ) headers 
    in
    let headers = 
      List.mapi (fun j h ->
          pad_ L (IntMap.find j maxes) (String.length h) (format [FG(Default,Bright)] h)
        ) headers
    in
    let padded_lines = 
      List.map (fun line ->
          List.mapi (fun j (alignment,o_cell) -> 
              match o_cell with
              | Some cell ->
                 pad alignment (IntMap.find j maxes) cell
              | None ->
                 pad alignment (IntMap.find j maxes) placeholder
            ) line
        ) lines
    in
    (* separate (minus ^^ plus ^^ minus) sepline ^^ hardline ^^ *)
    separate hardline 
      begin 
        (utf8string "\u{250F}" ^^ separate (utf8string "\u{252F}") oline ^^ utf8string "\u{2513}") ::
        (box_vline_b ^^ separate (box_vline_n) headers ^^ box_vline_b) ::
        (box_vline_b ^^ separate (box_vline_n) sepline ^^ box_vline_b) ::
        (List.map (fun line -> box_vline_b ^^ separate (box_vline_n) line  ^^ box_vline_b) padded_lines) @
        [utf8string "\u{2517}" ^^ separate (utf8string "\u{2537}") oline ^^ utf8string "\u{251B}"]
      end
  in

  let table2 (th1, th2) lines =
    table 2 [th1; th2]
      (List.map (fun (c1, c2) -> [c1; c2]) lines)
  in

  let table3 (th1, th2, th3) lines =
    table 3 [th1; th2; th3]
      (List.map (fun (c1, c2, c3) -> [c1; c2; c3]) lines)
  in

  let table4 (th1, th2, th3, th4) lines =
    table 4 [th1; th2; th3; th4]
      (List.map (fun (c1, c2, c3, c4) -> [c1; c2; c3; c4]) lines)
  in

  let table5 (th1, th2, th3, th4, th5) lines =
    table 5 [th1; th2; th3; th4; th5]
      (List.map (fun (c1, c2, c3, c4, c5) -> [c1; c2; c3; c4; c5]) lines)
  in

  let table6 (th1, th2, th3, th4, th5, th6) lines =
    table 6 [th1; th2; th3; th4; th5; th6]
      (List.map (fun (c1, c2, c3, c4, c5, c6) -> [c1; c2; c3; c4; c5; c6]) lines)
  in

  (table2, table3, table4, table5, table6)

  


let typ n typ = 
  n ^^^ colon ^^^ typ

let item item content = 
  format [FG(Default,Bright)] item ^^ colon ^^ space ^^ align content

let c_comment pp = 
  !^"/*" ^^ pp ^^ !^"*/"

let c_app f args = 
  f ^^ parens (separate (comma ^^ space) args)



let headline a = 
  (if !print_level >= 2 then hardline else empty) ^^
    format [FG(Magenta,Bright)] ("# " ^ a)

let bold a = format [FG (Default,Bright)] a

let action a = format [FG (Cyan,Dark)] ("## " ^ a ^ " ")

let debug l pp = 
  if !print_level >= l 
  then print stderr (Lazy.force pp) 

let warn pp = 
  print stderr (format [FG (Yellow,Bright)] "Warning:" ^^^ pp)





(* stealing some logic from pp_errors *)
let error (loc : Locations.t) msg extras = 
  let (head, pos) = Locations.head_pos_of_location loc in
  print stderr (format [FG (Red, Bright)] "error:" ^^^ 
                format [FG (Default, Bright)] head ^^^ msg);
  if Locations.is_unknown loc then () else print stderr !^pos;
  List.iter (fun pp -> print stderr pp) extras








(* stealing from debug_ocaml *)
let json_output_channel = ref None

let maybe_open_json_output mfile = 
  match mfile with
  | None -> 
     json_output_channel := None
  | Some file -> 
     let oc = open_out file in
     json_output_channel := Some oc;
     output_string oc "[\n"

let maybe_close_json_output () = 
  match !json_output_channel with
  | None -> 
     ()
  | Some oc -> 
     output_string oc "\n]";
     json_output_channel := None;
     close_out oc


let print_json =
  let first = ref true in
  fun json ->
  match !json_output_channel with
  | Some oc ->
     if !first then first := false else output_string oc ",\n";
     Yojson.Safe.pretty_to_channel ~std:true oc (Lazy.force json);
     output_char oc '\n'
  | _ -> ()


