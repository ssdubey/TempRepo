for Irmin master

(*add in ao*)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;



module Store_module = Irmin_mem.Append_only (Irmin.Contents.String) (Irmin.Contents.String);;
let conf = Irmin_mem.config ();;
let session = Lwt_main.run @@ Store_module.v conf;;
let bat = Store_module.batch session (fun sm -> Store_module.add sm "key" "value");;

(*-----------------------------------------------------------*)
(* set in aw *) 

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;

let config = Irmin_mem.config () ;;

let aw_t = Lwt_main.run @@ RW_module.v config ;;

let _ = RW_module.set aw_t "master" "key" ;;

(*-----------------------------------------------------------*)
(* test n set in aw *) 

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;

let config = Irmin_mem.config () ;;

let aw_t = Lwt_main.run @@ RW_module.v config ;;

let _ = RW_module.test_and_set aw_t "master" ~test:(Some "key") ~set:(Some "value");;


(*-----------------------------------------------------------*)
(* find in aw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.find aw_t "master";;

(* match findval with 
  | Some x -> (
        let valStr = Irmin.Type.to_string Irmin.Type.string x in 
            print_string ("\nResult = " ^ valStr);
	        print_string ("\nLength ="); print_int(String.length valStr);
      )
  | _ -> () *)

(*-----------------------------------------------------------*)
(*  mem in rw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.mem aw_t "master";;

(*-----------------------------------------------------------*)
(* list in aw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let lst = Lwt_main.run @@ RW_module.list aw_t;;

List.fold_left (fun () -> 
	(Irmin.Type.to_string (Irmin.Contents.String.t);print_string)) () lst;;

(*-----------------------------------------------------------*)
(* remove in aw *)

#require "digestif.ocaml";;
#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;

module RW_module = Irmin_mem.Atomic_write (Irmin.Contents.String) (Irmin.Contents.String);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let _ = RW_module.remove aw_t "master1";;

-----------------------------------------------------------------------------
for Irmin 1.3.3.
(* set in ao *) 

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module Store_module = Irmin_mem.AO (Irmin.Hash.SHA1) (Irmin.Contents.String);;
module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;

let config = Irmin_mem.config () ;;
let hashtable = Lwt_main.run @@ Store_module.v config ;;

let key = Lwt_main.run  (Store_module.add hashtable "emp6") ;;

let aw_t = Lwt_main.run @@ RW_module.v config ;;

let _ = RW_module.set aw_t "master" key ;;


(*-----------------------------------------------------------*)
(* find in rw *)

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.find aw_t "master";;

match findval with 
  | Some x -> (
        let valcs = Irmin.Type.encode_cstruct Irmin.Hash.SHA1.t x in 
        let valStr = Cstruct.to_string valcs in 
	        print_string ("\nResult = " ^ valStr);
	        print_string ("\nLength ="); print_int(String.length valStr);
      )
  | _ -> ()

(*-----------------------------------------------------------*)
(* test_and_set in rw which involves set in ao and find in rw *)

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module Store_module = Irmin_mem.AO (Irmin.Hash.SHA1) (Irmin.Contents.String);;
module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;

let config = Irmin_mem.config () ;;
let hashtable = Lwt_main.run @@ Store_module.v config ;;
let key1 = Lwt_main.run  (Store_module.add hashtable "emp1") ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let _ = RW_module.set aw_t "master" key1 ;;

RW_module.test_and_set aw_t "master" ~test:(Some key1) ~set:(Some key1);;

(*-----------------------------------------------------------*)
(* list in rw *)

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let _ = RW_module.list aw_t;;

(*-----------------------------------------------------------*)
(*  mem in rw *)

#require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Hash.SHA1);;
let config = Irmin_mem.config () ;;
let aw_t = Lwt_main.run @@ RW_module.v config ;;
let findval = Lwt_main.run @@ RW_module.mem aw_t "master";;

(* match findval with 
  | Some x -> (
        let valcs = Irmin.Type.encode_cstruct Irmin.Hash.SHA1.t x in 
        let valStr = Cstruct.to_string valcs in 
	        print_string ("\nResult = " ^ valStr);
	        print_string ("\nLength ="); print_int(String.length valStr);
      )
  | _ -> () *)

(*-----------------------------------------------------------*)

(* let cstruct = Irmin.Hash.SHA1.to_raw key ;; *)
(* let cstruct = Irmin.Hash.SHA1.to_raw_int key ;;
let str = Cstruct.to_string cstruct ;;
let key2 = String.sub str 8 ((String.length str) - 8) ;; *)







(* #require "lwt.unix";;
#require "irmin";;
#require "irmin-mem";;


open Lwt_main;;
open Irmin;;
open Irmin_mem;;

module Store_module = Irmin_mem.AO (Irmin.Hash.SHA1) (Irmin.Contents.String);;
module RW_module = Irmin_mem.RW (Irmin.Contents.String) (Irmin.Contents.String);;

let config = Irmin_mem.config () in
let hashtable = Lwt_main.run @@ Store_module.v config in
let key = Lwt_main.run  (Store_module.add hashtable "2 emp2 dept2") in 

let aw_t = Lwt_main.run @@ RW_module.v config in

(* let cstruct = Irmin.Type.encode_cstruct Store_module.key key in  *)
let cstruct = Irmin.Hash.SHA1.to_raw key in
let str = Cstruct.to_string cstruct in 
let key2 = String.sub str 8 ((String.length str) - 8) in

let _ = RW_module.set aw_t "master" key2 in ()